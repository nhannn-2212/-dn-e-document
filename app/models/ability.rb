# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      can [:read, :create, :search], Document, status: Document.statuses[:approved]
      can :manage, Document, user_id: user.id
      can :manage, Comment, user_id: user.id
      can :show, User
      can :favorites, User, id: user.id
      can :show, :download
      can [:create, :destroy], Favorite, user_id: user.id
      if user.admin?
        can :manage, Document, status: !Document.statuses[:draft]
        can :read, Document, status: Document.statuses[:draft]
        can :manage, Category
        can :manage, User
        can :index, :history
        can :delete, Comment
      end
    end
  end
end
