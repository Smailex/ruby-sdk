require "smailex/util"
module Smailex
	class Service
		include Smailex::Error

		def self.create(params, validation)
			service = {
				:carrier => params[:carrier].upcase
			}
			unless validation
				service[:code] = params[:code].upcase
			end
			service
		end
		
	end
end