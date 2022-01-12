class AddColumnToArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :is_public, :boolean, null: false, default: true
  end
end
