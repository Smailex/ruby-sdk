require "weship/util"
module Weship
  class Address
    include Weship::Error
    def self.create(params)

      unless (params.keys & [:country,:state,:city, :line1]).empty?
        #We have full address
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
  end
end
