# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)

 #   can :read, :all
 #   cannot :read, User

    if user.nil?
      return
    end

    can :manage, User, id: user.id

    can :manage, SomeFile, user_id: user.id
    can :manage, Tag, user_id: user.id
    can :manage, TestTask, user_id: user.id
    can :manage, Operation, { experiment_case: { user_id: user.id } }

    can :manage, Experiment, user_id: user.id
    can :read, Experiment, user_groups: { user_to_user_groups: { user_id: user.id, access_right: 'user' } }
    can :manage, Experiment, user_groups: { user_to_user_groups: { user_id: user.id, access_right: 'manager' } }

    can :manage, ExperimentCase, experiment: { user_id: user.id }
    can :read, ExperimentCase, experiment: { user_groups: { user_to_user_groups: { user_id: user.id,
                                                                                   access_right: 'user' } } }
    can :manage, ExperimentCase, experiment: { user_groups: { user_to_user_groups: { user_id: user.id,
                                                                                     access_right: 'manager' } } }

    can :manage, Article, user_id: user.id
    can :manage, Grade, user_id: user.id
    can :manage, GradeAverage, user_id: user.id
    can :manage, Gallery, user_id: user.id
    can :manage, Picture, user_id: user.id
    can :manage, Picture, user_id: user.id
    can :manage, Service, user_id: user.id
    can :read, UserGroup, members: { id: user.id }
    can :manage, ExperimentToUserGroup, user_group: { user_to_user_groups: { user_id: user.id,
                                                                             access_right: 'manager' } }



    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
