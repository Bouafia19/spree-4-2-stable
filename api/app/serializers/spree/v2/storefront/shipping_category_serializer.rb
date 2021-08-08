module Spree
    module V1
        class ShippingCategorySerializer < BaseSerializer
  
          set_type :shipping_category
  
          attributes :name
        end
    end
end