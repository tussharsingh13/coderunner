class CreateOurproblems < ActiveRecord::Migration
  def change
    create_table :ourproblems do |t|
      t.string :name
      t.text :statement
      t.float :timelimit
      t.integer :memory
      t.integer :contestid

      t.timestamps null: false
    end
  end
end
