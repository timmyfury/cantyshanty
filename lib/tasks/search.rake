desc "Update search field for all posts"
task :update_search => :environment do

  @posts = Post.all
  @posts.each do |post|
    post.save
    puts "Updated search text for #{post.title}."
  end

end