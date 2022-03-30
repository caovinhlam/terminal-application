# Create an account
def create_account(filename, firstname, lastname, username, password)
    parsed = JSON.load_file(filename, symbolize_names: true)
    used_ids = parsed[0][:created_id]
    random_id = rand(100000)
    
    # while a duplicaste id exist, create a new one
    while used_ids.include?(random_id)
        random_id = rand(100000)
    end

    # append new id to created ids
    parsed[0][:created_id] << random_id

    # append new account to accounts.json
    new_account = { id: random_id, firstname: firstname, lastname: lastname, username: username, password: password, tasks: [] }
    parsed << new_account
    File.write(filename, JSON.pretty_generate(parsed))
end

# Login Account
def login_account(filename, username, password)
    require_relative '../classes'

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