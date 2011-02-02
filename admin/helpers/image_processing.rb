Admin.helpers do
  def crop_image(file, width, height, x, y)
    begin
      MiniMagick.processor = :gm
      image = MiniMagick::Image.new(file)
      image.crop "#{width}x#{height}+#{x}+#{y}"
      return true
    rescue
      logger.error "An error occurred in MiniMagick: #{$!}"
      return false
    end
  end

  def resize_image(file, width, height)
    begin
      MiniMagick.processor = :gm
      image = MiniMagick::Image.new(file)
      image.resize "#{width}x#{height}"
      return true
    rescue
      logger.error "An error occurred in MiniMagick: #{$!}"
      return false
    end
  end
end