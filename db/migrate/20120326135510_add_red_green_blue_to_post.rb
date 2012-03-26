class AddRedGreenBlueToPost < ActiveRecord::Migration
  def up
    add_column :posts, :red, :string
    add_column :posts, :green, :string
    add_column :posts, :blue, :string
    add_column :posts, :hue, :string
    add_column :posts, :saturation, :string
    add_column :posts, :luminosity, :string
    add_column :posts, :hex, :string
  end

  def down
    remove_column :posts, :red
    remove_column :posts, :green
    remove_column :posts, :blue
    remove_column :posts, :hue
    remove_column :posts, :saturation
    remove_column :posts, :luminosity
    remove_column :posts, :hex
  end
end
