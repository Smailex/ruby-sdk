require "weship/util"
module Weship
  class Rate
    include Weship::Error

    # used for getting simple rates
    # see https://weship.io/#docs section `rates & transit time'
    
    def self.get(params)

      request_body = {
        :from_zip => params[:from_zip],
        :to_zip => params[:to_zip]
      }

      packages = Weship::Package.construct(params[:packages])

      if params.has_key?(:residential) && params[:residential] != nil
        request_body.merge!(:residential => params[:residential])
      end

      if params.has_key?(:carrier) && params[:carrier] != nil
        carrier = Weship::Carrier.create(params[:carrier])
        request_body.merge!(:carrier => carrier)
      end

      request_body.merge!(:packages => packages)
      
      request_body
    end #get
    
  end #class
end #module