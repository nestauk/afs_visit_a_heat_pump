class CreateBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.references :event, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :quantity
      t.text :notes

      t.timestamps
    end
  end
end
