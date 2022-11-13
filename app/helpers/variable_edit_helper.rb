module VariableEditHelper
  def variable_editor_options(set_of_variables)
    { url: add_set_of_variable_user_cabinet_experiment_path(id: @resource.id),
      set_id: set_of_variables&.set_id,
      human_set_name: set_of_variables&.human_set_name || '',
      variables: set_of_variables&.variables || {},
      submit_button_text: I18n.t('send'),
      cancel_button_text: I18n.t('cancel'),
      edit_button_text: I18n.t('edit'),
      edit_mode: true }
  end
end
