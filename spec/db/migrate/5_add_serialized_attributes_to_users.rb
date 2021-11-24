class AddSerializedAttributesToUsers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :some_attributes, :text
  end

  def self.down
    remove_column :users, :some_attributes
  end
end
