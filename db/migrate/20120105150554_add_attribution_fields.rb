class AddAttributionFields < ActiveRecord::Migration
  def up
    add_column :posts, :source_title, :string
    add_column :posts, :source_url, :string
  end

  def down
    remove_column :posts, :source_title
    remove_column :posts, :source_url
  end
end
