require 'tty-prompt'
require 'json'
require_relative 'classes'
require_relative 'controllers/account_management'
require_relative 'controllers/menu_management'
require_relative 'controllers/database_management'

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

account_file = 'accounts.json'
tasks_file = 'tasks_db.json'
assigned_file = 'assigned_tasks.json'
login_menu(account_file, tasks_file, assigned_file)

# account_parsed = JSON.load_file(account_file, symbolize_names: true)
# p account_parsed[0][:created_id]
# id = 29474.to_s.to_sym
# p account_parsed[0][:created_id].has_key?(id)

# Challenges
# Menu looping, which menu displays first
# How my user should be hanldled in the class
# Overthinking of issues
# Feature creep

class Assigned_Task
    # Reader - read only, writer - write only, accessor is both
    attr_accessor :id, :assignee_id, :assignee_name, :assigned_id, :assigned_name, :task

    def initialize(id, assignee_id, assignee_name, assigned_id, assigned_name, task)
        @id = id
        @assignee_id = assignee_id
        @assignee_name = assignee_name
        @assigned_id = assigned_id
        @assigned_name = assigned_name
        @task = task
    end

    # def as_json()
    #     {
    #         id: @id, 
    #         assignee_id: @assignee_id,
    #         assignee_name: @assignee_name,
    #         assigned_id: @assigned_id,
    #         assigned_name: @assigned_name,
    #         task: @task
    #     }
    # end

    def to_json()
        {
            id: @id, 
            assignee_id: @assignee_id,
            assignee_name: @assignee_name,
            assigned_id: @assigned_id,
            assigned_name: @assigned_name,
            task: @task
        }
    end
end

# a = Assigned_Task.new(123, 321, "Cao Vinh", 44242, "Ben", "JKLDJFKLSD:JF:JFKL:")
# puts a.to_json
# assigned_parsed = JSON.load_file('assigned_tasks.json', symbolize_names: true)
# assigned_parsed << a.to_json
# File.write('assigned_tasks.json', JSON.pretty_generate(assigned_parsed))
