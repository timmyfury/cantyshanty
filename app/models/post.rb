require 'rubygems'
require 'base58'

class Post < ActiveRecord::Base

  before_save :check_publishable
  before_save :populate_search_text

  acts_as_taggable

  # acts_as_taggable :tags, :rooms, :colors, 

  has_attached_file :image,
                    :styles => {
                      :large => "600x600>",
                      :medium => "400x400>",
                      :small => "200x200>",
                      :thumb => "100x100#"
                    },
                    :path => ":id/:style.:extension",
                    :storage => :s3,
                    :bucket => 'cantyshanty-production',
                    :s3_credentials => {
                      :access_key_id => ENV['CANTYSHANTY_AWS_ACCESS_KEY'],
                      :secret_access_key => ENV['CANTYSHANTY_AWS_SECRET_KEY']
                    }

  scope :backlog, where('published_at IS NULL AND publishable = ?', false)
  scope :drafts, where("published_at IS NULL AND publishable = ?", true)
  scope :published, where("published_at IS NOT NULL")
  scope :unpublished, where("published_at IS NULL")

  scope :missing_meta, where("image_meta IS NULL")

  scope :attributed, where("published_at IS NOT NULL AND source_title IS NOT NULL AND source_title != ? AND source_url IS NOT NULL AND source_url != ?", "", "")
  scope :unattributed, where("published_at IS NOT NULL AND (source_title IS NULL OR source_title =?) AND (source_url IS NULL OR source_url=?)", "", "")
  
  scope :recent, order("published_at DESC")
  scope :recently_updated, order("updated_at DESC")

  def sourced
    !source_title.blank? and !source_url.blank?
  end

  def image_sizes
    {
      :original => image(:original),
      :large => image(:large),
      :medium => image(:medium),
      :small => image(:small),
      :thumb  => image(:thumb),
    }
  end

  def self.random(how_many=30, only_published=false)
    if only_published
      random_ids = Post.published.find(:all, :select => 'id').map(&:id).shuffle!.slice!(0, how_many)
    else
      random_ids = Post.backlog.find(:all, :select => 'id').map(&:id).shuffle!.slice!(0, how_many)
    end

    Post.where(:id => random_ids)
  end

  def next
    Post.published.where("published_at > ? AND id != ?", self.published_at, self.id).order("published_at DESC").last
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

  def populate_search_text
    self.search = slug ? "_#{slug}" : ""
    self.search << " #{title}"
    self.tags.each do |tag|
      self.search << " #{tag.name}"
    end
    self.search << " #{source_title}"
    self.search << " #{source_url}"
    self.search.downcase!
  end

end
