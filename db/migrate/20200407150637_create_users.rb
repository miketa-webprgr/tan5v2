class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      
      t.string :email, null: false
      t.string :name, null: false
      t.string :hashed_password
      t.string :profile
      t.boolean :suspended, null: false, default: false
      t.timestamps
    end

    add_index :users, "LOWER(email)", unique: true
    add_index :users, "name"
  end
end
