# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin_role?
        can :manage, :all
    end

    if user.manager_role?
        can :manage, Consumer
        can :manage, CurrentEnConsumption
        can :manage, CurrentGasConsumption
        can :manage, PreviousEnConsumption
        can :manage, PreviousGasConsumption
        can :manage, EnBid
        can :manage, GasBid
        can :manage, EnPayment
        can :manage, GasPayment
        can :show, :invoice
        can [:edit, :update, :index], Message
        can [:edit, :update, :index], EnAdjustment
        can [:edit, :update, :index], GasAdjustment
        can [:new, :create, :index], User
    end

    if user.client_role?
        can :read, Consumer
        can :read, CurrentEnConsumption
        can :read, CurrentGasConsumption
        can :read, PreviousEnConsumption
        can :read, PreviousGasConsumption
        can :read, EnBid
        can :read, GasBid
        can :read, EnPayment
        can :read, GasPayment
        can :show, :invoice
        can [:new, :create, :index], Message
        can [:new, :create, :index], EnAdjustment
        can [:new, :create, :index], GasAdjustment
    end
  end
end
