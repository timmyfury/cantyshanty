class AddLegacyIdField < ActiveRecord::Migration
  def up
    add_column :posts, :legacy_slug, :string
  end

  def down
    remove_column :posts, :legacy_slug
  end
end
