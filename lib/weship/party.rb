require "weship/util"
module Weship
  class Party
    include Weship::Error

    # used for create party (from, to) objects in shipment construction
    # see https://weship.io/#docs section `shipments'
    def self.create(params, validate=false)
      party = {
        :line1 => params[:line1].upcase,
        :city => params[:city].upcase,
        :state => params[:state].upcase,
        :zip => params[:zip],
        :country => params[:country].upcase,
        :email => params[:email],
        :name => params[:name],
        :phone => params[:phone],
      }
      
      # merge line2
      if params.has_key?(:line2) && params[:line2] !=nil
        party.merge!(:line2 => params[:line2])
      end

      #merge company
      if params.has_key?(:company) && params[:company] !=nil
        party.merge!(:company => params[:company])
      end

      #merge residential flag
      if params.has_key?(:residential) && params[:residential] !=nil
        party.merge!(:residential => params[:residential])
      end

      # if that parameter present we'll just validate party address
      # see https://weship.io/#docs section `addresses'
      if validate
        request_body = {
          :address => party
        }
        return request_body
      else
        return party
      end #if

    end #create
  end #class
end #module
