xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Canty Shanty"
    xml.description "This could be my house"
    # xml.link formatted_articles_url(:rss)
    
    for post in @posts
      xml.item do
        xml.title post.title
        xml.description render(:inline => "<%= image_tag post.image.url(:large), :alt => post.title %> <%= image_tag beacon_url(:slug => post.slug) %>", :locals => { :post => post })
        xml.pubDate post.created_at.to_s(:rfc822)
        xml.link short_url(:slug => post.slug)
        xml.guid short_url(:slug => post.slug)
      end
    end
  end
end