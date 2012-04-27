class AddMetaToPost < ActiveRecord::Migration
  def self.up
      add_column :posts, :image_meta, :text
    end

    def self.down
      remove_column :posts, :image_meta
    end
end
