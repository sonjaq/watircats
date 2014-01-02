module WatirCats
  
  @@config = nil

  # Create a new Config object to store our settings
  def self.configure( options_hash )
    # Only allows for one time creation of the config
    if @@config.is_a? Config
      update_config( options_hash )
    else
      @@config = Config.new( options_hash )
    end
    # Return the @@config for chaining
    @@config
  end

  # This allows us to get the config setting from anywhere within WatirCats
  # by using WatirCats.config.setting_name
  def self.config
    # Return the @@config class var to allow chaining for values
    @@config
  end

  def self.update_config( options_hash )
    # Instantiate a new Config unless @@config already is a Config object
    @@config = Config.new({ }) unless @@config.is_a? Config
    options_hash.each do |key, value| 
      @@config.new_key( key, value )
    end
  end

  # Create a configuration object
  class Config

    def initialize( options_hash )
      # Iterate through the options hash, setting each key as an instance
      # variable, and creating a getter method with the same name
      options_hash.each do |key, value|
        new_key(key, value)
      end
    end

    def new_key(key, value)
      # define getter
      instance_eval( "def #{key}; @#{key}; end" ) unless self.respond_to? "#{key}"
      # define setter
      instance_eval( "def #{key}= (v); @#{key} = v; end" ) unless self.respond_to? "#{key}="
      # Set the value on the instance variable, creating if necessary
      instance_variable_set( "@#{key}".to_sym, value )
    end

    def method_missing( meth, *args, &blk )
      # Return nil if an expected parameter isn't here. No need to die.
      nil
    end

  end
end