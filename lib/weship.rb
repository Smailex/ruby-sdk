# -*- coding: utf-8 -*-
#Require weship utils
require 'weship/shipment'
require 'weship/package'
require 'weship/party'
require 'weship/carrier'
require 'weship/options'
require 'weship/rate'
require 'weship/util'

#require needed gems
require 'rubygems'
require 'uri'
require 'json'
require 'net/http'
require 'net/https'
require 'cgi'
require 'open-uri'

class WeshipClient
  #Weship Live\Stage URLS
  #TODO Do not forget to change on real URLs
  STAGE_API_URL = "https://stage.weship.io/api/v1"
  LIVE_API_URL = "https://weship.io/api/v1"

  #Weship API`s endpoints
  ENDPOINTS = {
    :shipment => {
      :create => {:name => '/shipments', :method => :post},
      :show   => {:name => '/shipments/:id', :method => :get},
      :list   => {:name => '/shipments', :method => :get},
      :update => { :name => '/shipments/:id', :method => :put},
      :cancel => {:name => '/shipments/:id', :method => :delete},
      :buy => {:name => '/shipments/:id/buy', :method => :put},
      :purchase => {:name => '/shipments/purchase', :method => :post},
      :rates=>{:name=>'/shipments/rates', :method => :post}
    },
    :address =>{
      :validate => {:name => '/validate', :method => :post}
    },
    :package => {
      :create => {:name => '/packages', :method => :post},
      :update => {:name => '/packages/:id', :method => :put},
      :list => {:name => '/packages', :method => :get},
      :show => {:name => '/packages/:id', :method => :get},
      :delete => {:name => '/packages/:id', :method => :delete},
      :track => {:name => '/track', :method => :post}

    }
  }

  def initialize(_client_id = false, _use_stage = true)
    @client_id = _client_id
    @api_url = (_use_stage) ? STAGE_API_URL : LIVE_API_URL
  end

  ## #######
  # Shipments
  #########
  def create_shipment(shipment_params ={})
      shipment = Weship::Shipment.create(shipment_params)
      api_call(ENDPOINTS[:shipment][:create], shipment, {}, access_token=@client_id)
  end 

  def get_rates(id)
       api_call(ENDPOINTS[:shipment][:rates],false,{:id=>id}, access_token=@client_id)
  end

  def get_shipment(id)
    api_call(ENDPOINTS[:shipment][:show],false,{:id=>id}, access_token=@client_id)
  end

  def get_shipments_list
    api_call(ENDPOINTS[:shipment][:list],false,{}, access_token=@client_id)
  end

  def update_shipment(id, shipment_params={})
    api_call(ENDPOINTS[:shipment][:update], shipment_params,{:id=>id}, access_token=@client_id)
  end

  def validate_address(id)
    api_call(ENDPOINTS[:shipment][:validate_addresses], {:shipment=>{}}, {:id=>id, :validate_addresses=>true}, access_token=@client_id)
  end

  def cancel_shipment(id)
    api_call(ENDPOINTS[:shipment][:cancel], false, {:id=>id}, access_token=@client_id)
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
#  Rates
#######

def get_rates(params)
  rates = Weship::Rate.get(params)
  api_call(ENDPOINTS[:shipment][:rates], rates, {}, access_token = @client_id)
end

#######
#  Packages
#######

  def create_package(package_params)
    package = Weship::Package.create(package_params)
    api_call(ENDPOINTS[:package][:create], package, {}, access_token=@client_id)
  end

  def get_packages_list
    api_call(ENDPOINTS[:package][:list], {}, {}, access_token = @client_id)
  end

  def show_package(id)
    api_call(ENDPOINTS[:package][:show], {}, {:id=>id}, access_token=@client_id)
  end

  def update_package(id, package_params)
    request_body = { :package => package_params}
    api_call(ENDPOINTS[:package][:update], request_body, {:id=>id}, access_token=@client_id)
  end

  def delete_package(id)
    api_call(ENDPOINTS[:package][:delete], {},{:id=>id}, access_token=@client_id)
  end

  def track_package(tracking_params)
    tracking = Weship::Package.track(tracking_params)
    api_call(ENDPOINTS[:package][:track], tracking, {}, api_call = @client_id)
  end

#######
#  address
#######

  def validate_address (address_params, validate=true)
    address = Weship::Party.create(address_params, validate=true)
    p address
    api_call(ENDPOINTS[:address][:validate], address, {}, access_token=@client_id)
  end




  #make a call to the Weship API
  def api_call(endpoint, request_body = false, params = false, access_token = false)

    #Create the url
    endpoint_string = params ? endpoint[:name].gsub(':id', params[:id].to_s) : endpoint[:name]

    url = URI.parse(@api_url + endpoint_string)

    # construct the call data and access token
    call = case endpoint[:method]
    when :post
      Net::HTTP::Post.new(url.request_uri, initheader = {'Content-Type' =>'application/json', 'User-Agent' => 'Weship Ruby SDK'})
    when :get
      Net::HTTP::Get.new(url.request_uri, initheader = {'Content-Type' =>'application/json', 'User-Agent' => 'Weship Ruby SDK'})
    when :put
        Net::HTTP::Put.new(url.request_uri, initheader = {'Content-Type' =>'application/json', 'User-Agent' => 'Weship Ruby SDK'})
    when :delete
      Net::HTTP::Delete.new(url.request_uri, initheader = {'Content-Type' =>'application/json', 'User-Agent' => 'Weship Ruby SDK'})
    else
      throw "Unknown call method #{endpoint[:method]}"
    end

    if request_body
      call.body = request_body.to_json
    end

    if access_token
      call.add_field("Authorization" ,"Token token=#{access_token}" );
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
