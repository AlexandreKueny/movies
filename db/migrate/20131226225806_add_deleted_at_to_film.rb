class AddDeletedAtToFilm < ActiveRecord::Migration
  def change
    add_column :films, :deleted_at, :datetime
  end
end
