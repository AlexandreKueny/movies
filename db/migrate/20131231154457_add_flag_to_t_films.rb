class AddFlagToTFilms < ActiveRecord::Migration
  def change
    add_column :t_films, :duplicate, :boolean, default: false
  end
end
