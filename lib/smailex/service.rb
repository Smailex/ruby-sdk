require "smailex/util"
module Smailex
	class Service
		include Smailex::Error

		def self.create(params)
			service = {
				:carrier => params[:carrier].upcase
			}
			unless params[:code].nil?
				service[:code] = params[:code].upcase
			end
			service
		end
		
	end
end