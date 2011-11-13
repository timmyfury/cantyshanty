require 'rubygems'
require 'base58'

class Post < ActiveRecord::Base

  acts_as_taggable

  has_attached_file :image,
                    :styles => {
                      :large => "600x600>",
                      :medium => "400x400>",
                      :small => "200x200>",
                      :thumb => "100x100#"
                    },
                    :path => ":id/:style.:extension",
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml"

  scope :unpublished, lambda { 
    where("posts.published_at IS NULL")
  }

  scope :published, lambda { 
    where("posts.published_at IS NOT NULL AND posts.published_at <= ?", Time.zone.now)
  }

  scope :recent, order("posts.published_at DESC")

  def publish
    self.published_at = Time.now
    self.slug = Base58.encode(self.id)
    self.save
  end

  def publishable
    return self.title != nil && self.title != '' && self.tags.count > 0
  end

end
