require 'weship/package'
require 'weship/party'
require 'weship/util'

module Weship
  class Shipment
    include Weship::Error

    def self.create(params={})
      # create packages for shipment
      if params[:package_type] == "box"
        packages = Weship::Package.construct(params[:packages])
      end

      # create parties for shipment
      from_party, to_party = nil

      [:from, :to].each { |party_role|
        party = Weship::Party.create(params[party_role], false)

        if party_role == :from
          from_party = party
        else
          to_party = party
        end
      }

      # create carrier
      carrier = Weship::Carrier.create(params[:carrier])

      #create request
      request_body = {
        :shipment => {
          :from=> from_party,
          :to => to_party,
          :package_type => params[:package_type],
          :carrier => carrier
        }
      } 

      #merge packages
      if params[:package_type] == "box"
        request_body[:shipment][:packages] = packages
      end

      # merge options
      if params.has_key?(:options) && params[:options] != nil
        options = Weship::Options.create(params[:options])
        request_body[:shipment].merge!({:options => params[:options]})
      end

      request_body

    end #create
  end
end
