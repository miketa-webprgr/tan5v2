class AddLastQuestionToTangoConfigs < ActiveRecord::Migration[6.0]
  def change
    add_column :tango_configs, :last_question, :integer
  end
end
