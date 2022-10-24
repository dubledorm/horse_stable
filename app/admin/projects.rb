ActiveAdmin.register Project do
  menu label: I18n.t('activerecord.models.project.other')
  menu parent: :controls

  permit_params :name, :description

  form title: I18n.t('activerecord.models.project.one') do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :name
      f.input :description
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :description
    end
    active_admin_comments
  end
end
