class CreateWordnotes < ActiveRecord::Migration[6.0]
  def change
    create_table :wordnotes do |t|
      t.references :user, null:false, index: false, foregin_key: true
      t.string :name, null: false
      t.string :subject, null: false

      t.timestamps
    end
  end
end
