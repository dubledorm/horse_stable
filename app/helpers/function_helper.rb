module FunctionHelper
  def function_editor_options(resource, read_only = false)
    function = Functions::Factory.build!(resource.send(:function_name).to_s,
                              JSON.parse(resource.operation_json || '{}'))
    attr_array = function.short_attribute_names.map{|name| [name, function.send(name)]}
    attr_hash = Hash[*attr_array.flatten]

    { name: :function_name,
      name_title: resource.class.human_attribute_name(:function_name),
      name_hint: I18n.t("#{resource.class.name.underscore}.show.#{:function_name}_hint"),
      resource_class: resource.class.name.underscore,
      submit_button_text: I18n.t('send'),
      cancel_button_text: I18n.t('cancel'),
      url_for_read_parameters: front_functions_get_parameters_path(name: 'read_attribute').gsub(/\/[^\/]+$/, '/'),
      url_for_write_parameters: function_update_user_cabinet_operation_path(id: resource.id),
      start_value: resource.send(:function_name).to_s,
      values: Functions::Factory.options_for_select.to_json,
      start_value_attributes: attr_hash.to_json,
      read_only: read_only }
  end

  def rc_function_editor(resource, read_only = false)
    react_component 'functions/FunctionEditor', function_editor_options(resource, read_only)
  end
end