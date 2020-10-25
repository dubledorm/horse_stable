class TestTask < ApplicationRecord

  validates :test_setting_json, presence: :true

  scope :for_processing, -> {where(state: :new)}
end
