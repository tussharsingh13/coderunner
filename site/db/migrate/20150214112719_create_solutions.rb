class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.string :problem
      t.text :code

      t.timestamps null: false
    end
  end
end
