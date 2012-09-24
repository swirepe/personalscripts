#!/usr/bin/env ruby
require 'net/http'
require 'uri'

# http://programthis.net/a-colorful-challenge/

COLOR_SOURCE_VALUES = 256
COLOR_TARGET_VALUES = 5
COLOR_DIVIDE = COLOR_SOURCE_VALUES / COLOR_TARGET_VALUES
TERM_COLOR_BASE = 16
 
def rgb_to_xterm(r, g, b) # part of grosser.it/2011/09/16/ruby-converting-html-colors-24bit-to-xtermterminal-colors/
   r = (r / COLOR_DIVIDE) * 36
   g = (g / COLOR_DIVIDE) * 6
   b = (b / COLOR_DIVIDE) * 1
     
   TERM_COLOR_BASE + r + g + b
end
 
country = ARGV[0] || 'USA'
page_uri = URI.parse("http:\//en.wikipedia.org/wiki/File:Flag_of_#{country}.svg")
 
page_body = Net::HTTP.get_response(page_uri).body
png_src = page_body.match(/fullImageLink.+ src="([^"]+)"/)[1]
 
IO.popen("wget -q -O - http:#{png_src} | convert png:- -resize 80x -resize x55% rgb:-") {|io|
   while data = io.read(80*3)
        row = data.unpack('C*').each_slice(3).to_a
        row.map! {|rgb| "\e[48;5;#{rgb_to_xterm(*rgb)}m " }
        puts row.join + "\e[0m"
   end
}
