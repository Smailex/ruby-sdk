require "smailex/util"
module Smailex
	class Service
		include Smailex::Error

		def self.create(params)
			service = {
				:carrier => params[:carrier].upcase,
				:code => params[:code].upcase
			}
		end
		
	end
end