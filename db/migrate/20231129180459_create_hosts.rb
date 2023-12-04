class CreateHosts < ActiveRecord::Migration[7.0]
  def change
    create_table :hosts do |t|
      t.string :street_address
      t.string :city
      t.string :postcode
      t.float :lat
      t.float :lng
      t.string :property_type
      t.integer :no_of_bedrooms
      t.text :useful_info
      t.text :upcoming_dates
      t.string :hp_type
      t.string :hp_manufacturer
      t.integer :hp_size
      t.integer :hp_year_of_install

      t.timestamps
    end
  end
end
