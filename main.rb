require 'tty-prompt'
require 'tty-font'
require 'rainbow'
require 'json'
require_relative 'classes'
require_relative 'exception_classes.rb'
require_relative 'controllers/account_management'
require_relative 'controllers/menu_management'
require_relative 'controllers/database_management'
require_relative 'view/displayUI'

account_file = ARGV[0]
tasks_file = ARGV[1]
assigned_file = ARGV[2]
login_menu(account_file, tasks_file, assigned_file)