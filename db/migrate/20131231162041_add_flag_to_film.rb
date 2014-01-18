class AddFlagToFilm < ActiveRecord::Migration
  def change
    add_column :films, :duplicate, :boolean, default: false
  end
end
