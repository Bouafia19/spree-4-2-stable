module Spree
    module Api
      module V1
        class TaxCategoriesController < Spree::Api::BaseController
          before_action :find_taxCategory, only: [:show, :update, :destroy]
  
          def index
            @taxCategories = Spree::TaxCategory.accessible_by(current_ability)
  
            @taxCategories = if params[:ids]
                            @taxCategories.where(id: params[:ids].split(',').flatten)
                          else
                            @taxCategories.ransack(params[:q]).result
                          end
  
            @taxCategories = @taxCategories.page(params[:page]).per(params[:per_page])
            render :json => @taxCategories
            #respond_with(@taxCategories)
          end
  
          def show
            render :json => @taxCategory
            #respond_with(@taxCategory)
          end
  
          def new; end
  
          def create
            authorize! :create, TaxCategory
            @taxCategory = Spree::TaxCategory.new(taxCategory_params)
            if @taxCategory.save
              respond_with(@taxCategory, status: 201, default_template: :show)
            else
              invalid_resource!(@taxCategory)
            end
          end
  
          def update
            if @taxCategory
              authorize! :update, @taxCategory
              @taxCategory.update(taxCategory_params)
              respond_with(@taxCategory, status: 200, default_template: :show)
            else
              invalid_resource!(@taxCategory)
            end
          end
  
          def destroy
            if @taxCategory
              authorize! :destroy, @taxCategory
              @taxCategory.destroy
              respond_with(@taxCategory, status: 204)
            else
              invalid_resource!(@taxCategory)
            end
          end
  
          private
  
          def find_taxCategory
            @taxCategory = Spree::TaxCategory.accessible_by(current_ability, :show).find(params[:id])
          rescue ActiveRecord::RecordNotFound
            @taxCategory = Spree::TaxCategory.accessible_by(current_ability, :show).find_by!(name: params[:id])
          end
  
          def taxCategory_params
            params.require(:taxCategory).permit(:id, :name, :preferences)
          end
        end
      end
    end
  end
  