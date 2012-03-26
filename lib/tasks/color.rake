desc "Update search field for all posts"
task :get_colors => :environment do

  @posts = Post.published
  @posts.each do |post|
    post.save
    puts "#{post.title}: #{post.rgb}, #{post.hsl}, #{post.hex}"
  end

end