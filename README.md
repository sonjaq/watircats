# WatirCats

WatirCats began as a simple for to Wraith, from the developers at BBC News.

Orignally, Wraith used Phantom.js as it's browser, but it was too darned slow, so the browsing engine was converted to Watir-Webdriver. There were also several other limitations to Wraith that hampered its use at Clockwork, so it was enhanced to support a number of unique features. There is part of one line left of core functionality from Wraith that calls ImageMagick's 'compare' executable. Everything else is fresh code.

Some of the features
	- Multiple sources for URLs, but most rely on /sitemap.xml for use
	- Multiple Browsing engines. Chrome, Firefox, FirefoxESR, and even IE
	- Proxy and custom binary path support for Firefox
	- Specify multiple widths of screenshots

## What is it?

WatirCats uses Watir-Webdriver to grab screenshots of pages at multiple widths.  It also grabs and parses a site's sitemap, assuming the site map is hosted at the site_root/sitemap.xml


## Requirements

- ImageMagick
- Ruby 1.9.3 or greater
- Firefox

## Installation

gem install watircats


## Config

Configuration can be done at the command line or via a config file. See 'sample_config.yml' for the available parameters. Specify a config file at runtime with --config_file "my_config_file.yml"



If you want to add functionality to this project, pull requests are welcome.

 * Create a branch based off master and do all of your changes with in it.
 * If it you have to pause to add a 'and' anywhere in the title, it should be two pull requests.
 * Make commits of logical units and describe them properly
 * Check for unnecessary whitespace with git diff --check before committing.
 * If possible, submit tests to your patch / new feature so it can be tested easily.
 * Assure nothing is broken by running all the test
 * Please ensure that it complies with coding standards.

**Please raise any issues with this project as a GitHub issue.**


## Licence

Wraith is available to everyone under the terms of the MIT open source
licence. Take a look at the LICENSE file in the code.


## Credits

 * [Original Source](http://github.com/bbc-news/wraith)
 * [Andrew Leaf](http://clockwork.net/people/avleaf)

