require 'tty-prompt'
require 'tty-font'
require 'json'
require_relative 'classes'
require_relative 'exception_classes.rb'
require_relative 'controllers/account_management'
require_relative 'controllers/menu_management'
require_relative 'controllers/database_management'
require_relative 'view/displayUI'

account_file = 'accounts.json'
tasks_file = 'tasks_db.json'
assigned_file = 'assigned_tasks.json'
login_menu(account_file, tasks_file, assigned_file)