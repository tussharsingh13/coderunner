class CreateOurcontests < ActiveRecord::Migration
  def change
    create_table :ourcontests do |t|
      t.string :name
      t.datetime :start
      t.datetime :end
      t.float :duration

      t.timestamps null: false
    end
  end
end
