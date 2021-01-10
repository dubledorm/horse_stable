# encoding: utf-8
# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
require_relative 'app/middleware/fix_remote_addr_middleware'

use FixRemoteAddrMiddleware
run Rails.application
