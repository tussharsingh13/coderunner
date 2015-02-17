class CreateDatafiles < ActiveRecord::Migration
  def change
    create_table :datafiles do |t|

      t.timestamps null: false
    end
  end
end
