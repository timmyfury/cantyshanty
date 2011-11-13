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

  scope :drafts, where("published_at IS NULL AND publishable = ?", true)

  scope :backlog, where('published_at IS NULL AND publishable = ?', false)

  scope :published, where("posts.published_at IS NOT NULL AND posts.published_at <= ?", Time.zone.now)

  scope :recently_updated, order("updated_at DESC")

  scope :recent, order("published_at DESC")
  
  def next
    Post.published.where("published_at > ?", self.published_at).order("published_at").last
  end

  def previous
    Post.published.where("published_at < ?", self.published_at).order("published_at").last
  end

  def status
    if self.published_at
      'published'
    elsif self.publishable and !self.published_at
      'drafts'
    elsif !self.publishable and !self.published_at
      'backlog'
    end
  end

  def publish
    if self.publishable
      self.published_at = Time.now
      self.slug = Base58.encode(self.id)
      self.save
    end
  end

  private
    def check_publishable
      if self.title && !self.title.empty?
        self.publishable = true
      end
  end

end
