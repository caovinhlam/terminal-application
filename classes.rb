class Tasks
    # Reader - read only, writer - write only, accessor is both
    attr_accessor :tasks

    def initialize(task)
        @tasks = task
    end

    def display_list()
        @tasks.each_with_index do |task, index|
            puts "#{index + 1}. #{task}"
        end
    end

    def add_task(task)
        @tasks << task
    end

    def update_task(index, new_task)
        @tasks[index] = new_task
    end

    def delete_task(index)
        @tasks.delete_at(index)
    end

    def empty()
        return @tasks.empty?
    end
end

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

class User
    # Reader - read only, writer - write only, accessor is both
    attr_accessor :first_name, :last_name, :my_task, :assigned_tasks
    attr_reader :id

    def initialize(id, first_name, last_name)
        @id = id
        @first_name = first_name
        @last_name = last_name
        @my_task = Tasks.new([])
        @assigned_tasks = []
    end

    def display_name()
        return "First name: #{@first_name} \nLast name: #{@last_name}"
    end

    def full_name()
        return "#{@first_name} #{@last_name}"
    end

    def get_tasks()
        return @my_task.tasks
    end

    def get_assigned_list()
        return @assigned_tasks
    end

    def get_assigned_task(index)
        return @assigned_tasks[index]
    end

    def update_assigned_task(index, new_task)
        @assigned_tasks[index][:task] = new_task
    end

    def delete_assigned_task(index)
        @assigned_tasks.delete_at(index)
    end

end