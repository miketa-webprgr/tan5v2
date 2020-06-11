class AddOpenColumnToWordnote < ActiveRecord::Migration[6.0]
  def change
    add_column :wordnotes, :is_open, :boolean, default: true
  end
end
