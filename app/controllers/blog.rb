Machete.controllers :blog do
  get :index do
    @posts = Post.sort(:_id.desc)
    etag @post.first.id.generation_time.to_i
    render 'blog/index', :layout => Cfg.layout('blog')
  end

  get :show, :map => '/blog/:slug' do
    if (@post = Post.where({:slug => params[:slug]}).first)
      etag @post.id.generation_time.to_i
      render 'blog/show', :layout => Cfg.layout('blog')
    else
      404
    end
  end
end
