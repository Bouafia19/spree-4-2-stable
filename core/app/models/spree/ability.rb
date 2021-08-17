# Implementation class for Cancan gem.  Instead of overriding this class, consider adding new permissions
# using the special +register_ability+ method which allows extensions to add their own abilities.
#
# See http://github.com/ryanb/cancan for more details on cancan.
require 'cancan'
module Spree
  class Ability
    include CanCan::Ability

    class_attribute :abilities
    self.abilities = Set.new

    # Allows us to go beyond the standard cancan initialize method which makes it difficult for engines to
    # modify the default +Ability+ of an application.  The +ability+ argument must be a class that includes
    # the +CanCan::Ability+ module.  The registered ability should behave properly as a stand-alone class
    # and therefore should be easy to test in isolation.
    def self.register_ability(ability)
      abilities.add(ability)
    end

    def self.remove_ability(ability)
      abilities.delete(ability)
    end

    def initialize(user)
      alias_cancan_delete_action

      user ||= Spree.user_class.new

      if user.respond_to?(:has_spree_role?) && user.has_spree_role?('admin')
        apply_admin_permissions(user)
      else
        if user.respond_to?(:has_spree_role?) && user.has_spree_role?('store manager')
          apply_store_manager_permissions(user)
        end

        apply_user_permissions(user)
      end

      # Include any abilities registered by extensions, etc.
      # this is legacy behaviour and should be removed in Spree 5.0
      Ability.abilities.merge(abilities_to_register).each do |clazz|
        merge clazz.new(user)
      end

      protect_admin_role
    end

    protected

    # you can override this method to register your abilities
    # this method has to return array of classes
    def abilities_to_register
      []
    end

    def alias_cancan_delete_action
      alias_action :delete, to: :destroy
      alias_action :create, :update, :destroy, to: :modify
    end

    def apply_admin_permissions(user)
      can :manage, :all
    end

    def apply_store_manager_permissions(user)
      

      #can :manage, ::Spree::Base
      can :manage, ::Spree::Payment 
      can :manage, ::Spree::Order
      #can :manage, ::Spree::User, id: user.id
      can :manage, ::Spree::Preference
      #can :manage, ::Spree::Role
      can :manage, ::Spree::CreditCard
      # product
      can :manage, ::Spree::Product
      can :manage, ::Spree::OptionValueVariant
      can :manage, ::Spree::PropertyPrototype
      can :manage, ::Spree::ProductProperty
      can :manage, ::Spree::OptionType
      can :manage, ::Spree::Taxon
      can :manage, ::Spree::Taxonomy

      can :manage, ::Spree::Store
      
      can :manage, ::Spree::Promotion
      can :manage, ::Spree::PromotionRule
      #can :manage, ::Spree::StoreProduct
      can :manage, ::Spree::PaymentMethod
      can :manage, ::Spree::BillingIntegration
      can :manage, ::Spree::Gateway
      can :manage, ::Spree::Reimbursement
      can :manage, ::Spree::Refund
      
      can :manage, ::Spree::ShippingCategory
      can :manage, ::Spree::StoreCredit
      
      can :manage, ::Spree::ZoneMember
      can :manage, ::Spree::Zone
      can :manage, ::Spree::RefundReason
      can :manage, ::Spree::ReturnAuthorization
      
      can :manage, ::Spree::Asset
      can :manage, ::Spree::TaxonImage
      can :manage, ::Spree::Image
      can :manage, ::Spree::LegacyUser
      can :manage, ::Spree::StoreCreditCategory
      can :manage, ::Spree::StockTransfer
      can :manage, ::Spree::ReturnItem
      can :manage, ::Spree::Calculator
      
      
      can :manage, ::Spree::Country
      can :manage, ::Spree::ShippingMethodCategory
      can :manage, ::Spree::StockLocation do |stock|
        stock.id == user.store_manager_id
      end
      #can :manage, ::Spree::Address
      can :manage, ::Spree::Shipment
      can :manage, ::Spree::ShippingRate
      can :manage, ::Spree::CustomerReturn
      can :manage, ::Spree::PromotionAction
      can :manage, ::Spree::InventoryUnit
      can :manage, ::Spree::PromotionRuleUser
      # Stock
      # can :manage, ::Spree::StockItem, ["stock_location_id == ?", user.store_manager_id] do |item|
      #   item.stock_location_id == user.store_manager_id
      # end
      # can :manage, ::Spree::StockMovement do |movement|
      #   movement.stock_item_id == user.store_manager_id
      # end

      can :manage, ::Spree::Price
      can :manage, ::Spree::State
      can :manage, ::Spree::TaxRate
      can :manage, ::Spree::ProductPromotionRule
      can :manage, ::Spree::Classification
      can :manage, ::Spree::PromotionCategory
      can :manage, ::Spree::PaymentCaptureEvent
      can :manage, ::Spree::PromotionRuleTaxon
      can :manage, ::Spree::OrderPromotion
      can :manage, ::Spree::StoreCreditEvent
      can :manage, ::Spree::StateChange
      can :manage, ::Spree::PrototypeTaxon
      can :manage, ::Spree::Prototype
      can :manage, ::Spree::TaxCategory
      can :manage, ::Spree::ShippingMethodZone
      can :manage, ::Spree::OptionTypePrototype
      can :manage, ::Spree::LineItem
      can :manage, ::Spree::ShippingMethod
      can :manage, ::Spree::Adjustment
      can :manage, ::Spree::StoreCreditType
      can :manage, ::Spree::OptionValue
      can :manage, ::Spree::ReturnAuthorizationReason
      can :manage, ::Spree::ProductOptionType
      can :manage, ::Spree::Variant
      can :manage, ::Spree::LogEntry
      can :manage, ::Spree::PromotionActionLineItem
      can :manage, ::Spree::Property
    end

    def apply_user_permissions(user)
      can :read, ::Spree::Country
      can :read, ::Spree::OptionType
      can :read, ::Spree::OptionValue
      can :create, ::Spree::Order
      can :show, ::Spree::Order do |order, token|
        order.user == user || order.token && token == order.token
      end
      can :update, ::Spree::Order do |order, token|
        !order.completed? && (order.user == user || order.token && token == order.token)
      end
      can :manage, ::Spree::Address, user_id: user.id
      can :read, ::Spree::CreditCard, user_id: user.id
      can :read, ::Spree::Product
      can :read, ::Spree::ProductProperty
      can :read, ::Spree::Property
      can :create, ::Spree.user_class
      can [:show, :update, :destroy], ::Spree.user_class, id: user.id
      can :read, ::Spree::State
      can :read, ::Spree::Store
      can :read, ::Spree::Taxon
      can :read, ::Spree::Taxonomy
      can :read, ::Spree::Variant
      can :read, ::Spree::Zone
    end

    def protect_admin_role
      cannot [:update, :destroy], ::Spree::Role, name: ['admin']
    end
  end
end
