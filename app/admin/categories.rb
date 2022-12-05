ActiveAdmin.register Tag, as: 'Category' do
  menu label: I18n.t('activerecord.models.category.other')
  menu parent: :controls

  permit_params :name, :title, :tag_type, :user_id

  form title: I18n.t('activerecord.models.category.one') do |f|
    f.semantic_errors *f.object.errors.keys
    inputs I18n.t('admin_menu.attributes') do
      f.input :tag_type, input_html: { value: 'category' }, as: :hidden
      f.input :user_id, input_html: { value: current_user.id }, as: :hidden
      f.input :name
      f.input :title
    end
    f.actions
  end

  controller do

    def scoped_collection
      resource_class.category
    end
  end
end
