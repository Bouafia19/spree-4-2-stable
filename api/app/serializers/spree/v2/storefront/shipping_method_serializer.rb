module Spree
    module V1
        class ShippingMethodSerializer < BaseSerializer
  
          set_type :shipping_method
  
          attributes :name, :display_on, :tracking_url, :code
        end
    end
end