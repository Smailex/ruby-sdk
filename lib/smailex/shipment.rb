require 'smailex/package'
require 'smailex/party'
require 'smailex/util'

module Smailex
	class Shipment
		include Smailex::Error
		include Smailex::Config

		def self.create(type,params={})			
			packages = Smailex::Package.create(type,params[:packages])

			sender_party, receiver_party = nil

			[:sender, :receiver].each { |party_role|
				party = Smailex::Party.create(params[party_role])

				if party_role == :sender
					sender_party = party
				else
					receiver_party = party
				end
			}

			request_body = {
				:shipment => {
					:package_type => type,
					:packages => packages,
					:sender=> sender_party,
					:receiver => receiver_party
				}
			}	

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
