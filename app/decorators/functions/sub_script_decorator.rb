# frozen_string_literal: true

module Functions
  # Декоратор для Base
  class SubScriptDecorator < Draper::Decorator
    include Rails.application.routes.url_helpers
    delegate_all

    def to_html
      experiment = Experiment.find(object.script_id)
      h.content_tag(:div, class: 'row') do
        h.content_tag(:i, I18n.t('subscript') + ':')
      end +
        h.content_tag(:div, class: 'row') do
          h.link_to(experiment.human_name, user_cabinet_experiment_path(id: object.script_id), target: '_blank')
        end
    end
  end
end
