class CreateTangoConfigs < ActiveRecord::Migration[6.0]
  def change
    create_table :tango_configs do |t|
      t.references :user, null: false, foreign_key: true , null: false
      t.references :wordnote, null: false, foreign_key: true, null: false
      t.string :sort ,default: "asc"
      t.integer :clicked_num ,default: 0
      t.boolean :continue ,default: false
      t.string :filter, default: "none"
      t.integer :font_size 
      t.integer :timer ,default: 0

      t.timestamps
    end
  end
end
