# frozen_string_literal: true

class CreateIssues < ActiveRecord::Migration[5.2]
  def change
    create_table :issues do |t|
      t.string :name
      t.text :description
      t.string :status, default: 'pending'
      t.references :manager, index: true, foreign_key: { to_table: :users }
      t.references :assignee, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
