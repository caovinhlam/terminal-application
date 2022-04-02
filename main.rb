require 'tty-prompt'
require 'json'
require_relative 'classes'
require_relative 'controllers/account_management'
require_relative 'controllers/menu_management'

# puts "
#  /$$$$$$$$ /$$$$$$  /$$$$$$$   /$$$$$$
# |__  $$__//$$__  $$| $$__  $$ /$$__  $$
#    | $$  | $$  \ $$| $$  \ $$| $$  \ $$
#    | $$  | $$  | $$| $$  | $$| $$  | $$
#    | $$  | $$  | $$| $$  | $$| $$  | $$
#    | $$  | $$  | $$| $$  | $$| $$  | $$
#    | $$  |  $$$$$$/| $$$$$$$/|  $$$$$$/
#    |__/   \______/ |_______/  \______/

# "

account_file = 'accounts.json'
tasks_file = 'tasks_db.json'
login_menu(account_file, tasks_file)
# account_parsed = JSON.load_file(account_file, symbolize_names: true)
# p account_parsed[0][:created_id]
# id = 29474.to_s.to_sym
# p account_parsed[0][:created_id].has_key?(id)

# Challenges
# Menu looping, which menu displays first
# How my user should be hanldled in the class
# Overthinking of issues
# Feature creep
