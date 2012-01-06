class AddSearchableFieldToPosts < ActiveRecord::Migration
  def up
    add_column :posts, :search, :text
  end

  def down
    remove_column :posts, :search
  end
end
