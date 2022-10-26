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

    can :manage, Article, user_id: user.id
    can :manage, Grade, user_id: user.id
    can :manage, GradeAverage, user_id: user.id
    can :manage, Gallery, user_id: user.id
    can :manage, Picture, user_id: user.id
    can :manage, Picture, user_id: user.id
    can :manage, Service, user_id: user.id
    can %i[index show], UserGroup, user_to_user_groups: { user_id: user.id }
    can :manage, ExperimentToUserGroup, user_group: { user_to_user_groups: { user_id: user.id,
                                                                             access_right: 'manager' } }

    can %i[index show], Project, project_to_users: { user_id: user.id }

    can %i[index show], Experiment, project_to_users: { user_id: user.id, access_right: 'tester' }
    can %i[index show update destroy update_categories update_groups], Experiment,
        project_to_users: { user_id: user.id,
                            access_right: 'developer' }
    can :create, Experiment

    can %i[index show], ExperimentCase, project_to_users: { user_id: user.id, access_right: 'tester' }
    can %i[index show update destroy], ExperimentCase, project_to_users: { user_id: user.id,
                                                                           access_right: 'developer' }
    can :create, ExperimentCase

    can %i[index show], Operation, project_to_users: { user_id: user.id, access_right: 'tester' }
    can %i[index show update destroy], Operation, project_to_users: { user_id: user.id,
                                                                      access_right: 'developer' }
    can :create, Operation
  end
end
