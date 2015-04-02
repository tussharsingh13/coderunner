class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.string :name
      t.text :statement
      t.float :timelimit
      t.integer :memory

      t.timestamps null: false
    end
  end
end
