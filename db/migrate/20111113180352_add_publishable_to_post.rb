class AddPublishableToPost < ActiveRecord::Migration
  def change
    add_column :posts, :publishable, :boolean, :default => 0
  end
end
