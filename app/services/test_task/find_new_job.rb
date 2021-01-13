class TestTask
  class FindNewJob

    def self.find
      TestTask.for_processing.where('plan_start_time < ?', Time.now).order(plan_start_time: :asc).first
    end
  end
end