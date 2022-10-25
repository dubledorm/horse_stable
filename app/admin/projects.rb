ActiveAdmin.register Project do
  menu label: I18n.t('activerecord.models.project.other')
  menu parent: :controls

  permit_params :name, :description, project_to_users_attributes: [:id, :user_id, :project_id, :access_right, :_destroy]

  form title: I18n.t('activerecord.models.project.one') do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :name
      f.input :description
    end
    f.inputs do
      f.has_many :project_to_users, heading: 'Users',
                 allow_destroy: true,
                 new_record: 'Добавить ещё пользователя' do |project_to_user|
        project_to_user.input :user
        project_to_user.input :access_right, collection: ProjectToUser::ACCESS_RIGHT_VALUES.map { |access_right|
          [ProjectToUser.human_attribute_value(:access_right, access_right), access_right]
        }
        project_to_user.input :project, input_html: { value: f.object.id }, as: :hidden
      end
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :description
    end

    panel Project.human_attribute_name(:users) do
      render 'admin/project_to_users_table', project_to_users: project.project_to_users
    end

    active_admin_comments
  end
end
