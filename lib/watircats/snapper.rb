require 'watir-webdriver'

module WatirCats
  class Snapper
    
    BROWSER_HEIGHT = 5000

    def initialize(base_url, scheme, site_map)
      puts "Snapper host: #{base_url}"
      @base_url       = base_url # (actually just the HOSTNAME)
      @scheme         = scheme
      @screenshot_dir = WatirCats.config.screenshot_dir
      @widths         = WatirCats.config.widths
      @images_dir     = WatirCats.config.images_dir
      @delay          = WatirCats.config.delay
      # Handle the environments that require profile configuration
      configure_browser

      # Allowing for custom page class tests
      @class_tests          = [ ]
      @class_test_mapping   = { }

      # Retrieve the paths from the sitemap
      @paths      = site_map.the_paths
      @time_stamp = Time.now.to_i.to_s

      process_paths
      @browser.quit
    end

    def resize_browser(width)
      # Set a max height using the constant BROWSER_HEIGHT
      @browser.window.resize_to(width, BROWSER_HEIGHT)
    end

    def capture_page_image(url, file_name)
      
      # skip existing screenshots if we've specified that option
      if WatirCats.config.skip_existing
        if FileTest.exists?(file_name)
         puts "Skipping existing file at " + file_name # verbose
         return
        end
      end

      print "goto: #{url}" # verbose info, and suppressing linefeed
      begin
        @browser.goto url
        # Wait for page to complete loading by querying document.readyState
        script = "return document.readyState"
        @browser.wait_until { @browser.execute_script(script) == "complete" }
      rescue => e
        puts "\n  [ERROR] Tried goto & wait_until, but: #{e}"
        # NB @browser.status might be handy here, but it crashes Firefox
        # Relaunch and carry on
        @browser.close
        configure_browser
        return
      end
      
      if @browser.url != url
        # @todo detect offsite redirect, if host is different?
        puts "\n  redirected to: #{@browser.url}" # verbose
      else
        puts " - OK" # verbose info
      end

      # Skip screenshot if we got redirected to a path we should avoid
      if WatirCats.config.avoided_path
        if @browser.url.match( /#{WatirCats.config.avoided_path}/ )
          puts "  skipped, redirect url matches: /#{WatirCats.config.avoided_path}/" # verbose
          return
        end
      end

      # quick and dirty page delay for issue #1
      if @delay
        @browser.wait_until { sleep(@delay) }
      end

      # Take and save the screenshot      
      @browser.screenshot.save(file_name)
    end

    def widths
      @widths = @widths || [1024]
    end

    def self.folders
      # Class variable, to keep track of folders amongst all instances of this class
      @@folders ||= []
    end

    def add_folder(folder)
      @@folders ||= [] # Ensure @@folders exists
      @@folders << folder
    end

    def process_paths
      # Build the unique directory unless it exists
      FileUtils.mkdir "#{@screenshot_dir}" unless File.directory? "#{@screenshot_dir}"

      stamped_base_url_folder = "#{@screenshot_dir}/#{@base_url}-#{@time_stamp}"
      if @images_dir
          stamped_base_url_folder = "#{@screenshot_dir}/#{@images_dir}"
      end
	
      FileUtils.mkdir "#{stamped_base_url_folder}" unless File.directory? "#{stamped_base_url_folder}"
 
      add_folder(stamped_base_url_folder)

      # Some setup for processing
      paths = @paths
      widths = self.widths

      # Iterate through the paths, using the key as a label, value as a path
      paths.each do |label, path|
        # Skip if this path should be avoided
        if WatirCats.config.avoided_path
          if path.match( /#{WatirCats.config.avoided_path}/ )
            puts "skipping avoided path (in process_paths): #{path}" # verbose
            next
          end
        end
        # For each width, resize the browser, take a screenshot
        widths.each do |width|
          resize_browser width
          file_name = "#{stamped_base_url_folder}/#{label}_#{width}.png"
          capture_page_image("#{@scheme}://#{@base_url}#{path}", file_name)
        end
      end
    end

    def configure_browser
      engine = WatirCats.config.browser || :ff

      # Firefox only stuff, allowing a custom binary location and proxy support
      if ( engine.to_sym == :ff || engine.to_sym == :firefox )

        bin_path = WatirCats.config.ff_path
        proxy    = WatirCats.config.proxy
        ::Selenium::WebDriver::Firefox::Binary.path= bin_path if bin_path.is_a? String
        
        profile = ::Selenium::WebDriver::Firefox::Profile.new 
        
        if proxy
          profile.proxy = ::Selenium::WebDriver::Proxy.new :http => proxy, :ssl => proxy
        end

        profile['app.update.auto']    = false
        profile['app.update.enabled'] = false

        @browser = ::Watir::Browser.new engine, :profile => profile
      else
        @browser = ::Watir::Browser.new engine
      end
    end

  end
end
