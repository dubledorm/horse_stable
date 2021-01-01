class ExperimentChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug('!!!!!!!!!!! SUBSCRIBED')
    # stream_from "some_channel"
    stream_for 'ExperimentChannel'
    #  ActionCable.server.broadcast 'ExperimentChannel', "Ura!!!!!!"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    Rails.logger.debug('!!!!!!!!!!! unsubscribed')
  end
end
