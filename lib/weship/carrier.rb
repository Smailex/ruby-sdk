require "weship/util"
module Weship
  class Carrier
    include Weship::Error

    def self.create(params)
      carrier = {
        :name => params[:name].upcase,
        :service => params[:service],
        :credentials => params[:credentials].upcase
      }
      
      carrier
    end
    
  end
end