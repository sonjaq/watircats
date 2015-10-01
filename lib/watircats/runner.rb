module WatirCats
  
  class Runner
    def initialize(task, sources)
      
      # Setup the directories for screenshots and comparison output

      # Using a case statement to determine how to operate.
      # case and when are not to be waste an indent level
      case task
      when :compare
        sources.each do |source|
          # If source is nil, go to the next one (which probably won't exist)
          next unless source 
          
          # Prep the URI object
          uri      = URI.parse(source)
          base_url = uri.host
          scheme   = uri.scheme || "http"

          # Grab a Mapper object to pass to Snapper
          site_map = WatirCats::Mapper.new( base_url, scheme )
          
          # Snapper will snap screenshots, using a site_map object
          WatirCats::Snapper.new( base_url, scheme, site_map )
        end

        folders        = WatirCats::Snapper.folders
        base_folder    = folders.first
        changed_folder = folders.last

        WatirCats::Comparer.new( base_folder, changed_folder )

      # Only take screenshots
      when :screenshots_only
        sources.each do |source|
          # If source is nil, go to the next one (which probably won't exist)
          next unless source 
          
          # Prep the URI object
          uri      = URI.parse(source)
          base_url = uri.host
          scheme   = uri.scheme

          # Grab a Mapper object to pass to Snapper
          site_map = WatirCats::Mapper.new( base_url, scheme )
          
          # Snapper will snap screenshots, using a site_map object
          WatirCats::Snapper.new( base_url, scheme, site_map )
        end

      # Let's just compare folders
      when :folders
        base_folder    = sources.first
        changed_folder = sources.last
        WatirCats::Comparer.new( base_folder, changed_folder )
      # End case
      end


    end
  end
end