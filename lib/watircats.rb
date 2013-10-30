# Put requires here

# External requires
require "open-uri"
require "xmlsimple"
require "openssl"
require "watir-webdriver"

# Internal Requires
require "watircats/comparer"
require "watircats/mapper"
require "watircats/reporter"
require "watircats/snapper"
require "watircats/version"
require "watircats/runner"
require "watircats/cli"

# Platform configuration, for Jenkins use
# Need to move this to a config file
if RUBY_PLATFORM == "x86_64-linux"
  
  $open_uri_proxy = "outbound.pozitronic.com:3128"
  Selenium::WebDriver::Firefox::Binary.path="/usr/bin/firefox_esr"

  $profile = Selenium::WebDriver::Firefox::Profile.new
  $profile.proxy = Selenium::WebDriver::Proxy.new :http => 'outbound.pozitronic.com:3128', :ssl => 'outbound.pozitronic.com:3128'
  $profile['app.update.auto'] = false
  $profile['app.update.enabled'] = false
end

# Possibly not necessary?
module WatirCats

end
