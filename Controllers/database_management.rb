def db_update_users_name(account_file, userid, name_type, new_name)
    account_parsed = JSON.load_file(account_file, symbolize_names: true)
    account_parsed.each do |user|
        if (user[:id] == userid)
            if name_type == 1
                user[:firstname] = new_name
            else
                user[:lastname] = new_name
            end
            File.write(account_file, JSON.pretty_generate(account_parsed))
            break
        end
    end
end

def db_update_user_password(account_file, userid, new_password)
    account_parsed = JSON.load_file(account_file, symbolize_names: true)
    account_parsed.each do |user|
        if (user[:id] == userid)
            user[:password] = new_password
            File.write(account_file, JSON.pretty_generate(account_parsed))
            break
        end
    end
end

def db_update_user_tasks(tasks_file, user_account)
    tasks_parsed = JSON.load_file(tasks_file, symbolize_names: true)
    tasks_parsed.each do |user|
        if (user[:id] == user_account.id)
            user[:tasks] = user_account.get_tasks
            File.write(tasks_file, JSON.pretty_generate(tasks_parsed))
            break
        end
    end
end

### ASSIGNED TASKS ###
def db_get_user_accounts(account_file, userid)
    # [id, FirstName LastName]
    user_list = []
    account_parsed = JSON.load_file(account_file, symbolize_names: true)
    account_parsed.each do |user|
        if (user[:id] != userid && user[:id] != nil)
            user_info = [user[:id], "#{user[:firstname]} #{user[:lastname]}"]
            user_list << user_info
        end
    end
    return user_list
end

def db_create_assigned_task(assigned_file, user_account, user_list, user_index, task)
    assigned_parsed = JSON.load_file(assigned_file, symbolize_names: true)
    random_id = rand(1000000)
    # while a duplicaste id exist, create a new one
    while assigned_parsed[0][:created_id].include? random_id
        random_id = rand(1000000)
    end
    # append new id to created ids
    assigned_parsed[0][:created_id] << random_id
    assigned_task = Assigned_Task.new(random_id, user_account.id, user_account.full_name(), user_list[user_index][0], user_list[user_index][1], task)
    assigned_parsed << assigned_task.to_json
    File.write(assigned_file, JSON.pretty_generate(assigned_parsed))
    # user_account.get_assigned_list << assigned_task.to_json
end

def db_get_assigned_tasks(assigned_file, userid)
    assigned_list = []
    assigned_parsed = JSON.load_file(assigned_file, symbolize_names: true)
    assigned_parsed.each do |task|
        if (task[:assignee_id] == userid)
            assigned_list << task
        end
    end
    return assigned_list
end

def db_update_assigned_task(assigned_file, assigned_task_info, new_task)
    assigned_parsed = JSON.load_file(assigned_file, symbolize_names: true)
    assigned_parsed.each do |task|
        if task[:id] == assigned_task_info[:id]
            task[:task] = new_task
            File.write(assigned_file, JSON.pretty_generate(assigned_parsed))
            break
        end
    end
end

def db_delete_assigned_task(assigned_file, assigned_task_info)
    assigned_parsed = JSON.load_file(assigned_file, symbolize_names: true)
    assigned_parsed.each_with_index do |task, index|
        if task[:id] == assigned_task_info[:id]
            assigned_parsed.delete_at(index)
            File.write(assigned_file, JSON.pretty_generate(assigned_parsed))
            break
        end
    end
end

def db_get_assigned_to_me(assigned_file, userid)
    assigned_to_me = []
    account_parsed = JSON.load_file(assigned_file, symbolize_names: true)
    account_parsed.each do |task|
        if (task[:assigned_id] == userid)
            assigned_to_me << task
        end
    end
    return assigned_to_me
end