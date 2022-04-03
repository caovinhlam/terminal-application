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