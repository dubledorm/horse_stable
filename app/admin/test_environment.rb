ActiveAdmin.register TestEnvironment do
  menu label: I18n.t('activerecord.models.test_environment.other')
  menu parent: :controls

  permit_params :name, :description, :user_id, :project_id
end
