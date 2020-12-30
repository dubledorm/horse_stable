# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
require_relative 'app/middleware/fix_remote_addr_middleware'

# Это middleware включается только из за проблем с ActionCale
use FixRemoteAddrMiddleware
run Rails.application
