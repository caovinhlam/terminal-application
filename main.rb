require 'tty-prompt'
require 'json'
require_relative 'classes'

prompt = TTY::Prompt.new

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
# Create an account
def create_account(filename, firstname, lastname, username, password)
    parsed = JSON.load_file(filename, symbolize_names: true)
    used_ids = parsed[0][:created_id]
    random_id = rand(100000)
    
    # while a duplicaste id exist, create a new one
    while used_ids.include?(random_id)
        random_id = random_id(100000)
    end

    # append new id to created ids
    parsed[0][:created_id] << random_id

    # append new account to accounts.json
    new_account = { id: random_id, firstname: firstname, lastname: lastname, username: username, password: password, tasks: [] }
    parsed << new_account
    File.write(filename, JSON.pretty_generate(parsed))
end

filename = 'accounts.json'

menu_selection = prompt.select("What would you like to do?", %w(Login Create\ Account), cycle: true).downcase

# puts "JASkdljasdkljasdK".capatalize()

case menu_selection
when 'login'
    puts "You have selected Login"

    username = prompt.ask('Username:', required: true).downcase
    
    password = prompt.mask("Password:", required: true, echo: true)
    parsed = JSON.load_file(filename, symbolize_names: true)

    parsed.each do |user|
        if (user[:username] == username) && (user[:password] == password)
            puts "You've logged in!"
        end
    end
when 'create account'
    puts "You have selected Create account"

    first_name = prompt.ask('First name:', required: true).capitalize
    last_name = prompt.ask('Last name', required: true).capitalize
    username = prompt.ask('Username:', required: true).downcase
    matching = false
    while !matching
        password = prompt.mask("Password:", required: true, echo: true)
        retype_password = prompt.mask("Re-type password:", required: true, echo: true)
        if password != retype_password
            puts "Password did not match"
        else
            create_account(filename, first_name, last_name, username, password)
            puts "Account created"
            break
        end
    end

end

# task = ['hello','this','is']

# vinh = User.new('chicken','egg',task)

# p vinh