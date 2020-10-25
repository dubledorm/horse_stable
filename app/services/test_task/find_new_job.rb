class TestTask
  class FindNewJob

    def self.find
      TestTask.for_processing.order(created_at: :desc).first
    end
  end
end