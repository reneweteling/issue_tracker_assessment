# frozen_string_literal: true

User.create!([
  {
    name: 'Micheal Scott',
    email: 'micheal@dm.com',
    password: 'test123',
    password_confirmation: 'test123',
    role: 'manager'
  },
  {
    name: 'Jim Halpert',
    email: 'jim@dm.com',
    password: 'test123',
    password_confirmation: 'test123',
    role: 'user'
  },
  {
    name: 'Dwight Schrute',
    email: 'dwight@dm.com',
    password: 'test123',
    password_confirmation: 'test123',
    role: 'user',
    assigned_issues: [
      Issue.new(
        name: 'Water plants',
        description: 'Plants near the windows need to be watered',
        status: :pending
      ),
      Issue.new(
        name: 'Irritate Jim',
        description: 'Annoy humans not superior to me, Dwight!',
        status: :pending
      ),
    ]
  },
])
