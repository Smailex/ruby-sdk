require 'weship/package'
require 'weship/party'
require 'weship/util'

module Weship
  class Shipment
    include Weship::Error

    def self.create(type,params={})
      if type == "box"
        packages = Weship::Package.create(type,params[:packages])
      end

      from_party, to_party = nil

      [:from, :to].each { |party_role|
        party = Weship::Party.create(params[party_role], false)

        if party_role == :from
          from_party = party
        else
          to_party = party
        end
      }

      request_body = {
        :shipment => {
          :package_type => type,
          :from=> from_party,
          :to => to_party
        }
      } 

      if type == "box"
        request_body[:shipment][:packages] = packages
      end


      if params[:service].present?
        request_body[:shipment].merge!({:service => params[:service]})
      end

      if params[:signature_type].present?
        request_body[:shipment][:signature_type] = params[:signature_type]
      end

      request_body

    end
  end
end
