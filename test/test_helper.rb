ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

class ActiveSupport::TestCase
  require 'rails/test_help'
end
