class User
    # Reader - read only, writer - write only, accessor is both
    attr_accessor :first_name, :last_name, :task

    def initialize(first_name, last_name, task=[])
        @first_name =  first_name
        @last_name = last_name
        @task = task
    end

end

