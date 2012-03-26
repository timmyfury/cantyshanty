desc "Update all the colors for images"
task :get_colors => :environment do

  @posts = Post.published
  @posts.each do |post|
    post.save
    puts "#{post.title}: #{post.rgb}, #{post.hsl}, #{post.hex}"
  end

end

desc "Test pixelation of an image"
task :pixelate => :environment do

  source = "#{Rails.root}/app/assets/images/medium.jpg"
  target = "#{Rails.root}/app/assets/images/medium-pixelated.jpg"
  converted = "#{Rails.root}/app/assets/images/medium-colors.jpg"

  output = "#{Rails.root}/app/assets/images/colors.txt"

  # command = "convert #{source} -scale 1x1\! -format '%[pixel:u]' info:-"
  pixelate_command = "convert #{source} -colors 256 -scale 10% -scale 1000% #{target}"

  # convert image.jpg -blur 18,5 newimage.jpg
  # 
  # convert -resize 10% image.jpg newimage.jpg
  # convert -resize 1000% newimage.jpg newimage.jpg
  # 
  # convert -scale 10% -scale 1000% original.jpg pixelated.jpg

  pixelated = %x[#{pixelate_command}]
  
  # colors_command = "convert #{target} -format '%[pixel:u]' info:-"
  colors_command = "convert #{source} -colors 256 histogram:- | identify -depth 8 -format %c -"

  # convert_command = "convert #{source} -unique-colors #{converted}"
  # colors_command = "convert #{source} -unique-colors -depth 8  txt:-"
  # colors_command = "convert #{target} -format %c -depth 8  histogram:info:-"
  # colors_command = "convert #{target} -unique-colors -depth 16  txt:-"
  
  # converts = %x[#{convert_command}]
  colors = %x[#{colors_command}]

  # puts colors
  
  File.open(output, 'w') {|f| f.write(colors) }

end

