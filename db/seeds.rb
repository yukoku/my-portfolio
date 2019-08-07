# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

TicketAttribute.create!(
  [
    {
      ticket_attribute: 'ticket.attribute.bug'
    },
    {
      ticket_attribute: 'ticket.attribute.feature'
    },
    {
      ticket_attribute: 'ticket.attribute.support'
    },
    {
      ticket_attribute: 'ticket.attribute.environment'
    },
    {
      ticket_attribute: 'ticket.attribute.document'
    },
  ]
)

TicketStatus.create!(
  [
    {
      status: 'ticket.status.todo'
    },
    {
      status: 'ticket.status.doing'
    },
    {
      status: 'ticket.status.done'
    }
  ]
)

TicketPriority.create!(
  [
    {
      priority: 'ticket.priority.very_high'
    },
    {
      priority: 'ticket.priority.high'
    },
    {
      priority: 'ticket.priority.normal'
    },
    {
      priority: 'ticket.priority.low'
    },
    {
      priority: 'ticket.priority.very_low'
    }
  ]
)