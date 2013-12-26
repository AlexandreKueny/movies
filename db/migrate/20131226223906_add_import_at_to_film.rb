class AddImportAtToFilm < ActiveRecord::Migration
  def change
    add_column :films, :import_at, :datetime
  end
end
