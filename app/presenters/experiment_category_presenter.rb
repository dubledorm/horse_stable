class ExperimentCategoryPresenter
  include ActiveModel::Model

  # Сохраняет список категорий к которым относится experiment
  # Преобразует этот список в ответы контроллера

  attr_accessor :categories

  class ExpPresenterError < StandardError; end

  # Получает категории из модели Experiment
  def from_experiment(experiment)
    @categories = experiment.category_tags.inject([]){|result, item| result << { name: item.name,
                                                                                 title: item.title,
                                                                                 included: true } }
    self
  end

  # Получает категории из json строки вида  { name: item.name, title: item.title, included: true }
  # При этом, оставляет только те записи где included == true
  def from_json_string(json_string)
    begin
      @categories = JSON.parse(json_string, symbolize_names: true).find_all{ |item| item[:included] }
      self

    rescue Exception => e
      raise ExpPresenterError, 'ExperimentCategoryPresenter.from_json_string parse error: ' + e.message
    end
  end


  def to_json
    get_categories_list.to_json
  end

  private

  def get_categories_list
    result = []
    Tag.category.sort_by(&:title).each do |category|
      result << { name: category.name,
                  title: category.title,
                  included: has_category?(category.name) }
    end
    result
  end

  def has_category?(name)
    categories.find_all{|category| category[:name] == name}.any?
  end
end