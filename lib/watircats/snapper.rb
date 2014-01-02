require 'watir-webdriver'

module WatirCats
  class Snapper
    
    BROWSER_HEIGHT = 5000

    def initialize(base_url, site_map)
      @base_url       = base_url
      @screenshot_dir = WatirCats.config.screenshot_dir
      @widths         = WatirCats.config.widths
      
      # Handle the environments that require profile configuration
      configure_browser

      # Allowing for custom page class tests
      @class_tests          = [ ]
      @class_test_mapping   = { }
      @@custom_test_results = { }

      if WatirCats.config.custom_body_class_tests
        load WatirCats.config.custom_body_class_tests
        $custom_body_class_tests.each do |custom_test|
          # Store the custom class tests in the class_tests array
          # Map the class to the relevant method name
          
          body_class = custom_test[:body_class_name]
          @class_tests << body_class
          if @class_test_mapping[ body_class ] 
            @class_test_mapping[ body_class ] = @class_test_mapping[ body_class ] + [ custom_test[:method_name] ]
          else 
            @class_test_mapping[ body_class ] = [ custom_test[:method_name] ]
          end

          custom_code = "def #{custom_test[:method_name]}; #{custom_test[:custom_code]}; end"
          WatirCats::Snapper.class_eval custom_code
        end
      end

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
      @browser.goto url
      # Wait for page to complete loading by querying document.readyState
      script = "return document.readyState"
      @browser.wait_until { @browser.execute_script(script) == "complete" }
      
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
      FileUtils.mkdir "#{stamped_base_url_folder}" 
 
      add_folder(stamped_base_url_folder)

      # Some setup for processing
      paths = @paths
      widths = self.widths

      # Iterate through the paths, using the key as a label, value as a path
      paths.each do |label, path|
        # Create our base array to use to execute tests
        potential_body_classes = [:all]
        # Do custom tests here
        body_classes = @browser.body.class_name
        # Split the class string for the <body> element on spaces, then shovel
        # each body_class into the potential_body_classes array
        body_classes.split.each { |body_class| potential_body_classes << body_class }
        
        @@custom_test_results[path] = {}

        potential_body_classes.each do |the_class|
          if @class_tests.include? the_class
            methods_to_send = @class_test_mapping[the_class]

            methods_to_send.each do |custom_method|
              @@custom_test_results[path][custom_method] = self.send( custom_method )
            end
          
          end
        end

        # For each width, resize the browser, take a screenshot
        widths.each do |width|
          resize_browser width
          file_name = "#{stamped_base_url_folder}/#{label}_#{width}.png"
          capture_page_image("#{@base_url}#{path}", file_name)
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

    def self.custom_test_results
      @@custom_test_results ||= { }
    end

  end
end
