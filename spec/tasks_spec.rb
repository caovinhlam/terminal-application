require './classes'

describe Tasks do
    let(:task) { Tasks.new([]) }
    let(:task2) {Tasks.new(['test1'])}

    it 'can be instantiated' do
        expect(task).not_to be_nil
        expect(task).to be_an_instance_of Tasks
    end

    describe '.tasks' do
        it 'returns an empty tasks array' do
            expect(task.tasks).to eq([])
        end
    end
    
    describe '.display_list()' do
        it 'outputs tasks array in an order list' do
            display = Tasks.new(['One','Two','Three'])
            expect { display.display_list() }.to output("1. One\n2. Two\n3. Three\n").to_stdout
        end
    end

    describe '.add_task' do
        it 'adds a task to the tasks array' do
            expect(task.add_task('test1')).to eq(['test1'])
        end
    end

    describe '.update_task' do
        it 'updates a task in the tasks array' do
            task2.update_task(0, 'test2')
            expect(task2.tasks).to match_array(['test2'])
        end
    end
    
    describe '.delete_task' do
        it "deletes a task in the tasks array" do
            task2.delete_task(0)
            expect(task2.tasks).to match_array([])
        end
    end
    
    describe '.empty()' do
        it 'returns true if tasks array is empty' do
            expect(task.empty?).to eq true
        end
        it 'returns false if tasks array is not empty' do
            expect(task2.empty?).to eq false
        end
    end
end