# Title: Soundcloud embedding for Jekyll
# Authors: Brett Mack http://blog.foxienet.com
# Description: Easily embed tracks from soundcloud using an iframe with optional width and height attributes
#
# Syntax {% soundcloud url [width [height]] %}
#
# Examples:
# {% soundcloud http://api.soundcloud.com/tracks/88882716 %}
# {% soundcloud http://api.soundcloud.com/tracks/88882716 50% 100 %}
#
# Output:
# <iframe width="100%" height="166" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=http%3A%2F%2Fapi.soundcloud.com%2Ftracks%2F88882716"></iframe>
# <iframe width="50%" height="100" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=http%3A%2F%2Fapi.soundcloud.com%2Ftracks%2F88882716"></iframe>
#

require 'uri'

module Jekyll

  class SoundcloudTag < Liquid::Tag
    @soundcloud = nil

    def initialize(tag_name, markup, tokens)
      attributes = ['src', 'width', 'height']

      if markup =~ /(?<src>https?:\S+)(?:\s+(?<width>\d+%?)(?:\s+(?<height>\d+))?)?/i
        tag_data = attributes.reduce({}) { |sc, attr| sc[attr] = $~[attr].strip if $~[attr]; sc }
        @soundcloud = { 
          "scrolling" => "no", 
          "frameborder" => "no",
          "width" => "100%",
          "height" => "166" 
        } 
        url = URI.escape(tag_data['src'])
        tag_data['src'] = "https://w.soundcloud.com/player/?url=#{url}"
        @soundcloud.merge!(tag_data)
      end
      super
    end

    def render(context)
      if @soundcloud
        "<iframe #{@soundcloud.collect {|k,v| "#{k}=\"#{v}\"" if v}.join(" ")}></iframe>"
      else
        "Error processing input, expected syntax: {% soundcloud url [width [height]] %}"
      end
    end
  end
end

Liquid::Template.register_tag('soundcloud', Jekyll::SoundcloudTag)
