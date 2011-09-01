ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "#{Rails.root}/db/seeds.rb"

class ActiveSupport::TestCase
end

require 'capybara/rails'
require 'launchy'

class ActionDispatch::IntegrationTest
 include Capybara::DSL
end