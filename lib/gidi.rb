require "gd2-ffij"

module Gidi
  attr_accessor :image

  def self.render(f)
    @image = GD2::Image.load(f)
  end
  class Engine
    def self.initialize
      @image = GD2::Image.load(f)
    end
    def resize(w, h, crop=false)
      new_size = { w: @image.width,
                   h: @image.height }
      #
    end
    def size
      { w: @image.width,
        h: @image.height }
    end
    def save(f)
      @image.export(f)
    end
  end
end
