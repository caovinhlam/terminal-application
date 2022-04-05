class Tasks
  attr_accessor :tasks

  def initialize(task)
    @tasks = task
  end

  def display_list
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

  def empty?
    @tasks.empty?
  end
end

class Assigned_Task
  attr_accessor :id, :assignee_id, :assignee_name, :assigned_id, :assigned_name, :task

  def initialize(id, assignee_id, assignee_name, assigned_id, assigned_name, task)
    @id = id
    @assignee_id = assignee_id
    @assignee_name = assignee_name
    @assigned_id = assigned_id
    @assigned_name = assigned_name
    @task = task
  end

  def to_json(*_args)
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
  attr_accessor :first_name, :last_name, :my_task
  attr_reader :id

  def initialize(id, first_name, last_name)
    @id = id
    @first_name = first_name
    @last_name = last_name
    @my_task = Tasks.new([])
  end

  def display_name
    "#{@first_name} #{@last_name}"
  end

  def full_name
    "#{@first_name} #{@last_name}"
  end

  def get_tasks
    @my_task.tasks
  end
end
