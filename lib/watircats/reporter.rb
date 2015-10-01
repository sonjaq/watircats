require "haml"

module WatirCats
  class Reporter
    # Handles the report generation

    def initialize(results_array)
      @data = results_array
    end

    def build_html
      # Create a report based off of the template data. 
      # binding gives Haml context, and @data dumps the relevant information in
      Haml::Engine.new(get_screenshot_template).render binding, :data => @data
    end

    def get_screenshot_template
      template = <<TEMPLATE
!!! 5
%html
  %head
    %title Comparison courtesy of WatirCats
    %script{:type => "text/javascript",
            :src => "https://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"}
    %script{:type => "text/javascript",
            :src => "https://cdnjs.cloudflare.com/ajax/libs/masonry/3.1.1/masonry.pkgd.min.js"}
    :css
      p { padding-left: 10px; }
      .item { width:140px;  font-family: sans-serif; font-size: 10px; }
      div.item { padding: 5px ;border: 2px; border-color: black; overflow: auto; box-shadow: inset 1px 1px 8px 1px gray; margin-top: 10px;}
      div.item:hover{ transition: .3s; box-shadow: 1px 1px 8px 1px slategray; adding: 8px; margin-left: -3px; margin-top: 6px; }
      img{ width: 50px; height: 100px; float: left}
    %script
      $(function(){$('#container').masonry({itemSelector : '.item',columnWidth : 160});});
  %body
    %div#container
      - data.each do |path| 
        %div{ :class => "item", :style => "background-color: " + path[:status_color]  }
          %a{ :href => path[:compared_shot] }
            - thumb = "thumbs/" + path[:compared_shot]
            %img{ :src => thumb, :alt => path[:compared_shot], :title => path[:compared_shot] }
          %p<
            %strong Pixels Changed: 
            = path[:result]
TEMPLATE
      template
    end

  end
end