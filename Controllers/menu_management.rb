# require 'tty-prompt'
# require_relative '../classes'

def login_menu(account_file, tasks_file, assigned_file)
    prompt = TTY::Prompt.new

    menu_selection = prompt.select("What would you like to do?", %w(Login Create\ Account), cycle: true).downcase

    case menu_selection
    when 'login'
        puts "You have selected Login"

        username = prompt.ask('Username:', required: true).downcase
        password = prompt.mask('Password:', required: true, echo: true)
        user_account = login_account(account_file, username, password)
        if user_account
            login = true
            main_menu(account_file, tasks_file, assigned_file, user_account)
        else
            puts "Incorrect Username or Password!"
            login_menu(account_file, tasks_file, assigned_file)
        end
            
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
                user_account = create_account(account_file, tasks_file, first_name, last_name, username, password)
                puts "Account created"
                main_menu(account_file, tasks_file, assigned_file, user_account)
                break
            end
        end

    end
end

# Menu when user login
def main_menu(account_file, tasks_file, assigned_file, user_account)
    prompt = TTY::Prompt.new

    user_account.my_task.tasks = load_tasks(tasks_file, user_account.id)
    p user_account
    menu_selection = 1
    # While user hasn't quit the menu
    while menu_selection != 0
        choices = {"View Profile" => 1, "View My Task" => 2, "Create Task" => 3, "Edit Task" => 4, "Delete Task" => 5, "Assign Task" => 6, "Quit" => 0}
        menu_selection = prompt.select("What would you like to do?", choices, cycle: true)
        case menu_selection
        when 1
            clear_commandline()
            profile_menu(account_file, user_account)
        # View my task
        when 2
            # List it as a numbered list
            choices = create_ordered_list(user_account.get_tasks, 1)
            if !choices.empty?
                # Get index position from the hash to delete task in the array in user details
                task_index = prompt.select("Select which task is DONE:", choices, cyle: true)
                if task_index != -1
                    confirm = prompt.yes?("Is this task completed?")
                    if confirm
                        user_account.my_task.delete_task(task_index)
                        puts "Task DONE!"
                        prompt.keypress("Press any key to continue")
                    end
                end
            else
                puts "Task list is EMPTY!"
                prompt.keypress("Press any key to continue")
            end
            clear_commandline()
        # Create Task
        when 3
            # Appending to the task list
            task = prompt.ask('Input Task:', required: true)
            user_account.my_task.add_task(task)
            puts "Task Added!"
            prompt.keypress("Press any key to continue")
            clear_commandline()
        # Edit Task
        when 4
            # Making the task list selectable for the user to pick
            choices = create_ordered_list(user_account.get_tasks, 1)
            if !choices.empty?
                # Get index position from the hash to edit the task in the array in user details
                task_index = prompt.select("Which task would you like to edit?", choices, cyle: true)
                if task_index != -1
                    new_task = prompt.ask("What is the new task?")
                    # Replace old task with new editted task
                    confirm = prompt.yes?("Confirm EDIT?")
                    if confirm
                        user_account.my_task.update_task(task_index, new_task)
                        puts "Task Updated!"
                        prompt.keypress("Press any key to continue")
                    end
                end
            else
                puts "Task list is EMPTY!"
                prompt.keypress("Press any key to continue")
            end
            clear_commandline()
        # Delete Task
        when 5
            # Making the task list selectable for the user to pick
            choices = create_ordered_list(user_account.get_tasks, 1)
            if !choices.empty?
                # Get index position from the hash to delete task in the array in user details
                task_index = prompt.select("Which task would you like to delete?", choices, cyle: true)
                if task_index != -1
                    confirm = prompt.yes?("Are you sure?")
                    if confirm
                        user_account.my_task.delete_task(task_index)
                        puts "Task Deleted!"
                        prompt.keypress("Press any key to continue")
                    end
                end
            else
                puts "Task list is EMPTY!"
                prompt.keypress("Press any key to continue")
            end
            clear_commandline()
        when 6
            assigned_task(account_file, assigned_file, user_account)
        when 0
            db_update_user_tasks(tasks_file, user_account)
            puts "byebye"
            break
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
                menu.choice "Cancel", 0
            end
            if decision != 0
                new_name = prompt.ask("What would you like it to change to?")
                confirm = prompt.yes?("Are you sure?")
                if confirm
                    case decision
                    when 1
                        user_account.first_name = new_name
                        db_update_users_name(account_file, user_account.id, 1, new_name)
                        puts "First Name Updated!"
                        prompt.keypress("Press any key to continue")
                    when 2
                        db_update_users_name(account_file, user_account.id, 2, new_name)
                        user_account.last_name = new_name
                        puts "Last Name Updated!"
                        prompt.keypress("Press any key to continue")
                    end
                end
            end
            clear_commandline()
        # Edit user password
        when 2
            password = prompt.mask('Confirm your password:', required: true, echo: true)
            # p validate_password(account_file, user_account.id, password)
            # p account_file
            if validate_password(account_file, user_account.id, password)
                new_password = prompt.ask("New Password:")
                retype_password = prompt.mask("Re-type password:", required: true, echo: true)
                if new_password != retype_password
                    puts "Password did not match!"
                else
                    db_update_user_password(account_file, user_account.id, new_password)
                    puts "Password changed!"
                end
            end
            prompt.keypress("Press any key to continue")
            clear_commandline()
        when 0
            clear_commandline()
        end

    end
end

def assigned_task(account_file, assigned_file, user_account)
    prompt = TTY::Prompt.new
    # if users assigned list hasn't been loaded yet
    if user_account.get_assigned_list.empty?
        assigned_parsed = JSON.load_file(assigned_file, symbolize_names: true)
        assigned_parsed.each do |task|
            if task[:assignee_id] == user_account.id
                p "TASKS LOADED"
                user_account.get_assigned_list << task
            end
        end
    end
        # p assigned_tasks
    p user_account.assigned_tasks

    menu_selection = 1
    # While user hasn't quit the menu
    while menu_selection != 0
        puts user_account.display_name()
        choices = {"Assign a Task" => 1, "View Assigned Tasks" => 2, "View Task Assigned to Me" => 3, "Back" => 0}
        
        menu_selection = prompt.select("What would you like to do?", choices, cycle: true)
        case menu_selection
        # Assign TAASK
        when 1
            # [id, FirstName LastName]
            user_list = db_get_user_accounts(account_file, user_account.id)
            # List it as a numbered list
            choices = create_ordered_list(user_list, 2)

            if !choices.empty?
                # Get index position from the hash to delete task in the array in user details
                user_index = prompt.select("Which user would you like to assign a task to?", choices, cyle: true)
                # If user didn't cancel
                if user_index != -1
                    task = prompt.ask('Input Task:', required: true)
                    confirm = prompt.yes?("Is this what you want to assign?")
                    if confirm
                        db_create_assigned_task(assigned_file, user_account, user_list, user_index, task)
                        puts "Assigned TASK!"
                        prompt.keypress("Press any key to continue")
                    end
                end
            else
                puts "No other USERS in the app"
                prompt.keypress("Press any key to continue")
            end
            # clear_commandline()

        # View Assigned Tasks
        when 2
            assigned_list = db_get_assigned_tasks(assigned_file, user_account.id)
            choices = create_ordered_list(assigned_list, 3)
            if !choices.empty?
                # Get index position from the hash to delete task in the array in user details
                task_index = prompt.select("Select a task:", choices, cyle: true)
                if task_index != -1
                    choices = {"Edit Task" => 1, "Delete Task" => 2, "Cancel" => 0}
                    edit_selection = prompt.select("What would you like to do?", choices, cycle: true)
                    case edit_selection
                    # View my profile
                    when 1
                        new_task = prompt.ask("What is the new task?")
                        # Replace old task with new edited task
                        confirm = prompt.yes?("Confirm EDIT?")
                        if confirm
                            db_update_assigned_task(assigned_file, assigned_list[task_index], new_task)
                            puts "Task Updated!"
                            prompt.keypress("Press any key to continue")
                        end
                    when 2
                        confirm = prompt.yes?("Confirm DELETE?")
                        if confirm
                            db_delete_assigned_task(assigned_file, assigned_list[task_index])
                            puts "Task Deleted!"
                            prompt.keypress("Press any key to continue")
                        end
                    end

                end
            else
                puts "Task list is EMPTY!"
                prompt.keypress("Press any key to continue")
            end
            # clear_commandline()
        # View task assigned to me
        when 3
            assigned_to_me = db_get_assigned_to_me(assigned_file, user_account.id)
            choices = create_ordered_list(assigned_to_me, 4)
            if !choices.empty?
                # Get index position from the hash to delete task in the array in user details
                task_index = prompt.select("Select a task:", choices, cyle: true)
                if task_index != -1
                    confirm = prompt.yes?("Is this task completed?")
                    if confirm
                        db_delete_assigned_task(assigned_file, assigned_to_me[task_index])
                        puts "Task Completed!"
                        prompt.keypress("Press any key to continue")
                    end
                end
            else
                puts "Task list is EMPTY!"
                prompt.keypress("Press any key to continue")
            end
        when 0
            clear_commandline()
        end

    end
end

def create_ordered_list(unordered_list, type)
    choices = {}
    if !unordered_list.empty?
        case type
        when 1
            unordered_list.each_with_index do |task, index|
                # key is the task and the value is index of the task in the array
                choices["#{index+1}. #{task}"] = index
            end
        when 2
            unordered_list.each_with_index do |user, index|
                # key is the task and the value is index of the task in the array
                choices["#{index+1}. #{user[1]} #ID:#{user[0]}"] = index
            end
        when 3
            unordered_list.each_with_index do |task, index|
                choices["#{index+1}. Assigned To: #{task[:assigned_name]} \nTask: #{task[:task]}"] = index
            end
        
        when 4
            unordered_list.each_with_index do |task, index|
                choices["#{index+1}. Assigned By: #{task[:assignee_name]} \nTask: #{task[:task]}"] = index
            end
        end
        choices["Cancel"] = -1
    end
    return choices
end

def create_assigned_ordered_list(task_list)
    choices = {}
    p task_list
    if !task_list.empty?
        task_list.each_with_index do |task, index|
            choices["#{index+1}. Assigned To: #{task[:assigned_name]} \nTask: #{task[:task]}"] = index
        end
        choices["Cancel"] = -1
    end
    return choices
end

def clear_commandline()
    # MAC & LINUX
    system("clear")
    # WINDOWS
    system("cls")
end