require 'rubygems'
require 'unidecode'

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
  # console colors
  def red; colorize(self, "\e[1m\e[31m"); end
  def green; colorize(self, "\e[1m\e[32m"); end
  def dark_green; colorize(self, "\e[32m"); end
  def yellow; colorize(self, "\e[1m\e[33m"); end
  def blue; colorize(self, "\e[1m\e[34m"); end
  def dark_blue; colorize(self, "\e[34m"); end
  def purple; colorize(self, "\e[1m\e[35m"); end
  def colorize(text, color_code); "#{color_code}#{text}\e[0m"; end
  # end lovely console colors

  def to_slug
    self.to_ascii.downcase.gsub(/[^a-z0-9 ]/, ' ').strip.gsub(/[ ]+/, '-')
  end

  # differs from the 'to_slug' method in that it leaves in the dot '.' character and removes Windows' crust from paths (removes "C:\Temp\" from "C:\Temp\mieczyslaw.jpg")
  def sanitize_as_filename
    self.gsub(/^.*(\\|\/)/, '').to_ascii.downcase.gsub(/[^a-z0-9\. ]/, ' ').strip.gsub(/[ ]+/, '-')
  end
end
