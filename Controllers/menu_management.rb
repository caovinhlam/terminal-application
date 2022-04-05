def login_menu(account_file, tasks_file, assigned_file)
    prompt = TTY::Prompt.new(symbols: {marker: ">"})
    
    begin
        clear_commandline()
        display_title("KANRI")
        menu_selection = prompt.select("What would you like to do?", %w(Login Create\ Account Quit), cycle: true).downcase
        case menu_selection
        when 'login'
            clear_commandline()
            display_title("LOGIN")
            begin
                username = prompt.ask('Username:', required: true).downcase.chomp.strip
                password = prompt.mask('Password:', required: true, echo: true)
                user_account = login_account(account_file, username, password)
                main_menu(account_file, tasks_file, assigned_file, user_account)
            rescue MatchingError => e
                display_error(e)
                retry
            rescue Interrupt
                puts "\nExit from LOGIN screen"
                login_menu(account_file, tasks_file, assigned_file)
            end
        when 'create account'
            clear_commandline()
            display_title("NEW ACCOUNT")
            begin
                first_name = prompt.ask('First name:', required: true).capitalize.chomp.strip
                last_name = prompt.ask('Last name', required: true).capitalize.chomp.strip
                # Checking for duplicate usernames
                begin
                    username = prompt.ask('Username:', required: true).downcase.chomp.strip
                    validate_username(account_file, username)
                rescue MatchingError => e
                    display_error(e)
                    retry
                end
                # Setting New user password
                begin
                    password = prompt.mask('Password:', required: true, echo: true)
                    retype_password = prompt.mask("Re-type password:", required: true, echo: true)
                    raise(MatchingError, "Passwords did not match") if password != retype_password
                rescue MatchingError => e
                    display_error(e)
                    retry
                end

                user_account = create_account(account_file, tasks_file, first_name, last_name, username, password)
                main_menu(account_file, tasks_file, assigned_file, user_account)
            rescue MatchingError => e
                display_error(e)
                retry
            rescue Interrupt
                puts "\nExit from CREATE ACCOUNT screen"
                login_menu(account_file, tasks_file, assigned_file)
            end
        when 'quit'
            goodbye_message()
            exit
        end
    rescue Interrupt
        goodbye_message()
        exit
    end
end

# Menu when user login
def main_menu(account_file, tasks_file, assigned_file, user_account)
    prompt = TTY::Prompt.new(symbols: {marker: ">"})

    begin
        # While user hasn't quit the APP
        menu_selection = 1
        while menu_selection != 0
            clear_commandline()
            display_title("WELCOME")
            choices = {"Profile" => 1, "My Task" => 2, "Assigned Task" => 3, "Logout" => 4, "Quit" => 0}
            menu_selection = prompt.select("What would you like to do?", choices, cycle: true)
            case menu_selection
            #View my profile
            when 1
                profile_menu(account_file, user_account)
            # View my tasks
            when 2
                my_task_menu(account_file, tasks_file, user_account)
            # View assigned tasks
            when 3
                assigned_task_menu(account_file, assigned_file, user_account)
            when 4
                puts highlight("Logging Out...")
                prompt.keypress("Press any key to continue")
                login_menu(account_file, tasks_file, assigned_file)
            when 0
                goodbye_message()
                exit
            end
        end
    rescue Interrupt
        puts highlight("Logged Out")
        login_menu(account_file, tasks_file, assigned_file)
    end
end

def profile_menu(account_file, user_account)
    prompt = TTY::Prompt.new(symbols: {marker: ">"})
    # While user hasn't quit the menu
    begin
        menu_selection = 1
        while menu_selection != 0
            clear_commandline()
            display_title("PROFILE")
            puts green_text("WELCOME #{user_account.display_name()}")
            choices = {"Edit Profile" => 1, "Change Password" => 2, "Back" => 0}
            
            menu_selection = prompt.select("What would you like to do?", choices, cycle: true)
            case menu_selection
            # Edit my profile
            when 1
                decision = prompt.select("Which would you like to edit?", cyle: true) do |menu|
                    menu.choice "First Name: #{user_account.first_name}", 1
                    menu.choice "Last Name: #{user_account.last_name}", 2
                    menu.choice "Cancel", 0
                end

                if decision != 0
                    new_name = prompt.ask("What would you like it to change to?", required: true).chomp.strip
                    confirm = prompt.yes?(highlight("Confirm EDIT?"))
                    if confirm
                        case decision
                        when 1
                            user_account.first_name = new_name
                            db_update_users_name(account_file, user_account.id, 1, new_name)
                            puts highlight("First Name Updated!")
                            prompt.keypress("Press any key to continue")
                        when 2
                            db_update_users_name(account_file, user_account.id, 2, new_name)
                            user_account.last_name = new_name
                            puts highlight("Last Name Updated!")
                            prompt.keypress("Press any key to continue")
                        end
                    end
                end
            # Edit user password
            when 2
                begin
                    password = prompt.mask('Confirm your password:', required: true, echo: true)
                    raise(ConfirmationError, "Incorrect Password") if !validate_password(account_file, user_account.id, password)
                rescue ConfirmationError => e
                    display_error(e)
                    retry
                end
                # User assigning new password
                begin
                    new_password = prompt.ask("New Password:", required: true)
                    retype_password = prompt.mask("Re-type password:", required: true, echo: true)
                    raise(MatchingError, "Passwords did not match") if new_password != retype_password
                rescue MatchingError => e
                    display_error(e)
                    retry
                end
                db_update_user_password(account_file, user_account.id, new_password)
                puts highlight("Password changed!")
                prompt.keypress("Press any key to continue")
            when 0
                break
            end
        end
    rescue Interrupt
        puts "Cancelled Action"
        retry
    end
end

def my_task_menu(account_file, tasks_file, user_account)
    prompt = TTY::Prompt.new(symbols: {marker: ">"})
    # Loading tasks from Database
    if user_account.get_tasks.empty?
        user_account.my_task.tasks = load_tasks(tasks_file, user_account.id)
    end

    begin
        # While user hasn't chosen to go back
        menu_selection = 1
        while menu_selection != 0
            clear_commandline()
            display_title("MY TASKS")
            choices = {"View My Task" => 1, "Create Task" => 2, "Edit Task" => 3, "Delete Task" => 4, "Back" => 0}
            menu_selection = prompt.select("What would you like to do?", choices, cycle: true)
            case menu_selection
            # View my task
            when 1
                # Making the task list selectable for the user to pick
                choices = create_ordered_list(user_account.get_tasks, 1)
                if !choices.empty?
                    # Get index position from the hash to delete task in the array in user details
                    task_index = prompt.select("Select which task is DONE:", choices, cyle: true)
                    if task_index != -1
                        confirm = prompt.yes?(highlight("Is this task completed?"))
                        if confirm
                            user_account.my_task.delete_task(task_index)
                            puts highlight("Task DONE!")
                            prompt.keypress("Press any key to continue")
                        end
                    end
                else
                    puts highlight("Task list is EMPTY!")
                    prompt.keypress("Press any key to continue")
                end
            # Create Task
            when 2
                # Appending to the task list
                task = prompt.ask('Input Task:', required: true).chomp.strip
                user_account.my_task.add_task(task)
                puts highlight("Task Added!")
                prompt.keypress("Press any key to continue")
            # Edit Task
            when 3
                # Making the task list selectable for the user to pick
                choices = create_ordered_list(user_account.get_tasks, 1)
                if !choices.empty?
                    # Get index position from the hash to edit the task in the array in user details
                    task_index = prompt.select("Which task would you like to edit?", choices, cyle: true)
                    if task_index != -1
                        new_task = prompt.ask("What is the new task?", required: true).chomp.strip
                        # Replace old task with new editted task
                        confirm = prompt.yes?(highlight("Confirm EDIT?"))
                        if confirm
                            user_account.my_task.update_task(task_index, new_task)
                            puts highlight("Task Updated!")
                            prompt.keypress("Press any key to continue")
                        end
                    end
                else
                    puts highlight("Task list is EMPTY!")
                    prompt.keypress("Press any key to continue")
                end
            # Delete Task
            when 4
                # Making the task list selectable for the user to pick
                choices = create_ordered_list(user_account.get_tasks, 1)
                if !choices.empty?
                    # Get index position from the hash to delete task in the array in user details
                    task_index = prompt.select("Which task would you like to delete?", choices, cyle: true)
                    if task_index != -1
                        confirm = prompt.yes?(highlight("Confirm DELETE?"))
                        if confirm
                            user_account.my_task.delete_task(task_index)
                            puts highlight("Task Deleted!")
                            prompt.keypress("Press any key to continue")
                        end
                    end
                else
                    puts highlight("Task list is EMPTY!")
                    prompt.keypress("Press any key to continue")
                end
                clear_commandline()
            when 0
                db_update_user_tasks(tasks_file, user_account)
                break
            end
        end
    rescue Interrupt
        puts "Cancelled Action"
        retry
    end
end

def assigned_task_menu(account_file, assigned_file, user_account)
    prompt = TTY::Prompt.new(symbols: {marker: ">"})

    begin
        menu_selection = 1
        # While user hasn't quit the menu
        while menu_selection != 0
            clear_commandline()
            display_title("ASSIGNED TASKS")

            choices = {"Assign a Task" => 1, "View Assigned Tasks" => 2, "View Task Assigned to Me" => 3, "Back" => 0}
            menu_selection = prompt.select("What would you like to do?", choices, cycle: true)
            case menu_selection
            # Assign a Task
            when 1
                begin
                    # [id, FirstName LastName]
                    user_list = db_get_user_accounts(account_file, user_account.id)
                    # Making the user list selectable for the user to pick
                    choices = create_ordered_list(user_list, 2)
                    if !choices.empty?
                        # Get index position from the hash to delete task in the array in user details
                        user_index = prompt.select("Which user would you like to assign a task to?", choices, cyle: true)
                        # If user didn't cancel
                        if user_index != -1
                            task = prompt.ask('Input Task:', required: true).chomp.strip
                            confirm = prompt.yes?(highlight("Is this what you want to assign?"))
                            if confirm
                                db_create_assigned_task(assigned_file, user_account, user_list, user_index, task)
                                puts highlight("Assigned TASK!")
                                prompt.keypress("Press any key to continue")
                            end
                        end
                    else
                        puts highlight("No other USERS in the APP")
                        prompt.keypress("Press any key to continue")
                    end
                rescue Interrupt
                    display_error("Action Cancelled")
                    retry
                end
            # View Assigned Tasks
            when 2
                begin
                    assigned_list = db_get_assigned_tasks(assigned_file, user_account.id)
                    # Making the task list selectable for the user to pick
                    choices = create_ordered_list(assigned_list, 3)
                    if !choices.empty?
                        task_index = prompt.select("Select a task:", choices, cyle: true)
                        if task_index != -1
                            choices = {"Edit Task" => 1, "Delete Task" => 2, "Cancel" => 0}
                            edit_selection = prompt.select("What would you like to do?", choices, cycle: true)
                            case edit_selection
                            # Edit Task and update in the Database
                            when 1
                                new_task = prompt.ask("What is the new task?", required: true).chomp.strip
                                confirm = prompt.yes?(highlight("Confirm EDIT?"))
                                # Replace old task with new edited task
                                if confirm
                                    db_update_assigned_task(assigned_file, assigned_list[task_index], new_task)
                                    puts highlight("Task Updated!")
                                    prompt.keypress("Press any key to continue")
                                end
                            # Delete Task and update in the Database
                            when 2
                                confirm = prompt.yes?(highlight("Confirm DELETE?"))
                                if confirm
                                    db_delete_assigned_task(assigned_file, assigned_list[task_index])
                                    puts highlight("Task Deleted!")
                                    prompt.keypress("Press any key to continue")
                                end
                            end
                        end
                    else
                        puts highlight("Task list is EMPTY!")
                        prompt.keypress("Press any key to continue")
                    end
                rescue Interrupt
                    display_error("Action Cancelled")
                    retry
                end
            # View task assigned to me
            when 3
                begin
                    assigned_to_me = db_get_assigned_to_me(assigned_file, user_account.id)
                    # Making the task list selectable for the user to pick
                    choices = create_ordered_list(assigned_to_me, 4)
                    if !choices.empty?
                        task_index = prompt.select("Select a task:", choices, cyle: true)
                        if task_index != -1
                            confirm = prompt.yes?(highlight("Is this task completed?"))
                            # Delete Task and update in the Database
                            if confirm
                                db_delete_assigned_task(assigned_file, assigned_to_me[task_index])
                                puts highlight("Task Completed!")
                                prompt.keypress("Press any key to continue")
                            end
                        end
                    else
                        puts highlight("Task list is EMPTY!")
                        prompt.keypress("Press any key to continue")
                    end
                rescue Interrupt
                    display_error("Action Cancelled")
                    retry
                end
            when 0
                break
            end
        end
    rescue Interrupt
        puts "Action Cancelled"
        retry
    end
end

def create_ordered_list(unordered_list, type)
    choices = {}
    if !unordered_list.empty?
        # The description or task is the key and the index of the task in the array is the value to the key
        # eg. 3. PICK ME: 2nd index in the array
        case type
        when 1
            unordered_list.each_with_index do |task, index|
                choices["#{index+1}. #{task}"] = index
            end
        when 2
            unordered_list.each_with_index do |user, index|
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

def clear_commandline()
    # MAC & LINUX
    system("clear")
    # WINDOWS
    system("cls")
end