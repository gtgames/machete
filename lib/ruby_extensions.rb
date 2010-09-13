require 'rubygems'
require 'unidecode'

# my simple touch
def touch(f, t=Time.now)
  begin
    File.utime(t, t, f)
  rescue Errno::ENOENT
    File.open(f, 'a'){
      ;
    }
  end
end

# Array extensions
Array.class_eval do
  def arithmetic_mean
    inject(0) {|sum, n| sum + n} / length.to_f
  end

  def geometric_mean
    inject(1) {|product, n| product * n} ** (1.0 / length)
  end
end

# String extensions
String.class_eval do

  def to_slug
    self.to_ascii.downcase.gsub(/[^a-z0-9 ]/, ' ').strip.gsub(/[ ]+/, '-')
  end

  # differs from the 'to_slug' method in that it leaves in the dot '.' character and removes Windows' crust from paths (removes "C:\Temp\" from "C:\Temp\mieczyslaw.jpg")
  def sanitize_as_filename
    self.gsub(/^.*(\\|\/)/, '').to_ascii.downcase.gsub(/[^a-z0-9\. ]/, ' ').strip.gsub(/[ ]+/, '-')
  end
end
