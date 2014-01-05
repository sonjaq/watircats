module WatirCats
  class Comparer 

    NO_CHANGE = "Snow"
    ERROR     = "Crimson"
    CHANGE    = "Khaki"


    def initialize(source_a, source_b)
      # Get the directories in screenshots
      # @dirs = self.get_directories_to_compare
      @@results    = []
      @@strip_zero = WatirCats.config.strip_zero_differences || nil
     
      @comparison_dir = WatirCats.config.output_dir.chomp("/")
      # Get the last two directories that were created
      
      previous_shots_folder = source_a.chomp("/")
      latest_shots_folder   = source_b.chomp("/")

      # Cleanup the comparison folder
      reset_comparison_folder

      # Compare the directories
      compare_directories(latest_shots_folder, previous_shots_folder)
      
    end
   
    def reset_comparison_folder
      if File.directory? @comparison_dir
        dir_contents = Dir.glob("#{@comparison_dir}/*_compared.png")
        if dir_contents.size > 0
          dir_contents.each do |shot|
            FileUtils.rm(shot)  
          end
        end
      else
        FileUtils.mkdir_p(@comparison_dir)
      end
    end

    def compare_directories(latest, previous)
      # Grab the list of screenshots
      old_shots = Dir.glob(previous + "/*.png")

      old_shots.each do |old_shot|
        new_shot = old_shot.gsub(previous, latest)
      
        next unless File.exists? new_shot
        # Set a file prefix for output and info
        base_name     = old_shot.split("/").last.split(".").first
        output_file   = base_name + "_compared.png"

        comparison = compare_images(new_shot, old_shot, output_file)
        status = NO_CHANGE
        if comparison.match(/error/)
          status = ERROR
        elsif comparison.match(/^[1-9]/)
          status = CHANGE
        end
        @@results << { :compared_shot => output_file, 
                       :result => comparison, :status_color => status }

        # Remove the file if there is no change to be concerned with
        if @@strip_zero == true 
          begin 
            FileUtils.rm "#{@comparison_dir}/#{output_file}" if status == NO_CHANGE
          rescue Exception => msg
            print msg
            print "\n"
          end
        end

      end
      # Run the generate thumbs
      generate_thumbs if WatirCats.config.reporting_enabled
    end
    
    def generate_thumbs  
    
      unless Comparer.results.size < 1
        unless File.directory? "#{@comparison_dir}/thumbs"
          FileUtils.mkdir "#{@comparison_dir}/thumbs"
        end

        current_path = FileUtils.pwd
        FileUtils.chdir "#{@comparison_dir}"
        thumbs = `mogrify -format png -path thumbs -thumbnail 50x100 *.png`
        FileUtils.chdir "#{current_path}"
      end
    end


    def compare_images(latest_grab, previous_grab, output_file)
      data = `compare -fuzz 20% -metric AE -highlight-color blue #{previous_grab} #{latest_grab} #{@comparison_dir}/#{output_file} 2>&1`.chomp
      # Handle logging
      return data if ( @@strip_zero == true && data.match(/^0/) )
      csv = WatirCats.config.csv
      verbose = WatirCats.config.verbose
      print "#{output_file}" if ( csv || verbose )
      print ",#{data}" if csv
      print "\n" if ( csv || verbose )
      # Return data
      data
    end

    def self.results
      sorted = @@results.sort_by { |k| k[:status] }
      if @@strip_zero == true
        return sorted.reject { |capture| true if capture[:result] == "0" }
      else
        return sorted
      end
    end

  end
end