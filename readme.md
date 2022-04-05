# KANRI

### ABOUT

KANRI is a simple TODO list app that runs from the terminal.  
It allows you to easily manage your tasks and assign tasks to other users who has created an account on this app.

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
1. Run ./run.sh to begin the installation
2. If gem bundler is already installed it will skip the bundler installation
3. Dependencies for the app will be automatically installed
4. App will open after installation

### Using the App
1. After running ./run.sh
2. App will open to the LOGIN menu
3. Use Up and Down arrow keys to move around the menu
4. Hit ENTER to select the menu option
5. Follow the prompts and input the correct information
6. CTRL + C (Windows) or CMD + C (MAC) to cancel out of an input or option

### Dependencies
```ruby
"tty-prompt", "~> 0.23.1"
"tty-font", "~> 0.5.0"
```

### Implementation Plan

[Kanban Board](https://trello.com/b/5EB9ft5d/t1a3-terminal-application)
#### Overview
![App Overview](Images/T1A3-Overview.png)
#### Roadmap
![Roadmap image](Images/T1A3-Roadmap.png)