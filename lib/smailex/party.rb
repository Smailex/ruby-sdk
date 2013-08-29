require "smailex/util"
require "smailex/address"
module Smailex
	class Party
		include Smailex::Error

		def self.create(params, validation)
			address = Smailex::Address.create(params[:address])

			unless  (params.keys & [:email, :name, :phone]).empty?
				# We have full address for shipment
				self.validate_phone_number(params[:phone])
				self.validate_email(params[:email]) if validation == false

				party = {
					# :email => params[:email],
					:name => params[:name],
					:phone => params[:phone],
					:address => address
				}
				unless validation
					party[:email] = params[:email]
				end
				
				if params.has_key?(:company) && params[:company] !=nil
					party.merge!(:company => params[:company])
				else
					party
				end
			else
				# we have zip only for get_rates
				party = {
					:address => address
				}
			end
		end

		private
		
		def self.validate_phone_number (phone)
			if phone.length != 10
				raise WRONG_PHONE_FORMAT
			end
		end

		def self.validate_email(email)
			unless email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
				raise WRONG_EMAIL_FORMAT
			end
			
		end

	end
end