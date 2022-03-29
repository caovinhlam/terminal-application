require "tty-prompt"

require_relative 'classes'

prompt = TTY::Prompt.new

puts "
 /$$$$$$$$ /$$$$$$  /$$$$$$$   /$$$$$$ 
|__  $$__//$$__  $$| $$__  $$ /$$__  $$
   | $$  | $$  \ $$| $$  \ $$| $$  \ $$
   | $$  | $$  | $$| $$  | $$| $$  | $$
   | $$  | $$  | $$| $$  | $$| $$  | $$
   | $$  | $$  | $$| $$  | $$| $$  | $$
   | $$  |  $$$$$$/| $$$$$$$/|  $$$$$$/
   |__/   \______/ |_______/  \______/ 
                                       
"

prompt.select("What would you like to do?", %w(Login Create_Account), cycle: true)

user = prompt.ask("Username:", required: true)
p user
pass = prompt.mask("Password:", required: true, echo: true)
p pass
task = ['hello','this','is']

vinh = User.new('chicken','egg',task)

p vinh