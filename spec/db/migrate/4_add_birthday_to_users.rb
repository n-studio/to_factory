class AddBirthdayToUsers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :birthday, :datetime
  end

  def self.down
    remove_column :users, :birthday
  end
end
