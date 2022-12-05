# Методы для отображения TestEnvironments во фронтовых компонентах
module TestEnvironmentsHelper
  # Преобразовать к массиву пар name: id
  def to_array_name_id(test_environments)
    return [] unless test_environments

    test_environments.map { |test_environment| [test_environment.name, test_environment.id] }
  end
end
