# embed

Embed file or dir to your project.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     embed:
       github: initdc/embed
   ```

2. Run `shards install`

## Usage

```crystal
require "embed"

Embed.embed_file("#{__DIR__}/testdata/testfile")
Embed.embed_dir("#{__DIR__}/testdata")
Embed.embed_glob("#{__DIR__}/testdata/.*", match: File::MatchOptions::All)
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/initdc/embed/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [initdc](https://github.com/initdc) - creator and maintainer
