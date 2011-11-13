require 'rubygems'
require 'base58'

class Post < ActiveRecord::Base

  before_save :check_publishable

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

  scope :drafts, lambda { 
    where("published_at IS NULL AND publishable = true")
  }

  scope :backlog, lambda {
    where("published_at IS NULL AND publishable = false")
  }

  scope :published, lambda { 
    where("posts.published_at IS NOT NULL AND posts.published_at <= ?", Time.zone.now)
  }

  scope :recent, order("published_at DESC")
  
  def next
    Post.published.where("published_at > ?", self.published_at).order("published_at").last
  end

  def previous
    Post.published.where("published_at < ?", self.published_at).order("published_at").last
  end

  def check_publishable
    if !self.title.empty? && self.tags.count > 0
      self.publishable = true
    end
  end

  def publish
    if self.publishable
      self.published_at = Time.now
      self.slug = Base58.encode(self.id)
      self.save
    end
  end

end
