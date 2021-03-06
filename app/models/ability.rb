class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)

    @user = user

    if user
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
    can :create, [Question, Answer, Comment, Subscription]
    can :update, [Question, Answer], user: user
    can :destroy, [Question, Answer, Subscription], user: user
    can :best, Answer, question: { user: user }
    can :me, User, id: user.id
    can :manage, Attachment do |attachment|
      attachment.attachable.user_id == user.id
    end
  end
end
