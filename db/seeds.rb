# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Faker::Config.locale = :ja

admin_user = User.new(
  name: "admin",
  email: "admin@example.com",
  password: ENV['ADMIN_PASSWORD'],
  admin: true)
admin_user.skip_confirmation!
admin_user.save!
admin_user.confirm

test_user = User.new(
  name: "test_user",
  email: "test_user@example.com",
  password: "password")
test_user.skip_confirmation!
test_user.save!
test_user.confirm

50.times do |n|
  name = Faker::Name.unique.name
  email = "test#{n + 1}@example.com"
  password = 'password'
  user = User.new(name: name,
               email: email,
               password: password)
  user.skip_confirmation!
  user.save!
  user.confirm
end

all_users = User.all
owners = all_users.slice(0, 5)
members = all_users.slice(5, 45)

# create projects
owners.each do |owner|
  description = Faker::Lorem.paragraphs.inject { |result, paragraph| result + paragraph + "\n" }
  project_name = "#{owner.name}'s project"
  project = owner.projects.create!(name: project_name, description: description, due_on: 1.year.after)
  owner.project_members.last.update!(accepted_project_invitation: true, owner: true)
end

# add project members and create tickets
Project.all.each do |project|
  project_members = members.sample(8)
  project_members.each do |member|
    project.project_members.create!(user_id: member.id,
                                    accepted_project_invitation: true)
  end

  project_members << project.project_members.where(owner: true).first

  30.times do |i|
    ticket_attributes = {}
    ticket_attributes[:title] = Faker::Lorem.sentence
    ticket_attributes[:description] = Faker::Lorem.paragraphs.inject { |result, paragraph| result + paragraph +  "\n"}
    ticket_attributes[:due_on] = rand(100).day.after
    ticket_attributes[:assignee_id] = project_members.sample.id
    ticket_attributes[:creator_id] = project_members.sample.id
    ticket_attributes[:ticket_attribute_id] = project.ticket_attributes.sample.id
    ticket_attributes[:ticket_status_id] = project.ticket_statuses.sample.id
    ticket_attributes[:ticket_priority_id] = project.ticket_priorities.sample.id
    ticket = project.tickets.create!(ticket_attributes)
  end
end
