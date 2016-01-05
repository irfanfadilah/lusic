class CreateSongs < ActiveRecord::Migration[5.0]
  def change
    create_table :songs do |t|
      t.string :title
      t.string :slug
      t.string :file

      t.timestamps
    end
  end
end
