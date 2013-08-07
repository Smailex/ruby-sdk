# -*- coding: utf-8 -*-
#Require smailex utils
require 'smailex/shipment'
require 'smailex/package'
require 'smailex/party'
require 'smailex/address'
require 'smailex/service'
require 'smailex/util'
require 'smailex/order'

#require needed gems
require 'rubygems'
require 'uri'
require 'json'
require 'net/http'
require 'net/https'
require 'cgi'
require 'open-uri'

class SmailexClient
  #Smailex Live\Stage URLS
  #TODO Do not forget to change on real URLs
  STAGE_API_URL = "https://localhost:3000/api/v1"
  LIVE_API_URL = "https://smailex.com/api/v1"

  #Smailex API`s endpoints
  ENDPOINTS = {
    :shipment => {
      :create => {:name => '/shipments', :method => :post},
      :show   => {:name => '/shipments/:id', :method => :get},
      :list   => {:name => '/shipments', :method => :get},
      :rates  => {:name => '/shipments/:id/rates', :method => :get},
      :update => { :name => '/shipments/:id', :method => :put},
      :cancel => {:name => '/shipments/:id', :method => :delete},
      :validate_addresses => {:name => '/shipments/:id', :method=>:put}
      # :label => {:name => '/shipments/:id/label', :method => :get}
    },
    :order => {
      :create => {:name=>'/orders', :method => :post},
      :show => {:name => '/orders/:id', :method => :get},
      :book => {:name => '/orders/:id/book', :method => :put},
      :update => {:name => '/orders/:id', :method => :put},
      :purchase => { :name => '/orders/:id/purchase', :method => :put}
    },
    :payments =>{
      :get_cards => {:name => '/payment_cards', :method => :get},
      :get_default_card => {:name => '/payment_cards/default', :method => :get}
    }
  }

  def initialize(_client_id, _client_secret, _use_stage = true)
    @client_id = _client_id
    @client_secret = _client_secret
    @api_url = (_use_stage) ? STAGE_API_URL : LIVE_API_URL
  end

  ## #######
  #
  # Shipments
  #
  #########
  def create_shipment(type, shipment_params ={})

    if type == "box"
      shipment = Smailex::Shipment.create("box",shipment_params)
    elsif type == "envelope"
      shipment = Smailex::Shipment.create("envelope",shipment_params)
    else
      throw "Unknown package type: #{type}"
    end
       api_call(ENDPOINTS[:shipment][:create], shipment,{:authenticate=>true})
  end 

  def get_rates(id)
       api_call(ENDPOINTS[:shipment][:rates],false,{:id=>id, :authenticate=>true})
  end

  def get_shipment(id)
    api_call(ENDPOINTS[:shipment][:show],false,{:id=>id, :authenticate=>true})
  end

  def get_shipments_list
    api_call(ENDPOINTS[:shipment][:list],false,{:authenticate => true})
  end

  def update_shipment(id, shipment_params={})
    api_call(ENDPOINTS[:shipment][:update], shipment_params,{:id=>id})
  end

  def validate_address(id)
    api_call(ENDPOINTS[:shipment][:validate_addresses], {:shipment=>{}}, {:id=>id, :validate_addresses=>true})
  end

  def cancel_shipment(id)
    api_call(ENDPOINTS[:shipment][:cancel], false, {:id=>id, :authenticate=>true})
  end

  def get_label(id)

    order = get_order(id)
    order['links'].each { |link|
      if link["rel"] == "label"
        data = open(link['href']).read
        return data
      end
    }
  end

  def save_label(id, path)
    
    unless path
      raise "No PATH specified"
    end

    label_data = get_label(id)
    File.open("#{path}#{id}.pdf", "wb"){ |file| file.write label_data  }

  end

  #######
  #
  #  Orders
  #
  #######
  def create_order(order_params={})
    
    user_order = Smailex::Order.create(order_params)

    unless order_params[:payment_card_id].present? && order_params[:payment_card_id].nil?
      user_order[:user_order].merge!({:payment_card_id => get_default_card['payment_card']['id']})
    end

    api_call(ENDPOINTS[:order][:create],user_order,{:authenticate=>true})
  end

  def get_order(id)
    api_call(ENDPOINTS[:order][:show],false,{:id=>id,:authenticate=>true})
  end

  def book_order(id)
    api_call(ENDPOINTS[:order][:book], false,{:id=>id, :authenticate=>true})
  end

  def update_order(id, order_params={})
    user_order = Smailex::Order.create(order_params)
    api_call(ENDPOINTS[:order][:update],user_order,{:id=>id,:authenticate=>true})
  end

  def purchase(id)
    #Now we first book order, then purchase it.
    # book_order is now optional
    api_call(ENDPOINTS[:order][:book], false, {:id=>id, :authenticate=>true})
    api_call(ENDPOINTS[:order][:purchase], false, {:id=>id,:authenticate=>true})
  end

  

  #######
  #
  #  Cards
  #
  #######
  def get_cards
    api_call(ENDPOINTS[:payments][:get_cards],false,{:authenticate=>true})
  end

  def get_default_card
    api_call(ENDPOINTS[:payments][:get_default_card],false,{:authenticate=>true})
  end

  #make a call to the SmaileX API
  def api_call(endpoint, request_body = false, params = false, access_token = false)

    #Create the url
    endpoint_string = params ? endpoint[:name].gsub(':id', params[:id].to_s) : endpoint[:name]

    url = URI.parse(@api_url + endpoint_string)

    if params[:validate_addresses].present?
      url =  URI.parse(@api_url + endpoint_string + "?validate_addresses=true")
    end
    
    # construct the call data and access token
    call = case endpoint[:method]
    when :post
      Net::HTTP::Post.new(url.request_uri, initheader = {'Content-Type' =>'application/json', 'User-Agent' => 'SmaileX Ruby SDK'})
    when :get
      Net::HTTP::Get.new(url.request_uri, initheader = {'Content-Type' =>'application/json', 'User-Agent' => 'SmaileX Ruby SDK'})
    when :put
        Net::HTTP::Put.new(url.request_uri, initheader = {'Content-Type' =>'application/json', 'User-Agent' => 'SmaileX Ruby SDK'})
    when :delete
      Net::HTTP::Delete.new(url.request_uri, initheader = {'Content-Type' =>'application/json', 'User-Agent' => 'SmaileX Ruby SDK'})
    else
      throw "Unknown call method #{endpoint[:method]}"
    end

    if request_body
      call.body = request_body.to_json
    end

    if access_token
      call.add_field('Authorization: Bearer', access_token);
    end

    if params[:authenticate].present?
      call.basic_auth @client_id, @client_secret
    end

    # create the request object
    request = Net::HTTP.new(url.host, url.port)
    

    request.read_timeout = 30
    # request.use_ssl = true
    # make the call
    response = request.start {|http| http.request(call) }
    # returns JSON response as ruby hash
    JSON.parse(response.body) unless response.body == nil
  end

end
