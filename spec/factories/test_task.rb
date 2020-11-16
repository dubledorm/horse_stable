FactoryGirl.define do
  factory :test_task, class: TestTask do
    test_setting_json { { '1' => { check: {},
                                 do: { '1' => { human_name: 'Переход на стартовую страницу',
                                                do: 'connect', value: 'http://yandex.ru' }
                                 },
                                 next: {} }
                        }.to_json }
    state :new
    experiment
  end
end