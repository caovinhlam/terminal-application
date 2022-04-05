require './classes'

describe User do
    let(:user) { User.new(123, 'Bob', 'Jane') }

    it 'can be instantiated' do
        expect(user).not_to be_nil
        expect(user).to be_an_instance_of User
    end

    describe '.id' do
        it 'returns their id' do
            expect(user.id).to eq 123
        end
    end

    describe '.first_name' do
        it 'returns their first name' do
            expect(user.first_name).to eq 'Bob'
        end
    end

    describe '.last_name' do
        it 'returns their last name' do
            expect(user.last_name).to eq 'Jane'
        end
    end

    it 'returns a Task class' do
        expect(user.my_task).not_to be_nil
        expect(user.my_task).to be_an_instance_of Tasks
    end
    
    describe '.display_name()' do
        it "displays the user's full name" do
            expect(user.display_name()).to eq 'Bob Jane'
        end
    end

    describe '.get_tasks()' do
        it 'returns an empty array from the Task class' do
            expect(user.get_tasks()).to eq([])
        end
    end
end