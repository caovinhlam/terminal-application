require 'tty-prompt'
require 'json'
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
# Create an account
parsed = JSON.load_file('accounts.json', symbolize_names: true)
used_ids = parsed[0][:created_id]
random_id = rand(100000)
while used_ids.include?(random_id)
    random_id(100000)
end

parsed[0][:created_id] << random_id

new_account = { id: random_id, user: "chicken", password: "secret", tasks: [] }
parsed << new_account
p parsed
File.write('accounts.json', JSON.pretty_generate(parsed))


# prompt.select("What would you like to do?", %w(Login Create_Account), cycle: true)

# user = prompt.ask("Username:", required: true)
# p user
# pass = prompt.mask("Password:", required: true, echo: true)
# p pass
task = ['hello','this','is']

vinh = User.new('chicken','egg',task)

p vinh