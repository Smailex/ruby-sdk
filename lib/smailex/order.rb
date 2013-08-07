require "smailex/util"
module Smailex
  class Order
    include Smailex::Error
      def self.create(params)
        order = {
          :user_order => {
           :shipments => params[:shipments],
            :payment_system => params[:payment_system].upcase
          }
        }
      end

    end
end
