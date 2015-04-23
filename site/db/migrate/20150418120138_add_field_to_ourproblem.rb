class AddFieldToOurproblem < ActiveRecord::Migration
  def change
  add_column :ourproblems, :code, :string
  end
end
