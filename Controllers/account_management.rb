# Create an account
def create_account(account_file, tasks_file, firstname, lastname, username, password)
    account_parsed = JSON.load_file(account_file, symbolize_names: true)
    tasks_parsed = JSON.load_file(tasks_file, symbolize_names: true)

    random_id = rand(100000).to_s.to_sym

    # while a duplicaste id exist, create a new one
    while account_parsed[0][:created_id].key?(random_id)
        random_id = rand(100000)
    end

    # append new id to created ids
    account_parsed[0][:created_id][random_id] = username

    # append new account to accounts.json
    account_parsed << { id: random_id, firstname: firstname, lastname: lastname, username: username, password: password }
    tasks_parsed << { id: random_id, tasks: [] }
    File.write(account_file, JSON.pretty_generate(account_parsed))
    File.write(tasks_file, JSON.pretty_generate(tasks_parsed))
end

# Login Account
def login_account(account_file, username, password)
    require_relative '../classes'

    parsed = JSON.load_file(account_file, symbolize_names: true)
    parsed.each do |user|
        if (user[:username] == username) && (user[:password] == password)
            puts "You've logged in!"
            user_account = User.new(user[:id], user[:firstname], user[:lastname])
            return user_account
        end
    end
    return false
end

def load_tasks(tasks_file, userid)
    parsed = JSON.load_file(tasks_file, symbolize_names: true)
    parsed.each do |user|
        if (user[:id] == userid)
            puts "Got the task"
            return user[:tasks]
        end
    end
end

# def validate_username(account_file, username)
#     parsed = JSON.load_file(account_file, symbolize_names: true)
#     parsed.each do |user|

def validate_username(account_file, username)
    parsed = JSON.load_file(account_file, symbolize_names: true)
    parsed.each do |user|
        if user[:username] == username
            return true
        end
    end
    return false
end


def validate_password(account_file, userid, password)
    parsed = JSON.load_file(account_file, symbolize_names: true)
    parsed.each do |user|
        if (user[:id] == userid) && (user[:password] == password)
            return true
        end
    end
    return false
end