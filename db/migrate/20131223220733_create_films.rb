class CreateFilms < ActiveRecord::Migration
  def change
    create_table :films do |t|
      t.string :name
      t.integer :size
      t.text :path
      t.text :comment

      t.timestamps
    end
  end
end
