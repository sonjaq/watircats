require 'watircats'

class ComparerTest < Minitest::Test
  
  def setup
    # Initial setup
    WatirCats.configure :output_dir => "test/testables/output"

    @source_a = "test/testables/folder_a/"
    @source_b = "test/testables/folder_b/"
    @output   = WatirCats.config.output_dir
  end

  def test_compare_directories_and_results
    WatirCats.configure :reporting_enabled => false, :output_dir => "test/testables/output/no_thumbs"
    output_dir = WatirCats.config.output_dir
    comparer   = WatirCats::Comparer.new( @source_a, @source_b )

    results  = comparer.results
    expected = [{ :compared_shot => "watircat_compared.png", 
                  :result => "832", :status_color => "Khaki" }]

    assert_equal expected, results
    assert_equal true, File.exists?("#{output_dir}/watircat_compared.png")
    assert_equal false, File.exists?("#{output_dir}/watircat_no_compare_compared.png")
    assert_equal false, File.directory?("#{output_dir}/thumbs")
    FileUtils.rm_rf output_dir
  end

  def test_compare_directories_and_results_with_reporting
    WatirCats.configure :reporting_enabled => true, :output_dir => "test/testables/output/with_thumbs"
    output_dir = WatirCats.config.output_dir

    comparer = WatirCats::Comparer.new( @source_a, @source_b )

    results  = comparer.results
    expected = [{ :compared_shot => "watircat_compared.png", 
                  :result => "832", :status_color => "Khaki" }]

    assert_equal expected, results
    assert_equal true, File.exists?("#{output_dir}/watircat_compared.png")
    assert_equal false, File.exists?("#{output_dir}/watircat_no_compare_compared.png")
    assert_equal true, File.directory?("#{output_dir}/thumbs/")
    assert_equal true, File.exists?("#{output_dir}/thumbs/watircat_compared.png")
    FileUtils.rm_rf output_dir
  end

  def teardown
  end

end