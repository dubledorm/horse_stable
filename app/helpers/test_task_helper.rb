# Вспомогательные методы для отображения TestTask
module TestTaskHelper
  def show_result_code(test_task)
    return unless test_task

    class_name = test_task.success? ? :success_test_task : :failed_test_task

    content_tag(:span, class: class_name) do
      test_task&.human_attribute_value(:result_kod)
    end
  end
end
