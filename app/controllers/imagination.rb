Frontend.controllers :imagination do
  get :index, :provides => [:any, :json] do
    @photos = Photo.all
    case content_type
    when :json then
      content_type 'application/json'
      @photos.to_json
    else
      render 'imagination/index', :layout => false
    end
  end

  get :tag, :with => [:tag], :provides => [:any, :json] do
    # @posts = Post.find_by_sql ("SELECT p.* FROM posts_tags pt, posts
    # p, tags t WHERE pt.tag_id = t.id AND (t.name = '" +
    # tags.uniq.join ('\' OR t.name=\'') + "') AND p.id=pt.post_id
    # GROUP BY p.id HAVING COUNT(p.id) = " + tags.uniq.length.to_s)

    # SELECT p.*
    # FROM photos_tags pt, photos p, tags t
    # WHERE pt.tag_id = t.id
    # AND (t.name IN ('bookmark', 'webservice', 'semweb'))
    # AND p.id = pt.photo_id
    # GROUP BY b.id
    # HAVING COUNT( b.id )=3

    @photos = Photo.select(
         :photos__id,
         :photos__name,
         :photos__file
       ).from(
         :public__photos,
         :public__tags,
         :public__photo_taggins
       ).where(
         :photo_taggins__tag_id => :tags__id,
         :tags__name => params[:tag],
         :photos__id => :photo_taggins__photo_id ).all
    
    
    # @photos = Photo.tagged_with params[:tag]
    case content_type
    when :js then
      content_type 'application/json'
      @photos.to_json
    else
      render 'imagination/index', :layout => false
    end
  end
end
