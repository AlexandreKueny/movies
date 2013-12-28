class CreateTorrents < ActiveRecord::Migration
  def change
    create_table :torrents do |t|
      t.string :name
      t.text :path
      t.text :comment
      t.datetime :import_at
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
