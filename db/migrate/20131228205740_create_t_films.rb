class CreateTFilms < ActiveRecord::Migration
  def change
    create_table :t_films do |t|
      t.string :name
      t.integer :size
      t.references :torrent

      t.timestamps
    end
  end
end
