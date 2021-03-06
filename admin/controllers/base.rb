#encoding: utf-8
Admin.controllers :base do
  enable :caching

  get :index, :map => "/" do
    render "admin/base/index"
  end

  get :tagblob, :provides => :js do
    content_type :json
    cache('tagblob', :expires_in => 15*60) do
      (Post.tagging | Photo.tagging | Event.tagging).to_json
    end
  end

  post :upload do
    puts "parms: "
    puts params
    puts ""
    # http://admin.machete.dev/base/upload?CKEditor=page_text(it)&CKEditorFuncNum=71&langCode=it
    file = MediaFile.new({
        :name => params["filename"],
        :content_type => Wand.wave(params['tempfile']),
        :path => params['tempfile']
    })
    if (params['CKEditor'])
      content_type :html

      if file.save
        "<script type=\"text/javascript\">
          window.parent.CKEDITOR.tools.callFunction(#{params['CKEditorFuncNum']},'#{file.url}', '');
        </script>"
      else
        "<script type=\"text/javascript\">
          window.parent.CKEDITOR.tools.callFunction(#{params['CKEditorFuncNum']},null, '#{file.errors.to_json}');
        </script>"
      end
    else
      content_type :json

      if file.save
        {success:file.id.to_s, data: ::File.basename(file.path), url:file.thumb(), _url: file.url}.to_json
      else
        {error:file.errors}.to_json
      end
    end
  end

  get :reboot do
    if current_account.role == "root"
      require 'fileutils'
      FileUtils.touch(Padrino.root('tmp', 'restart'))
      flash[:error] = 'touched $root/tmp/restart !!!'
      redirect '/'
    else
      redirect '/'
    end
  end

  get :reless do
    if current_account.role == "root"
      lambda {
        # compile less files in a fork
        puts 'Compiling less files'
        path = Padrino.root('public','stylesheets')
        Dir.glob(Padrino.root('public','stylesheets', '*.less')) {|f|
          f = f.sub(path, '').sub(/^\//, '')
          puts "compiling #{path} / #{f}" 
          `cd #{path} && lessc #{f} > #{f.sub(/less$/, 'css')}`
        }
      }.call()
    end
    flash[:error] = 'less files compiled!'
    redirect '/'
  end

  get :harakiri do
    redirect '/' unless current_account.role == "root"
    Process.kill(:SIGTERM, Process.getpgrp)
    redirect '/'
  end
end
