class AddFieldToOurcontest < ActiveRecord::Migration
  def change
  add_column :ourcontests, :code, :string
  end
end
