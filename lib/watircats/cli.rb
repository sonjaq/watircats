require 'thor'
require 'watircats'

module WatirCats
  class CLI < Thor

    desc "compare SITE_A SITE_B", "Compare Screenshots from two sites"
    method_option :output_dir, :aliases => "-o", :desc =>  "Specify the output directory for comparison images", :default => "comparison"
    method_option :screenshot_dir, :aliases => "-s", :desc => "Specify the directory to save original screenshots", :default => "screenshots"
    method_option :working_dir, :aliases => "-w", :type => :string, :desc => "Set a working directory"
   
    method_option :custom_tests, :type => :string, :desc => "Supply the path to a local file that contains contents in a $custom_body_class_tests in a specific format"
    method_option :url_list, :type => :string, :desc => "Use a list of URLs instead of crawling the sitemap. This must be a file, with one URL per line."
   
    method_option :limit, :type => :numeric, :desc => "Limit the number of pages that will be crawled", :default => nil
    method_option :subtree, :type => :string, :desc => "Specify a string or regex that paths must match"
    method_option :reporting, :type => :boolean, :desc => "Generate an HTML report" 
    method_option :strip_zero, :aliases => "-z", :type => :boolean, :desc => "Remove 0 pixel change listings from the results", :default => false
    method_option :csv, :type => :boolean, :desc => "Outputs the verbose content, along with the number of pixels that changed in CSV style", :default => false
    method_option :verbose, :type => :boolean, :desc => "Output results to STDOUT for comparison only", :default => false
   
    def compare(*source_arguments)
      parameters = {}
      # Setting an exit status to track for altered screens
      @exit_status = 0 

      sources = []
      source_arguments.each { |s| sources << s }

      parameters[:limit]          = options[:limit] unless options[:limit] == 0
      parameters[:output_dir]     = options[:output_dir]
      parameters[:screenshot_dir] = options[:screenshot_dir]
      parameters[:sources]        = sources
      parameters[:subtree]        = options[:subtree]
      parameters[:strip_zero]     = options[:strip_zero]
      parameters[:url_list]       = options[:url_list]

      # Handle a working directory
      if options[:working_dir]
        if File.directory? options[:working_dir]
          Dir.chdir options[:working_dir]
        else
          FileUtils.mkdir options[:working_dir]
          Dir.chdir options[:working_dir]
        end
      end

      # Additional output options (globals feel hacky)
      $verbose = options[:verbose]
      $csv     = options[:csv]

      # Run the custom_tests file to load the array there.
      if options[:custom_tests]
        load options[:custom_tests]
      else
        $custom_body_class_tests = []
      end
      

      WatirCats::Runner.new(:compare, parameters)

      if options[:reporting]
        
        data   = WatirCats::Comparer.results
        data.each { |e| @exit_status = 1 unless e[:result].match(/0/) }

        report = WatirCats::Reporter.new(data).build_html
        File.open("#{options[:output_dir]}/index.html", "w") do |f|
          f.write report
        end
      end

      if options[:custom_tests]
        results = WatirCats::Snapper.custom_test_results

        report = WatirCats::Reporter.build_custom_results(results)

        unless File.directory? options[:output_dir]
          FileUtils.mkdir options[:output_dir]
        end

        File.open("#{options[:output_dir]}/custom_report.html", "w") do |f|
          f.write report
        end
      end

      exit @exit_status
    end

    desc "folders FOLDER_A FOLDER_B", "Compare two folders of screenshots"
    method_option :output_dir, :aliases => "-o", :desc =>  "Specify the output directory for comparison images", :default => "comparison"
    method_option :screenshot_dir, :aliases => "-s", :desc => "Specify the directory to save original screenshots", :default => "screenshots"
    method_option :working_dir, :aliases => "-w", :type => :string, :desc => "Set a working directory"
    method_option :reporting, :type => :boolean, :desc => "Generate an HTML report" 
    method_option :strip_zero, :aliases => "-z", :type => :boolean, :desc => "Remove 0 pixel change listings from the results", :default => false
    method_option :csv, :type => :boolean, :desc => "Outputs the verbose content, along with the number of pixels that changed in CSV style", :default => false
    method_option :verbose, :type => :boolean, :desc => "Output results to STDOUT for comparison only", :default => false
    
    def folders(*source_arguments)
      parameters = {}
      # Setting an exit status to track for altered screens
      @exit_status = 0 

      sources = []
      source_arguments.each { |s| sources << s }

      parameters[:output_dir]     = options[:output_dir]
      parameters[:screenshot_dir] = options[:screenshot_dir]
      parameters[:sources]        = sources
      parameters[:strip_zero]     = options[:strip_zero]

      # Handle a working directory
      if options[:working_dir]
        if File.directory? options[:working_dir]
          Dir.chdir options[:working_dir]
        else
          FileUtils.mkdir options[:working_dir]
          Dir.chdir options[:working_dir]
        end
      end

      # Additional output options (globals feel hacky)
      $verbose = options[:verbose]
      $csv     = options[:csv]

      WatirCats::Runner.new(:folders, parameters)

      exit @exit_status
    end




    desc "screenshots SITE_A [SITE_B SITE_C ...]", "Take Screenshots of any number of sites"
    method_option :output_dir, :aliases => "-o", :desc =>  "Specify the output directory for comparison images", :default => "comparison"
    method_option :screenshot_dir, :aliases => "-s", :desc => "Specify the directory to save original screenshots", :default => "screenshots"
    method_option :working_dir, :aliases => "-w", :type => :string, :desc => "Set a working directory"
    
    method_option :custom_tests, :type => :string, :desc => "Supply the path to a local file that contains contents in a $custom_body_class_tests in a specific format"
    method_option :url_list, :type => :string, :desc => "Use a list of URLs instead of crawling the sitemap. This must be a file, with one URL per line."
    
    method_option :limit, :type => :numeric, :desc => "Limit the number of pages that will be crawled", :default => nil
    method_option :subtree, :type => :string, :desc => "Specify a string or regex that paths must match"
    
    def screenshots(*source_arguments)
      parameters = {}
      # Setting an exit status to track for altered screens
      @exit_status = 0 

      sources = []
      source_arguments.each { |s| sources << s }

      parameters[:limit]          = options[:limit] unless options[:limit] == 0
      parameters[:output_dir]     = options[:output_dir]
      parameters[:screenshot_dir] = options[:screenshot_dir]
      parameters[:sources]        = sources
      parameters[:subtree]        = options[:subtree]
      parameters[:strip_zero]     = options[:strip_zero]
      parameters[:url_list]       = options[:url_list]

      # Handle a working directory
      if options[:working_dir]
        if File.directory? options[:working_dir]
          Dir.chdir options[:working_dir]
        else
          FileUtils.mkdir options[:working_dir]
          Dir.chdir options[:working_dir]
        end
      end

      # Run the custom_tests file to load the array there.
      if options[:custom_tests]
        load options[:custom_tests]
      else
        $custom_body_class_tests = []
      end
      

      WatirCats::Runner.new(:screenshots_only, parameters)

      if options[:custom_tests]
        results = WatirCats::Snapper.custom_test_results

        report = WatirCats::Reporter.build_custom_results(results)

        unless File.directory? options[:output_dir]
          FileUtils.mkdir options[:output_dir]
        end

        File.open("#{options[:output_dir]}/custom_report.html", "w") do |f|
          f.write report
        end
      end

      exit @exit_status
    end
    
    # method_option :screenshots_only, :type => :boolean, :desc => "Only take screenshots"
    #default_task :help
  end
end
