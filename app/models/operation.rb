class Operation < ApplicationRecord

  validates :operation_type, :number, presence: :true
  validates :number, uniqueness: { scope: :test_case }
  validates :operation_type, inclusion: { in: %w(check do next),
                                          message: "Поле operation_type может содержать значения: check, do,next. %{value} это не корректное значение" }
  belongs_to :test_case
end
