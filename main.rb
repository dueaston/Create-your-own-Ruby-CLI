# task_manager.rb
require 'yaml'
require 'bcrypt'

class TaskManager
  attr_reader :current_user

  def initialize
    @tasks = load_tasks
    @users = load_users
    @current_user = nil
  end

  def load_tasks
    if File.exist?('tasks.yaml')
      YAML.load_file('tasks.yaml')
    else
      []
    end
  end

  def save_tasks
    File.open('tasks.yaml', 'w') { |file| file.write(@tasks.to_yaml) }
  end

  def load_users
    if File.exist?('users.yaml')
      YAML.load_file('users.yaml')
    else
      []
    end
  end

  def save_users
    File.open('users.yaml', 'w') { |file| file.write(@users.to_yaml) }
  end

  def add_user(username, password)
    hashed_password = BCrypt::Password.create(password)
    @users << { username: username, password: hashed_password }
    save_users
    puts "User created: #{username}"
  end

  def login(username, password)
    user = @users.find { |u| u[:username] == username }
    if user && BCrypt::Password.new(user[:password]) == password
      @current_user = user
      puts "Login successful, welcome #{username}!"
    else
      puts "Invalid username or password."
    end
  end

  def logout
    @current_user = nil
    puts "Logout successful."
  end

  def reset_password(username, new_password)
    user = @users.find { |u| u[:username] == username }
    if user
      user[:password] = BCrypt::Password.create(new_password)
      save_users
      puts "Password reset successful for #{username}."
    else
      puts "User not found."
    end
  end

  def scrape_website(url)
    # Implement web scraping logic here
    puts "Web scraping functionality is not implemented in this example."
  end

  # ... (Other task management methods)

end

# CLI

task_manager = TaskManager.new

loop do
  puts "\nTask Manager Menu:"
  puts "1. Add Task"
  puts "2. List Tasks"
  puts "3. Complete Task"
  puts "4. Remove Task"
  puts "5. Web Scraping"
  puts "6. Login"
  puts "7. Sign Up"
  puts "8. Logout"
  puts "9. Reset Password"
  puts "10. Exit"

  print "Enter your choice: "
  choice = gets.chomp.to_i

  case choice
  when 1
    print "Enter task: "
    task = gets.chomp
    task_manager.add_task(task)
  when 2
    task_manager.list_tasks
  when 3
    print "Enter task index to mark as completed: "
    index = gets.chomp.to_i
    task_manager.complete_task(index)
  when 4
    print "Enter task index to remove: "
    index = gets.chomp.to_i
    task_manager.remove_task(index)
  when 5
    print "Enter URL to scrape: "
    url = gets.chomp
    task_manager.scrape_website(url)
  when 6
    print "Enter username: "
    username = gets.chomp
    print "Enter password: "
    password = gets.chomp
    task_manager.login(username, password)
  when 7
    print "Enter new username: "
    new_username = gets.chomp
    print "Enter password: "
    new_password = gets.chomp
    task_manager.add_user(new_username, new_password)
  when 8
    task_manager.logout
  when 9
    print "Enter username for password reset: "
    reset_username = gets.chomp
    print "Enter new password: "
    new_password = gets.chomp
    task_manager.reset_password(reset_username, new_password)
  when 10
    task_manager.save_tasks
    task_manager.save_users
    puts "Exiting Task Manager. Goodbye!"
    break
  else
    puts "Invalid choice. Please enter a valid option."
  end
end
