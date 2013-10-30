require 'watircats'
require 'minitest/mock'

class SnapperTest < Minitest::Test
  def setup
    @base_url                = "www.clockwork.net"
    $custom_body_class_tests = []
    @sitemap                 = Minitest::Mock.new
    
    @screenshot_dir = "test/testables/screenshot_tmp/"
    # Configure the mock object
    @sitemap.expect( :the_paths, [["root", "/"]] )
  end

  def test_snapper_takes_snaps
    
    snapped = WatirCats::Snapper.new( @base_url, @sitemap, @screenshot_dir )

    working_dir = Dir.pwd
    Dir.chdir(@screenshot_dir)
    target_dir = Dir.glob("*/*.png")
    expected = target_dir[0].split("/").include? "root_1024.png"
    assert_equal 1, target_dir.size
    assert_equal true, expected
    Dir.chdir working_dir
  end

  def teardown
    FileUtils.rm_rf @screenshot_dir
  end
end