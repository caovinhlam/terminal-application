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

def login_account(filename, username, password)
    require_relative 'classes'

    parsed = JSON.load_file(filename, symbolize_names: true)
    parsed.each do |user|
        if (user[:username] == username) && (user[:password] == password)
            puts "You've logged in!"
            user_account = User.new(user[:id], user[:firstname], user[:lastname], user[:tasks])
            return user_account
        end
    end
    return false
end

def main_menu(filename, user_account)
    require 'tty-prompt'
    require_relative 'classes'
    prompt = TTY::Prompt.new

    parsed = JSON.load_file(filename, symbolize_names: true)

    # menu_selection = prompt.select("What would you like to do?", cycle: true) do |menu|
    #     menu.choice "View My Task"
    #     menu.choice "Create Task"
    #     menu.choice "Edit Task"
    # end

    # Getting user hash from the JSON file
    # user_details = 0
    # parsed.each do |user|
    #     if (user[:id] == userid)
    #         user_details = user
    #         break
    #     end
    # end

    user_details = user_account
    userid = user_account.id
    p user_details

    menu_selection = 1
    # While user hasn't quit the menu
    while menu_selection != 0
        choices = {"View My Task" => 1, "Create Task" => 2, "Edit Task" => 3, "Delete Task" => 4, "Quit" => 0}
        menu_selection = prompt.select("What would you like to do?", choices, cycle: true)
        case menu_selection
        # View my task
        when 1
            # List it as a numbered list
            # user_details[:tasks].each_with_index do |task, index|
            #     puts "#{index + 1}. #{task}"
            # end
            user_account.tasks.display_list
            prompt.keypress("Press any key to continue")
        when 2
            # Appending to the task list
            task = prompt.ask('Input Task:', required: true)
            # user_details[:tasks] << task
            user_account.tasks.add_task(task)
            puts "Task Added!"
        when 3
            # Making the task list selectable for the user to pick
            choices = {}
            # user_details[:tasks].each_with_index do |task, index|
            task_list = user_account.get_tasks
            task_list.each_with_index do |task, index|
                # key is the task and the value is index of the task in the array
                choices["#{index+1}. #{task}"] = index
            end
            # Get index position from the hash to edit the task in the array in user details
            task_index = prompt.select("Which task would you like to edit?", choices, cyle: true)
            new_task = prompt.ask("What is the new task?")
            # Replace old task with new editted task
            # user_details[:tasks][task_selection] = task
            user_account.tasks.update_task(task_index, new_task)
            puts "Task Updated!"
        when 4
            # Making the task list selectable for the user to pick
            choices = {}
            task_list = user_account.get_tasks
            task_list.each_with_index do |task, index|
            # user_details[:tasks].each_with_index do |task, index|
                choices["#{index+1}. #{task}"] = index
            end
            # Get index position from the hash to delete task in the array in user details
            task_index = prompt.select("Which task would you like to delete?", choices, cyle: true)
            confirm = prompt.yes?("Are you sure?")
            if confirm
                # user_details[:tasks].delete_at(task_selection)
                user_account.tasks.delete_task(task_index)
                puts "Task Deleted!"
            end
        when 0
            menu_selection = 0
            parsed.each do |user|
                if (user[:id] == user_account.id)
                    user[:tasks] = user_account.get_tasks
                end
            end
            File.write(filename, JSON.pretty_generate(parsed))
            puts "DataBase UPDATED"
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

    login = false
    while !login 
        username = prompt.ask('Username:', required: true).downcase
        password = prompt.mask("Password:", required: true, echo: true)
        user_account = login_account(filename, username, password)
        if user_account
            login = true
            main_menu(filename, user_account)
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