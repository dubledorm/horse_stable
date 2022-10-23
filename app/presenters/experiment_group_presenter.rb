class ExperimentGroupPresenter
  include ActiveModel::Model

  # Сохраняет список груп к которым относится experiment
  # Преобразует этот список в ответы контроллера

  attr_accessor :groups

  class ExpGroupPresenterError < StandardError; end

  # Получает группы из модели Experiment
  def from_experiment(experiment)
    @groups = experiment.user_groups.inject([]) do |result, user_group|
      result << { name: user_group.id.to_s,
                  title: user_group.name,
                  included: true }
    end
    self
  end

  # Получает группы из json строки вида  { name: item.name, title: item.title, included: true }
  # При этом, оставляет только те записи где included == true
  def from_json_string(json_string)
    @groups = JSON.parse(json_string, symbolize_names: true).find_all { |item| item[:included] }
    self

  rescue Exception => e
    raise ExpGroupPresenterError, 'ExperimentGroupPresenter.from_json_string parse error: ' + e.message
  end

  def to_json(*_args)
    group_list.to_json
  end

  private

  def group_list
    result = []
    UserGroup.all.sort_by(&:name).each do |user_group|
      result << { name: user_group.id.to_s,
                  title: user_group.name,
                  included: has_group?(user_group.id.to_s) }
    end
    result
  end

  def has_group?(name)
    groups.find_all { |user_group| user_group[:name] == name }.any?
  end
end
