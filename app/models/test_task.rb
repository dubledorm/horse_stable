class TestTask < ApplicationRecord
  # Класс для сохранения задания отданного на исполнение в mbu_selenium

  validates :test_setting_json, presence: :true

  scope :for_processing, -> {where(state: :new)}
end
