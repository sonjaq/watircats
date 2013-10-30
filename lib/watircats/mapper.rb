require "open-uri"
require "xmlsimple"

module WatirCats
  class Mapper

    def initialize(base_url, scheme, options)
      # Class variables that persist throughout the life of the application
      
      @limit = options[:limit] || nil

      @@master_paths = {}
      @@new_paths    = {}

      # Subtree is a way to limit screenshots based on a path. It gets placed into a regular expression.
      @subtree ||= nil
      if options[:subtree] == nil
        @subtree = nil
      else 
        @subtree = /#{options[:subtree]}/
      end

      @base_url = base_url
  
      # If the :url_list option is passed, it is assumed to be a file of urls,
      # one on each line. Otherwise, assume there is a sitemap
      if options[:url_list]
        begin
          urls = File.readlines options[:url_list]
          urls.each { |url| url.strip! }
        rescue Exception => msg
          print msg
          exit 1
        end
      else
        xml        = self.get_sitemap_as_xml(scheme, @base_url) 
        urls       = self.parse_sitemap_into_urls(xml)
      end

      @the_paths = self.paths(urls)
    end

    def get_sitemap_as_xml(scheme, base_url)

      if $open_uri_proxy
        proxy = scheme + "://" + $open_uri_proxy
      else
        proxy = nil
      end

      begin 
        sitemap_data = ::OpenURI.open_uri((scheme + "://" + base_url + "/sitemap.xml"), {:proxy => proxy})
        sitemap_xml  = ::XmlSimple.xml_in(sitemap_data)
      rescue Exception => msg
        print msg
        exit 1
      end
    end

    def parse_sitemap_into_urls(xml)
      # Empty Array to dump URLs into
      urls = []
      xml["url"].each do |key|
        urls << key["loc"].first
      end
      # Return the URLs
      urls
    end

    def paths(urls)

      # Determine if this is the first pass
      if @@master_paths.size == 0
        mode = :first_run
      else 
        mode = :not_first
      end

      # Create an empty hash to store paths in
      pending_paths = {}
      
      # Iterate through the urls, grab only the valid paths post domain
      # Store each path_key with the extrapolated path
      urls.each do |url|
        path = URI.parse(url).path

        if @subtree
          next unless path.match @subtree
        end

        path_key = path.tr("/","-")[1..-2] unless path == "/"
        path_key ||= "root" # Nil guard to set 'root' for home

        # If this is the first run, definitely process it
        # If not the first run, ensure path_key exists
        # If not the first run, path_key not present, put it in @@new_paths
        if mode == :first_run
          pending_paths[path_key] = path
        else
          if @@master_paths[path_key]
            pending_paths[path_key] = path
          else
            @@new_paths[path_key]   = path
          end
        end
      end
      
      # Store master paths if this is the first pass
      @@master_paths.merge! pending_paths if mode == :first_run
      # return the paths to crawl
      pending_paths
    end

    def the_paths
      # TODO: Insert logic to limit to a specific subtree here
      
      # Return the paths if there is a @limit
      return @the_paths.first(@limit.to_i) if @limit
      @the_paths.first(@the_paths.length)
    end

    def master_paths
      # Enforce limit on @@master_paths, too, because why not
      return @@master_paths.first(@limit.to_i) if @limit
      @@master_paths.first(@@master_paths.length)
    end

    def new_paths
      @@new_paths.first(@@new_paths.length)
    end
  end
end