require 'thor'

class CLI < Thor

    common_compare_options = {
      [:output_dir, '-o']        => :string,
      [:screenshot_dir, '-s']    => :string,
      [:working_dir, '-w']       => :string,
      [:reporting_enabled, '-r'] => :boolean,
      [:csv_output]              => :boolean,
      [:verbose, '-v']           => :boolean,
      [:browser, '-b']           => :string,
      [:widths]                  => [1024]
    }

        common_screenshot_options = {
      [:browser, '-b']    => :string,
      [:widths]           => [1024], 
      [:limit, '-l']      => :numeric,
      [:url_file]         => :string,
      [:limited_url_path] => :string
    }
  desc "testing the thing", "thing"
  method_option :tmp, :type => :array  
  
  method_options common_compare_options
  def commander(*args)
    
    options.each { |o| puts o.inspect }
    hello
  end

  desc "two","two"
  method_options common_compare_options
  method_options common_screenshot_options

  def commander_two(*args)
    options.each { |o| puts o.inspect }
  end

  private

  def hello
    puts "hello"
  end

end

CLI.start ARGV
