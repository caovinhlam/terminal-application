# require 'tty-prompt'
# require_relative '../classes'

def login_menu(account_file, tasks_file)
    prompt = TTY::Prompt.new

    menu_selection = prompt.select("What would you like to do?", %w(Login Create\ Account), cycle: true).downcase

    case menu_selection
    when 'login'
        puts "You have selected Login"

        # login = false
        # while !login 
            username = prompt.ask('Username:', required: true).downcase
            password = prompt.mask('Password:', required: true, echo: true)
            user_account = login_account(account_file, username, password)
            if user_account
                login = true
                main_menu(account_file, tasks_file, user_account)
            end
        # end

    when 'create account'
        puts "You have selected Create account"

        first_name = prompt.ask('First name:', required: true).capitalize
        last_name = prompt.ask('Last name', required: true).capitalize
        matching_username = false

        while !matching_username
            username = prompt.ask('Username:', required: true).downcase
            if validate_username(account_file, username)
                puts "Username already exists please try again"
            else
                break
            end
        end

        matching_password = false
        while !matching_password
            password = prompt.mask('Password:', required: true, echo: true)
            retype_password = prompt.mask("Re-type password:", required: true, echo: true)
            if password != retype_password
                puts "Password did not match"
            else
                create_account(account_file, tasks_file, first_name, last_name, username, password)
                puts "Account created"
                break
            end
        end
        
    end
end

# Menu when user login
def main_menu(account_file, tasks_file, user_account)
    prompt = TTY::Prompt.new

    user_account.my_task.tasks = load_tasks(tasks_file, user_account.id)

    # menu_selection = prompt.select("What would you like to do?", cycle: true) do |menu|
    #     menu.choice "View My Task"
    #     menu.choice "Create Task"
    #     menu.choice "Edit Task"
    # end
    menu_selection = 1
    # While user hasn't quit the menu
    while menu_selection != 0
        choices = {"View Profile" => 1, "View My Task" => 2, "Create Task" => 3, "Edit Task" => 4, "Delete Task" => 5, "Quit" => 0}
        menu_selection = prompt.select("What would you like to do?", choices, cycle: true)
        case menu_selection
        when 1
            profile_menu(account_file, user_account)
        # View my task
        when 2
            # List it as a numbered list
            user_account.my_task.display_list
            prompt.keypress("Press any key to continue")
        # Create Task
        when 3
            # Appending to the task list
            task = prompt.ask('Input Task:', required: true)
            # user_details[:tasks] << task
            user_account.my_task.add_task(task)
            puts "Task Added!"
        # Edit Task
        when 4
            # Making the task list selectable for the user to pick
            choices = create_ordered_list(user_account.get_tasks)

            # Get index position from the hash to edit the task in the array in user details
            task_index = prompt.select("Which task would you like to edit?", choices, cyle: true)
            new_task = prompt.ask("What is the new task?")
            # Replace old task with new editted task
            user_account.my_task.update_task(task_index, new_task)
            puts "Task Updated!"
        # Delete Task
        when 5
            # Making the task list selectable for the user to pick
            choices = create_ordered_list(user_account.get_tasks)

            # Get index position from the hash to delete task in the array in user details
            task_index = prompt.select("Which task would you like to delete?", choices, cyle: true)
            confirm = prompt.yes?("Are you sure?")
            if confirm
                user_account.my_task.delete_task(task_index)
                puts "Task Deleted!"
            end
        when 0
            menu_selection = 0
            tasks_parsed = JSON.load_file(tasks_file, symbolize_names: true)
            tasks_parsed.each do |user|
                if (user[:id] == user_account.id)
                    user[:tasks] = user_account.get_tasks
                    File.write(tasks_file, JSON.pretty_generate(tasks_parsed))
                    puts "DataBase UPDATED"
                end
            end
            
            
            puts "byebye"
        end
    end
end

def profile_menu(account_file, user_account)

    prompt = TTY::Prompt.new

    menu_selection = 1
    # While user hasn't quit the menu
    while menu_selection != 0

        puts user_account.display_name()
        choices = {"Edit Profile" => 1, "Change Password" => 2, "Back" => 0}
        
        menu_selection = prompt.select("What would you like to do?", choices, cycle: true)
        case menu_selection
        # View my profile
        when 1
            decision = prompt.select("Which would you like to edit?", cyle: true) do |menu|
                menu.choice "First Name: #{user_account.first_name}", 1
                menu.choice "Last Name: #{user_account.last_name}", 2
            end
            new_name = prompt.ask("What would you like it to change to?")
            confirm = prompt.yes?("Are you sure?")
            if confirm
                case decision
                when 1
                    user_account.first_name = new_name
                when 2
                    user_account.last_name = new_name
                end
            end
        when 2
            password = prompt.mask('Confirm your password:', required: true, echo: true)
            if validate_password(account_file, password, user_details.id)
                
                new_password = prompt.ask("New Password:")
                retype_password = prompt.mask("Re-type password:", required: true, echo: true)
                if new_password != retype_password
                    puts "Password did not match"
                else
                    parsed = JSON.load_file(account_file, symbolize_names: true)
                    parsed.each do |user|
                        if (user[:id] == userid)
                            return true
                        end
                    end
                end
            end
            
        end
    end
end

def create_ordered_list(task_list)
    choices = {}
    task_list.each_with_index do |task, index|
        # key is the task and the value is index of the task in the array
        choices["#{index+1}. #{task}"] = index
    end
    return choices
end