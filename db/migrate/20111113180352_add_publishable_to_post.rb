class AddPublishableToPost < ActiveRecord::Migration
  def change
    add_column :posts, :publishable, :boolean, :default => false
  end
end
