# frozen_string_literal: true

require 'mini_magick'

image = MiniMagick::Image.open('./images/jacket-man.jpg')
# image.resize '640X480'
pixel_table = image.get_pixels

def deg2rad(d)
  d * Math::PI / 180
end

def rad2deg(r)
  r * 180 / Math::PI
end

# Return the Cyclic Average Mean.
def mean_angle(deg)
  rad2deg((deg.inject(0) { |z, d| z + Complex.polar(1, deg2rad(d)) } / deg.length).arg)
end

# Return Hue of a Pixel
def get_hue(red, green, blue, min, max)
  delta = max - min
  # If max == min, then hue = 0
  return 0 if delta.zero?

  # If Red is max, then Hue = (G-B)/(max-min)
  if max == red
    hue = (green - blue) / delta
    # If Green is max, then Hue = 2.0 + (B-R)/(max-min)
  elsif max == green
    hue = 2.0 + (blue - red) / delta
    # If Blue is max, then Hue = 4.0 + (R-G)/(max-min)
  elsif max == blue
    hue = 4.0 + (red - green) / delta
  end
  hue *= 60
  hue += 360 if hue.negative?
  hue.round
end

# Return the list of Hue values
def get_hue_values(pixel_table)
  hue_array = []
  pixel_table.each do |pixel_row|
    pixel_row.each do |pixel|
      red = (pixel[0].to_f / 255)
      green = (pixel[1].to_f / 255)
      blue = (pixel[2].to_f / 255)
      max = [red, green, blue].max
      min = [red, green, blue].min
      hue = get_hue(red, green, blue, min, max)
      hue_array << hue
    end
  end
  hue_array
end

hue_values = get_hue_values(pixel_table)

average_hue = mean_angle(hue_values).round

puts average_hue
