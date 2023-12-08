class CreateFollowers < ActiveRecord::Migration[7.1]
  def change
    create_table :followers do |t|
      t.string :email
      t.references :host, null: false, foreign_key: true

      t.timestamps
    end
  end
end
