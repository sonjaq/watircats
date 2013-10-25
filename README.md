# Wraith

 * Website: http://responsivenews.co.uk
 * Source: http://github.com/bbc-news/wraith

Wraith is a screenshot comparison tool, created by developers at BBC News.


## What is it?

WatirCats uses Watir-Webdriver to grab screenshots of pages at multiple widths.  It also grabs and parses a site's sitemap, assuming the site map is hosted at the site_root/sitemap.xml


## Requirements

- ImageMagick
- Ruby 1.9.3 or greater
- Firefox

## Installation



## Config

All config will be placed in config.yml. You can specify domains, paths, screen
widths & HTTP headers.

```yaml
# Add a domain as the dev aprameter
domains:
  dev:

#Type screen widths below, here are a couple of examples
screen_widths:
  - 320
  - 600
  - 768
  - 1024
  - 1280

#Type page URL paths below, here are a couple of examples
paths:
  search_page: /imghp
  map_page: /maps
```


## Using Wraith

```
## Output

## Contributing

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

 * [Dave Blooman](http://twitter.com/dblooman)
 * [John Cleveley](http://twitter.com/jcleveley)
 * [Simon Thulbourn](http://twitter.com/sthulbourn)
 * [Andrew Leaf](http://twitter.com/avleaf)

