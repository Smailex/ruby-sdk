require "weship/util"
module Weship
  class Package
    include Weship::Error

    def self.create(type, params=false)
      if type == "envelope"
        packages_array = params.map{|single_package|
          single_package
        }
      else
        packages_array = params.map{|single_package|
          single_package
        }
      end
    end
  end
end
