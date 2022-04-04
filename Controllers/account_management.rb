# Create an account
def create_account(account_file, tasks_file, firstname, lastname, username, password)
    account_parsed = JSON.load_file(account_file, symbolize_names: true)
    tasks_parsed = JSON.load_file(tasks_file, symbolize_names: true)

    # while a duplicated id exist, create a new one
    random_id = rand(100000)    
    while account_parsed[0][:created_id].include? random_id
        random_id = rand(100000)
    end

    # append new id to created ids
    account_parsed[0][:created_id] << random_id

    # append new account to accounts.json
    account_parsed << { id: random_id, firstname: firstname, lastname: lastname, username: username, password: password }
    tasks_parsed << { id: random_id, tasks: [] }
    File.write(account_file, JSON.pretty_generate(account_parsed))
    File.write(tasks_file, JSON.pretty_generate(tasks_parsed))

    user_account = User.new(random_id, firstname, lastname)
    return user_account
end

# Login Account
def login_account(account_file, username, password)
    parsed = JSON.load_file(account_file, symbolize_names: true)
    parsed.each do |user|
        if (user[:username] == username) && (user[:password] == password)
            user_account = User.new(user[:id], user[:firstname], user[:lastname])
            return user_account
        end
    end
    raise(MatchingError, "Incorrect Username or Password")
end

# Checking for duplicate users
def validate_username(account_file, username)
    parsed = JSON.load_file(account_file, symbolize_names: true)
    parsed.each do |user|
        raise(MatchingError, "Try Again. Username already exist") if user[:username] == username
    end
    return false
end

# Confirming password with user before changing passwords
def validate_password(account_file, userid, password)
    parsed = JSON.load_file(account_file, symbolize_names: true)
    parsed.each do |user|
        if (user[:id] == userid) && (user[:password] == password)
            return true
        end
    end
    return false
end

# Grab tasks from Database and update into USER class
def load_tasks(tasks_file, userid)
    parsed = JSON.load_file(tasks_file, symbolize_names: true)
    parsed.each do |user|
        if (user[:id] == userid)
            return user[:tasks]
        end
    end
end


