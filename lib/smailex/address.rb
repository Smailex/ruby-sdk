require "smailex/util"
module Smailex
	class Address
		include Smailex::Error
		def self.create(params)

			unless (params.keys & [:country,:state,:city, :line1]).empty?
				#We have full address
				params.each do |key, value|
					check_address_presence(value)
				end

				address = {
					:zip => params[:zip],
					:country => params[:country].upcase,
					:state => params[:state].upcase,
					:city => params[:city],
					:line1 => params[:line1]
				}

				unless params[:line2].nil?
					address.merge!({:line2 => params[:line2]})
				else
					address
				end
			else
				#we have only zip
				address = {
					:zip => params[:zip]
				}
			end

		end
		
		private
		def self.check_address_presence(field)
			unless defined?(field) && (field != "")
				raise ADDRESS_PARAM_NOT_DEFINED
			end
		end

		def self.check_zip(zip)
			if zip.length < 5 
				raise WRONG_ZIP_LENGTH
			end
		end

	end
end
