# Класс, который заполняет в запросе поле HTTP_X_FORWARDED_FOR, если оно не заполнено
# Сделано по причине, что при включении ActionCable, при попытке установить соединение с бэком, падает класс Request
# из за попытки обратиться к HTTP_X_FORWARDED_FOR когда тот nil.
class FixRemoteAddrMiddleware
  HTTP_X_FORWARDED_FOR = 'HTTP_X_FORWARDED_FOR'
  REMOTE_ADDR = 'REMOTE_ADDR'

  def initialize(app)
    @app = app
  end

  def call(env)
    env[HTTP_X_FORWARDED_FOR] = env[REMOTE_ADDR].split(',').first if env[HTTP_X_FORWARDED_FOR].nil?
    @app.call(env)
  end
end
