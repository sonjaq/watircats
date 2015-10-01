require 'watircats'
require 'minitest/mock'

class SnapperTest < Minitest::Test
  def setup
    @base_url                = "www.clockwork.net"
    @sitemap                 = Minitest::Mock.new
    
    @options = { 
      :screenshot_dir => "test/testables/screenshot_tmp/",
      :browser => :ff
       }
    # Configure the mock object
    @sitemap.expect( :the_paths, [["root", "/"]] )
  end

  def test_snapper_takes_snaps
    
    WatirCats.configure(@options)

    snapped = WatirCats::Snapper.new( @base_url, @sitemap )

    working_dir = Dir.pwd
    Dir.chdir( WatirCats.config.screenshot_dir )
    target_dir = Dir.glob("*/*.png")
    expected   = target_dir[0].split( "/" ).include? "root_1024.png"
    assert_equal 1, target_dir.size
    assert_equal true, expected
    Dir.chdir working_dir
  end

  def teardown
    FileUtils.rm_rf WatirCats.config.screenshot_dir
  end
end