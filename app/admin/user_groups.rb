ActiveAdmin.register UserGroup do
  menu label: I18n.t('activerecord.models.user_group.other')
  menu parent: :controls

  permit_params :name, :description, :user_id, :project_id, user_to_user_groups_attributes: [:id, :user_id, :user_group_id, :access_right, :_destroy]

  form title: I18n.t('activerecord.models.user_group.one') do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :name
      f.input :project
      f.input :user
      f.input :description
    end
    f.inputs do
      f.has_many :user_to_user_groups, heading: 'Members',
                 allow_destroy: true,
                 new_record: 'Добавить ещё пользователя' do |user_to_user_group|
        user_to_user_group.input :user
        user_to_user_group.input :access_right, collection: UserToUserGroup::ACCESS_RIGHT_VALUES.map { |access_right|
          [UserToUserGroup.human_attribute_value(:access_right, access_right), access_right]
        }
        user_to_user_group.input :user_group_id, input_html: { value: f.object.id }, as: :hidden
      end
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :project
      row :user
      row :description
    end

    panel UserGroup.human_attribute_name(:user_to_user_groups) do
      render 'admin/user_to_user_groups_table', user_to_user_groups: user_group.user_to_user_groups
    end

    panel UserGroup.human_attribute_name(:experiment_to_user_groups) do
      table_for user_group.experiments do
        column :human_name
        column :human_description
        column :user
      end
    end
    active_admin_comments
  end
end
