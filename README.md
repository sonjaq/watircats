# WatirCats
[![Gem Version](https://badge.fury.io/rb/watircats.svg)](http://badge.fury.io/rb/watircats)

WatirCats uses Watir-Webdriver to grab screenshots of pages at multiple widths.  It also grabs and parses a site's sitemap, assuming the site map is hosted at the site_root/sitemap.xml. 

Using the `compare`, ImageMagick is used to see if the images have differences. If they do, you'll get a visual diff in the output folder.

Some of the features:
- Responsive Screenshots
- Multiple sources for URLs, but most rely on /sitemap.xml for use
- Multiple Browsing engines. Chrome, Firefox, FirefoxESR, and support for IE
- Proxy and custom binary path support for Firefox


## Requirements

- ImageMagick
- Ruby 1.9.3 or greater
- Firefox

## Installation

`gem install watircats`

or

- Checkout this repository
- `bundle install`
- `gem build watircats.gemspec`
- `gem install watircats-0.2.5.gem`

## Usage

- Compare And Take Screenshots:
 - `watircats compare http://my.example.com http://my-other.example.com` 
- Compare two folders of screenshots:
 - `watircats folders folder_a folder_b`
- Take screenshots at several widths:
 - `watircats screenshots http://my.example.com --widths 1024 800 320`

## Configuration

Configuration can be done at the command line or via a config file. See 'sample_config.yml' for the available parameters. 

Specify a config file at runtime with `--config_file my_config_file.yml`


If you want to add functionality to this project, pull requests are welcome.

 * Create a branch based off master and do all of your changes with in it.
 * If it you have to pause to add a 'and' anywhere in the title, it should be two pull requests.
 * Make commits of logical units and describe them properly
 * Check for unnecessary whitespace with git diff --check before committing.
 * If possible, submit tests to your patch / new feature so it can be tested easily.
 * Assure nothing is broken by running all the test
 * Please ensure that it complies with coding standards.

**Please raise any issues with this project as a GitHub issue.**


## License

WatirCats is available to everyone under the terms of the MIT open source
license. Take a look at the LICENSE file in the code.

## Credits

 * [Andie Leaf](http://github.com/avleaf) - author, maintainer
 * [Wraith from BBC News](http://github.com/bbc-news/wraith) - original concept

