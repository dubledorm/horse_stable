ActiveAdmin.register User do
  permit_params :email, :confirmed_at
  menu parent: :resources

  show do
    attributes_table do
      row :email
      row :reset_password_token
      row :reset_password_sent_at
      row :remember_created_at
      row :created_at
      row :updated_at
      row :confirmation_token
      row :confirmed_at
      row :confirmation_sent_at
    end

    panel User.human_attribute_name(:services) do
      render 'admin/services_table', services: user.services
    end
    active_admin_comments
  end
end
