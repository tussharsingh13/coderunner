class AddSubmitTimeToUsers < ActiveRecord::Migration
  def change
  add_column :users, :lastsubmit, :datetime
  end
end
