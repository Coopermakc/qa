class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)

    if user.persisted?
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def admin_abilities
    can :manage, :all
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities
    can :crate, [Question, Answer, Coment]
    can :update, [Question, Answer], user: user
  end
end