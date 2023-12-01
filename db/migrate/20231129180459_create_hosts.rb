class CreateHosts < ActiveRecord::Migration[7.0]
  def change
    create_table :hosts do |t|
      t.string :street_address
      t.string :city
      t.string :postcode
      t.float :lat
      t.float :lng
      t.integer :property_type
      t.integer :hp_type

      t.timestamps
    end
  end
end
