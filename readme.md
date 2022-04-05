# KANRI

### ABOUT

KANRI is a simple TODO list app that runs from the terminal.  
It allows you to easily manage your TASKS and ASSIGN TASKS to other users who has created an account on this app.

### Features

Account Management:
- [x] Users can create an account
- [x] User profiles can be edited
- [x] Password can be changed

My Task:
- [x] Create, Update and Delete tasks that you've assigned to yourself
- [x] View a list of tasks that has been created and it is also selectable

Assigned Task:
- [x] Assign task to other users
- [x] Edit and delete tasks that you've assigned to others
- [x] View tasks that have been assigned to yourself by other users

### Installation
1. Run ./kanri.sh to begin the installation
2. If gem bundler is already installed it will skip the bundler installation
3. Dependencies for the app will be automatically installed
4. App will open after installation

### Using the App
1. After running ./kanri.sh
2. App will open to the LOGIN menu
3. Use Up and Down arrow keys to move around the menu
4. Hit ENTER to select the menu option
5. Follow the prompts and input the correct information
6. CTRL + C (Windows) or CMD + C (MAC) to cancel out of an input or option

#### Note
Create two accounts and run the app on two command shell to see the effects of assigned tasks change at real time

### Styling Conventions

This app will adhere to [RuboCop's](https://github.com/rubocop/ruby-style-guide) Ruby Style Guide

### Command Line Arguments

The program uses 3 arguments that it reads from the command line
```ruby
ruby main.rb arg1 arg2 arg3
```
- ARG1 - Name of the JSON file which will store the user accounts (accounts.json)
- ARG2 - Name of the JSON file which will store the tasks for each users (tasks.db.json)
- ARG3 - Name of the JSON file which will store assigned tasks (assigned_tasks_db.json)

### Dependencies
```ruby
"tty-prompt", "~> 0.23.1"
"tty-font", "~> 0.5.0"
"rainbow", "~> 3.1"
"rspec", "~> 3.11"
"json"
```

### System and Hardware Requirements
Kanri will run on both Windows and Mac systems