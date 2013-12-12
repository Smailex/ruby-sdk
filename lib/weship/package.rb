require "weship/util"
module Weship
  class Package
    include Weship::Error

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
      
      request_body = {
        :package => package_spec
      }

      request_body
    end #create

    def self.construct(type, params=false)
     if type == "envelope"
        packages_array = params.map{|single_package|
          single_package
        }
      else
        packages_array = params.map{|single_package|
          single_package
        }
      end #if
    end #construct

    def self.track(params)
      tracking = {
        :carrier => params[:carrier],
        :tracking_number => params[:tracking_number]
      }
      tracking
    end#tracking

  end #class
end #module
