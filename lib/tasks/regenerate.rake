desc "Reprocess images"
task :reprocess_images => :environment do

  @posts = Post.missing_meta.recent
  @post_count = @posts.count
  @current_post = 1

  @posts.each do |post|
    post.image.reprocess!
    puts "Reprocessed #{@current_post} of #{@post_count}: #{post.title}"
    @current_post += 1
  end

end