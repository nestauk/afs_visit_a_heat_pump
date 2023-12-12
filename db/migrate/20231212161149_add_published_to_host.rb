class AddPublishedToHost < ActiveRecord::Migration[7.1]
  def change
    add_column :hosts, :published, :boolean, default: true
  end
end
