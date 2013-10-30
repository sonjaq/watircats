require 'watircats'

class ComparerTest < Minitest::Test
  
  def setup
    @source_a = "test/testables/folder_a/"
    @source_b = "test/testables/folder_b/"
    @output   = "test/testables/output"
  end

  def test_compare_directories_and_results
    output_dir = "#{@output}/no_thumbs"
    comparer = WatirCats::Comparer.new(
      @source_a,
      @source_b,
      output_dir
      )

    results = WatirCats::Comparer.results
    expected = [{ :compared_shot => "watircat_compared.png", 
                  :result => "832", :status_color => "Khaki" }]

    assert_equal expected, results
    assert_equal true, File.exists?("#{output_dir}/watircat_compared.png")
    assert_equal false, File.exists?("#{output_dir}/watircat_no_compare_compared.png")
    assert_equal false, File.directory?("#{output_dir}/thumbs")
    FileUtils.rm_rf output_dir
  end

  def test_compare_directories_and_results_with_reporting
    output_dir = "#{@output}/with_thumbs"
    options = { :reporting => true }
    comparer = WatirCats::Comparer.new(
      @source_a,
      @source_b,
      output_dir,
      options
      )

    results = WatirCats::Comparer.results
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