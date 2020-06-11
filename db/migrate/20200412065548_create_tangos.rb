class CreateTangos < ActiveRecord::Migration[6.0]
  def change
    create_table :tangos do |t|
      t.references :wordnote, null: false, index:false, foregin_key: true
      t.string :question,  null: false
      t.string :answer,  null: false
      t.string :hint 

      t.timestamps
    end
    add_index :tangos, :created_at
    add_index :tangos, [ :wordnote_id, :created_at]
  end
end
