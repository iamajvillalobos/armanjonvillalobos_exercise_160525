class CreateGroupEvents < ActiveRecord::Migration
  def change
    create_table :group_events do |t|
      t.string :name
      t.text :description
      t.string :location
      t.date :start_date
      t.date :end_date
      t.string :status, default: "draft"
      t.integer :user_id

      t.timestamps
    end
  end
end
