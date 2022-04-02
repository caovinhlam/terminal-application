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

class User
    # Reader - read only, writer - write only, accessor is both
    attr_accessor :first_name, :last_name, :my_task
    attr_reader :id

    def initialize(id, first_name, last_name)
        @id = id
        @first_name = first_name
        @last_name = last_name
        @my_task = Tasks.new([])
    end

    def display_name()
        return "First name: #{@first_name} \nLast name: #{@last_name}"
    end

    def get_tasks()
        return @my_task.tasks
    end

end