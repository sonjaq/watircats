require 'thor'
require 'watircats'
require 'yaml'

# CLI for WatirCats. Options and commands for any of the available utilities
# available through the watircats executable

module WatirCats
  class CLI < Thor

    # Options that are common for comparison operations
    common_compare_options = {
      [:output_dir, '-o']             => "comparison",
      [:screenshot_dir, '-s']         => "screenshots",
      [:working_dir, '-w']            => :string,
      [:images_dir, '-i']             => :string,
      [:reporting_enabled, '-r']      => :boolean,
      [:csv_output]                   => :boolean,
      [:verbose, '-v']                => :boolean,
      [:strip_zero_differences, '-z'] => :boolean,
      [:config_file, '-c']            => :string,
      [:skip_existing, '-e']          => :boolean,
    }

    # Options that are common for screenshot operations
    common_screenshot_options = {
      [:browser, '-b']           => "firefox",
      [:widths]                  => :array, 
      [:limit, '-l']             => :numeric,
      [:url_list]                => :string,
      [:limit]                   => :string,
      [:custom_body_class_tests] => :string,
      [:proxy, '-p']             => :string,
      [:limited_path]            => :string,
      [:avoided_path]            => :string,
      [:ff_path]                 => :string
    }

    # Description for the next-to-be-defined 'compare' task
    desc 'compare [OPTIONS] http://SITE_A http://SITE_B', 'Compare Screenshots from two sites'
    
    # Add the options for comparison and screenshot operations to the next task
    method_options common_compare_options
    method_options common_screenshot_options

    def compare(*source_arguments)
      ensure_imagemagick

      # Configure options      
      handle_configuration( options )

      # Setting an exit status to track for altered screens
      @exit_status = 0 

      # Create an empty array of sources
      sources = []

      # Populate the sources array with each command line argument
      source_arguments.each { |s| sources << s }

      # Handle a working directory by calling the private method 'handle_working_dir'
      handle_working_dir
      
      # Run the comparison
      WatirCats::Runner.new( :compare, sources )

      # Handle the reporting functionality
      handle_reporting

      # Exit based on the exit status of the application
      exit @exit_status
    end

    desc 'folders FOLDER_A FOLDER_B', 'Compare two folders of screenshots'

    # Add the options for comparison operations
    method_options common_compare_options

    def folders(*source_arguments)     
      ensure_imagemagick

      handle_configuration( options )
      # Setting an exit status to track for altered screens
      @exit_status = 0 
      
      # Create an empty array of sources
      sources = [ ]

      # Populate the sources array with each command line argument
      source_arguments.each { |s| sources << s }

      # Handle a working directory
      handle_working_dir

      # Run the folders command
      WatirCats::Runner.new( :folders, sources )

      # Handle reporting
      handle_reporting

      exit @exit_status
    end

    desc 'screenshots SITE_A [SITE_B SITE_C ...]', 'Take Screenshots of any number of sites'
 
    method_options common_compare_options
    method_options common_screenshot_options

    def screenshots(*source_arguments)
      ensure_imagemagick

      handle_configuration( options )
      # Setting an exit status to track for altered screens
      @exit_status = 0 

      # Create an empty array of sources
      sources = [ ]

      # Populate the sources array with each command line argument
      source_arguments.each { |s| sources << s }

      # Handle a working directory
      handle_working_dir

      # Run the screenshots command
      WatirCats::Runner.new( :screenshots_only, sources )

      # Handle Reporting
      handle_reporting

      exit @exit_status
    end

    private

    def handle_working_dir
      # Handle a working directory
      working_dir = WatirCats.config.working_dir
      if working_dir
        unless File.directory? working_dir
          FileUtils.mkdir working_dir
        end
        Dir.chdir working_dir
      end
    end

    def handle_reporting
      # Handle standard reporting
      reporting = WatirCats.config.reporting_enabled

      if reporting
        data       = WatirCats::Comparer.the_results
        data.each { |e| @exit_status = 1 unless e[:result].match(/0/) }

        report = WatirCats::Reporter.new( data ).build_html
        File.open("#{WatirCats.config.output_dir}/index.html", 'w') do |f|
          f.write report
        end
      end

      # Handle custom reporting
      custom_tests = WatirCats.config.custom_body_class_tests

      if custom_tests
        results = WatirCats::Snapper.custom_test_results
        report  = WatirCats::Reporter.build_custom_results( results )

        File.open("#{WatirCats.config.output_dir}/custom_report.html", 'w') do |f|
          f.write report
        end
      end

    end

    def handle_configuration(options)
      # Parse the command line options. If a config file if specified, merge 
      # those values into the options hash as long as keys don't collide.
      # Command line options override the config file.
      
      cloned_options = options.dup
      if cloned_options[:config_file]
        config = YAML::load_file cloned_options[:config_file]
        config.each do |key,value|
          cloned_options[key.to_sym] = value 
        end
      end
      merged_opts = cloned_options.merge(options)
      WatirCats.configure merged_opts
    end

    def ensure_imagemagick
      # Ensure that Imagemagick's compare is installed
      begin
        `compare --version`
      rescue
        puts "Please ensure ImageMagick is in your system path to use WatirCats. \nPlease visit http://www.imagemagick.org."
        exit 
      end
    end
    
  end
end
