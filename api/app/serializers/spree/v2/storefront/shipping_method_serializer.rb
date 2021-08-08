module Spree
    module V2
        module Storefront
            class ShippingMethodSerializer < BaseSerializer
    
            set_type :shipping_method
    
            attributes :name, :display_on, :tracking_url, :code
            end
        end
    end
end