class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.references :host, null: false, foreign_key: true
      t.date :date
      t.time :start_at
      t.time :end_at
      t.integer :capacity

      t.timestamps
    end
  end
end
