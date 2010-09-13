## stolen from http://www.ruby-forum.com/topic/193036
#
#
#
=begin

  post '/upload' do
    unless params[:file] &&
           (tmpfile = params[:file][:tempfile]) &&
           (name = params[:file][:filename])
      @error = "No file selected"
      return haml(:upload)
    end
    STDERR.puts "Uploading file, original name #{name.inspect}"
    while blk = tmpfile.read(65536)
      # here you would write it to its final location
      STDERR.puts blk.inspect
    end
    "Upload complete"
  end


  post '/upload' do
    unless params[:file] &&
           (tmpfile = params[:file][:tempfile]) &&
           (name = params[:file][:filename])
      @error = "No file selected"
      return haml(:upload)
    end
      directory = "public/files"
      path = File.join(directory, name)
      File.open(path, "wb") { |f| f.write(tmpfile.read) }
  end
=end
