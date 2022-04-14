class AddPriorityToArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :priority, :integer
  end
end
