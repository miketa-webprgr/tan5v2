class CreateTangoData < ActiveRecord::Migration[6.0]
  def change
    create_table :tango_data do |t|
      t.references :user, null:false, foregin_key:true
      t.references :wordnote, null:false, foregin_key:true
      t.references :tango, null:false, foregin_key:true
      t.integer :trial_num
      t.integer :wrong_num
      t.integer :star

      t.timestamps
    end
    add_index :tango_data, [:user_id,:wordnote_id,:tango_id], unique: true
  end
end
