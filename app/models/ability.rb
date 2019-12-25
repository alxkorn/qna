# frozen_string_literal: true

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

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :me, :all
    can :exceptme, :all
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user_id: user.id

    can :destroy, [Question, Answer], user_id: user.id

    can :upvote, [Question, Answer] do |question|
      !user.owns?(question) && !question.voted_by?(user)
    end

    can :downvote, [Question, Answer] do |question|
      !user.owns?(question) && !question.voted_by?(user)
    end

    can :cancel_vote, [Question, Answer] do |question|
      question.voted_by?(user)
    end

    can :set_best, Answer do |answer|
      user.owns?(answer.question)
    end

    can :destroy, ActiveStorage::Attachment do |file|
      user.owns?(file.record)
    end

    can :destroy, Link do |link|
      user.owns?(link.linkable)
    end

    can :subscribe, Question do |question|
      !question.subscribed?(user)
    end
  end
end
