require 'watir-webdriver'

module WatirCats
  class Snapper

    BROWSER_HEIGHT = 5000

    def initialize(base_url, site_map, screenshot_dir)
      @base_url       = base_url
      @screenshot_dir = screenshot_dir
      
      # Handle the Jenkins environment
      if $profile != nil
        @browser = ::Watir::Browser.new :ff, :profile => $profile
      else
        @browser = ::Watir::Browser.new :ff
      end

      # Allowing for custom page class tests
      @class_tests         = []
      @class_test_mapping  = {}
      @@custom_test_results = {}

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

      # Retrieve the paths from the sitemap
      @paths      = site_map.the_paths
      @time_stamp = Time.now.to_i.to_s
      
      self.process_paths
      @browser.quit
    end

    def resize_browser(width)
      # Set a max height using the constant BROWSER_HEIGHT
      @browser.window.resize_to(width, BROWSER_HEIGHT)
    end

    def capture_page_image(url, file_name)
      @browser.goto url
      # Wait for page to complete loading 
      # TODO: Remove CW-references
      
      begin
        @browser.execute_script( "CWjQuery(window).load(function(){return true});" )
      rescue
        # Just move on
      end

      @browser.screenshot.save(file_name)
    end

    def widths
      unless ENV['WIDTHS']
        @widths = [1024]
        return @widths
      end
      @widths = ENV['WIDTHS'].split(",").map { |w| w.to_i }
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
 
      self.add_folder(stamped_base_url_folder)

      # Some setup for processing
      paths = @paths
      widths = self.widths

      # Iterate through the paths, using the key as a label, value as a path
      paths.each do |label, path|
        # Do custom tests here
        body_class = @browser.body.class_name
        @@custom_test_results[path] = {}

        [:all, body_class].each do |the_class|
          if @class_tests.include? the_class
            methods_to_send = @class_test_mapping[the_class]

            methods_to_send.each do |custom_method|
              @@custom_test_results[path][custom_method] = self.send( custom_method )
            end
          
          end
        end

        # For each width, resize the browser, take a screenshot
        widths.each do |width|
          self.resize_browser width
          file_name = "#{stamped_base_url_folder}/#{label}_#{width}.png"
          self.capture_page_image("#{@base_url}#{path}", file_name)
        end
      end
    end

    def self.custom_test_results
      @@custom_test_results ||= {}
    end

  end
end
