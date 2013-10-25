module WatirCats
  
  class Runner
    def initialize(task, parameter_hash)
      
      @options = parameter_hash

      # Setup the sources to send to mapper, snapper, and comparer
      sources = parameter_hash[:sources]

      # Setup the directories for screenshots and comparison output
      screenshot_dir = parameter_hash[:screenshot_dir]
      output_dir     = parameter_hash[:output_dir]

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
          site_map = WatirCats::Mapper.new(base_url, scheme, @options)
          
          # Snapper will snap screenshots, using a site_map object
          WatirCats::Snapper.new(base_url, site_map, screenshot_dir)
        end

        folders        = WatirCats::Snapper.folders
        base_folder    = folders.first
        changed_folder = folders.last
        strip_status   = parameter_hash[:strip_zero]

        WatirCats::Comparer.new(base_folder, changed_folder, output_dir, strip_status)

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
          site_map = WatirCats::Mapper.new(base_url, scheme, @options)
          
          # Snapper will snap screenshots, using a site_map object
          WatirCats::Snapper.new(base_url, site_map, screenshot_dir)
        end

      # Let's just compare folders
      when :folders
        base_folder    = sources.first
        changed_folder = sources.last
        WatirCats::Comparer.new(base_folder, changed_folder, output_dir, parameter_hash[:strip_zero])
      end


    end
  end
end