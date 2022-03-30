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

filename = 'accounts.json'

login_menu(filename)

# Challenges
# Menu looping, which menu displays first
# How my user should be hanldled in the class
# Overthinking of issues
# Feature creep
