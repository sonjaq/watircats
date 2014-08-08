# WatirCats
[![Gem Version](https://badge.fury.io/rb/watircats.svg)](http://badge.fury.io/rb/watircats)

WatirCats began as a simple fork of Wraith, from the developers at BBC News.

Orignally, Wraith used Phantom.js as its browser, but it was too darned slow, so the browsing engine was converted to Watir-Webdriver. There were also several other limitations to Wraith that hampered its use at Clockwork, so it was enhanced to support a number of unique features. 

Wraith's original comparison command lies at the heart of the comparison functionality of WatirCats. 

Some of the features:
- Responsive Screenshots
- Multiple sources for URLs, but most rely on /sitemap.xml for use
- Multiple Browsing engines. Chrome, Firefox, FirefoxESR, and support for IE
- Proxy and custom binary path support for Firefox

## What is it?

WatirCats uses Watir-Webdriver to grab screenshots of pages at multiple widths.  It also grabs and parses a site's sitemap, assuming the site map is hosted at the site_root/sitemap.xml

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
- `gem install watircats-0.2.3.gem`

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

 * [Andrew Leaf](http://clockwork.net/people/andrew_leaf/) - author, maintainer
 * [Wraith from BBC News](http://github.com/bbc-news/wraith) - original concept

