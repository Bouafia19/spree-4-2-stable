module Spree
    module Api
        module V1
            class ShippingCategoriesController < Spree::Api::BaseController
                def index
                    authorize! :index, ShippingCategory
                    @shipping_category = ShippingCategory.all
                    #respond_with(@shipping_category)
                        render :json => @shipping_category
                end

                def destroy
                    authorize! :destroy, shipping_category
                    shipping_category.destroy
                    respond_with(shipping_category, status: 204)
                end

                def show
                    render :json => shipping_category
                end

                def create
                    authorize! :create, ShippingCategory
                    @shipping_category = ShippingCategory.new(shipping_category_params)
                    if @shipping_category.save
                        respond_with(@shipping_category, status: 201, default_template: :show)
                    else
                        invalid_resource!(@shipping_category)
                    end
                end
          
                def update
                    authorize! :update, shipping_category
                    if shipping_category.update(shipping_category_params)
                        respond_with(shipping_category, status: 200, default_template: :show)
                    else
                        invalid_resource!(shipping_category)
                    end
                end

                private

                def shipping_category
                    @shipping_category ||= ShippingCategory.accessible_by(current_ability, :show).find(params[:id])
                end

                def shipping_category_params
                    params.require(:shipping_category)
                end
            end
        end
    end
  end
  