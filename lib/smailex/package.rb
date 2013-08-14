require "smailex/util"
module Smailex
  class Package
    include Smailex::Error

    def self.create(type, params=false)
      self.check_type(type)
      if type == "box"
        packages_array = params.map{|single_package|
          self.check_dimensions(single_package[:dimensions])
          self.check_units(single_package[:dimensions])
          single_package
        }
      else
        packages_array = params.map{|single_package|
          single_package
        }
      end
    end

    private

    # check type of a package
    def self.check_type(type)
      unless ["box", "envelope"].include?(type)
        raise WRONG_PACKAGE_TYPE
      end
    end

    # Check that arg is a number
    def self.numeric?(arg)
      !(arg.to_s =~ /^-?[0-9]+(\.[0-9]*)?$/).nil?
    end

    #check dimensions is numeric
    def self.check_dimensions(dimensions_params)
      [:length, :height, :width, :weight].each {|dim|
        raise WRONG_DIMENSIONS unless numeric?(dimensions_params[dim])
      }
    end

    #check units type is not nil
    def self.check_units(dimensions)
      units = dimensions[:units]
      if units.nil? && !units.is_a?(String) && !['imperial', 'metric'].include?(units)
        raise WRONG_UNITS
      end
    end

  end
end
