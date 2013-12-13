require "weship/util"
module Weship
  class Options
    include Weship::Error

    # used for create options object in shipment construction
    # see https://weship.io/#docs section `shipments'

    def self.create(params)
      # options is not required by default
      options = {}

      # merge label_type parameter if present. Default value is "pdf"
      if params.has_key?(:label_type) && params[:label_type] != nil
        options.merge!(:label_type => params[:label_type])
      end
      
      # merge label_size parameter if present. Default value is "PAPER_LETTER"
      if params.has_key?(:label_size) && params[:label_size] != nil
        options.merge!(:label_size => params[:label_size])
      end

      # merge signature_type parameter if present. Parameter is not required and may be not present by default
      if params.has_key?(:signature_type) && params[:signature_type] != nil
        options.merge!(:signature_type => params[:signature_type])
      end

      # merge saturday_delivery parameter if present. Parameter is not required and may be not present by default
      if params.has_key?(:saturday_delivery) && params[:saturday_delivery] != nil
        options.merge!(:saturday_delivery => params[:saturday_delivery])
      end

      # merge remarks parameter if present. Parameter is not required and may be not present by default
      if params.has_key?(:remarks) && params[:remarks] != nil
        options.merge!(:remarks => params[:remarks])
      end

      # merge address validation parameter if present. Parameter is not required and may be not present by default
      if params.has_key?(:validate_addresses) && params[:validate_addresses] !=nil
        options.merge!(:validate_addresses => params[:validate_addresses])
      end

      options
    end #create
  end #class
end #module
