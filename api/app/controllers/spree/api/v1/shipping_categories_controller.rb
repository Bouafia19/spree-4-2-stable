module Spree
    module Api
        module V1
            class ShippingCategoriesController < Spree::Api::BaseController
                def index
                    @ShippingCategories = ShippingCategory.all
                    render :json => @ShippingCategories
                end
            end
        end
    end
  end
  