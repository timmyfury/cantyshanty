desc "upload a bunch of images"
task :upload => :environment do

  Dir["#{Rails.root}/public/_i/*"].each do |file|

    puts file
    
    if File.file?(file)
      Post.create(image: File.open("#{file}"))
    end

  end


end