require 'tty-prompt'
require 'json'
require_relative 'classes'

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

# puts "JASkdljasdkljasdK".capatalize()

def main_menu(filename, userid)
    require 'tty-prompt'
    prompt = TTY::Prompt.new

    parsed = JSON.load_file(filename, symbolize_names: true)

    # menu_selection = prompt.select("What would you like to do?", cycle: true) do |menu|
    #     menu.choice "View My Task"
    #     menu.choice "Create Task"
    #     menu.choice "Edit Task"
    # end
    user_details = 0
    parsed.each do |user|
        if (user[:id] == userid)
            user_details = user
            break
        end
    end

    p user_details

    menu_selection = 1
    while menu_selection != 0
        choices = {"View My Task" => 1, "Create Task" => 2, "Edit Task" => 3, "Delete Task" => 4, "Quit" => 0}
        menu_selection = prompt.select("What would you like to do?", choices, cycle: true)
        case menu_selection
        when 1
            user_details[:tasks].each_with_index do |task, index|
                puts "#{index + 1}. #{task}"
            end
            prompt.keypress("Press any key to continue")
        when 2
            task = prompt.ask('Input Task:', required: true)
            user_details[:tasks] << task
            puts "Task Added!"
        when 3
            choices = {}
            user_details[:tasks].each_with_index do |task, index|
                # puts "#{index + 1}. #{task}"
                choices["#{index+1}. #{task}"] = index
            end
            task_selection = prompt.select("Which task would you like to edit?", choices, cyle: true)
            task = prompt.ask("What is the new task?")
            user_details[:tasks][task_selection] = task
            puts "Task Updated!"
        when 4
            puts 4
        when 0
            menu_selection = 0
            puts "byebye"
        end
    end
end

prompt = TTY::Prompt.new
filename = 'accounts.json'

menu_selection = prompt.select("What would you like to do?", %w(Login Create\ Account), cycle: true).downcase

case menu_selection
when 'login'
    puts "You have selected Login"

    username = prompt.ask('Username:', required: true).downcase
    
    password = prompt.mask("Password:", required: true, echo: true)
    parsed = JSON.load_file(filename, symbolize_names: true)

    parsed.each do |user|
        if (user[:username] == username) && (user[:password] == password)
            puts "You've logged in!"
            user = user[:id]
            main_menu(filename, user)
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

# Challenges
# Menu looping, which menu displays first
# Overthinking of issues
# Feature creep
# How my user should be hanldled in the class