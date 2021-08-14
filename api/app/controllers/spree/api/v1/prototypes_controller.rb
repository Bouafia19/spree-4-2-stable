module Spree
    module Api
      module V1
        class PrototypesController < Spree::Api::BaseController
          before_action :find_prototype, only: [:show, :update, :destroy]
  
          def index
            @prototypes = Spree::Prototype.accessible_by(current_ability)
  
            @prototypes = if params[:ids]
                            @prototypes.where(id: params[:ids].split(',').flatten)
                          else
                            @prototypes.ransack(params[:q]).result
                          end
  
            @prototypes = @prototypes.page(params[:page]).per(params[:per_page])
            render :json => @prototypes
            #respond_with(@prototypes)
          end
  
          def show
            render :json => @prototype
            #respond_with(@prototype)
          end
  
          def new; end
  
          def create
            authorize! :create, Prototype
            @prototype = Spree::Prototype.new(prototype_params)
            if @prototype.save
              respond_with(@prototype, status: 201, default_template: :show)
            else
              invalid_resource!(@prototype)
            end
          end
  
          def update
            if @prototype
              authorize! :update, @prototype
              @prototype.update(prototype_params)
              respond_with(@prototype, status: 200, default_template: :show)
            else
              invalid_resource!(@prototype)
            end
          end
  
          def destroy
            if @prototype
              authorize! :destroy, @prototype
              @prototype.destroy
              respond_with(@prototype, status: 204)
            else
              invalid_resource!(@prototype)
            end
          end
  
          private
  
          def find_prototype
            @prototype = Spree::Prototype.accessible_by(current_ability, :show).find(params[:id])
          rescue ActiveRecord::RecordNotFound
            @prototype = Spree::Prototype.accessible_by(current_ability, :show).find_by!(name: params[:id])
          end
  
          def prototype_params
            params.require(:prototype).permit(permitted_prototype_attributes)
          end
        end
      end
    end
  end
  