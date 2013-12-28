require 'minitest/autorun'
require 'watircats'

class MapperTest < Minitest::Test
  
  def setup
    @base_url = "www.clockwork.net"
    @scheme   = "http"
    options  = { :limit => 1 }
    @xml_file = XmlSimple.xml_in(File.open("test/testables/sitemap.xml", "r"))
    WatirCats.configure options
  end

  def test_parse_sitemap_into_urls
    map = WatirCats::Mapper.new(
      @base_url, 
      @scheme
      ).parse_sitemap_into_urls(@xml_file)

    expected = [
      "http://www.clockwork.net/",
      "http://www.clockwork.net/work/",
      "http://www.clockwork.net/people/",
      "http://www.clockwork.net/blog/"
      ]

    assert_equal map, expected
  end

  def test_paths
    urls = [
      "http://www.clockwork.net/",
      "http://www.clockwork.net/work/",
      "http://www.clockwork.net/people/",
      "http://www.clockwork.net/blog/"
      ]

    paths = WatirCats::Mapper.new(
      @base_url,
      @scheme
      ).paths(urls)

    expected = {
        "root"   => "/",
        "work"   => "/work/",
        "people" => "/people/",
        "blog"   => "/blog/"
    }
    assert_equal paths, expected
  end

  def test_mapper
    mapper = WatirCats::Mapper.new( @base_url, @scheme )
    expected = [["root", "/"]]
    assert_equal mapper.the_paths, expected
    assert_equal mapper.master_paths, expected
    assert_equal mapper.new_paths, []
  end
end