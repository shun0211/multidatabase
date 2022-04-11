class AddFlagToComments < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :is_public, :boolean, null: false, default: true
  end
end
