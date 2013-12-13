require "weship/util"
module Weship
  class Package
    include Weship::Error

    # creates package for user
    # see https://weship.io/#docs section `packages'
    def self.create(params)
      package_spec = {
        :title => params[:title],
        :width => params[:width],
        :length => params[:length],
        :height => params[:height],
      }
      
      # optional parameter dimensional_units
      if params.has_key?(:dimension_units) && params[:dimension_units] !=nil
        package_spec.merge!(:dimension_units => params[:dimension_units])
      end

      # optional parameter weight_units
      if params.has_key?(:weight_units) && params[:weight_units] !=nil
        package_spec.merge!(:weight_units => params[:weight_units])
      end
      
      request_body = {
        :package => package_spec
      }

      request_body
    end #create


    # used for create packages array in shipment construction
    # see https://weship.io/#docs section `shipments'
    def self.construct(params)
        packages_array = params.map{|single_package|
          single_package
        }
    end #construct


    # used for track package
    # see https://weship.io/#docs section `tracking'
    def self.track(params)
      tracking = {
        :carrier => params[:carrier],
        :tracking_number => params[:tracking_number]
      }
      tracking
    end#track

  end #class
end #module
