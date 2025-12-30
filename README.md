# embed

Embed file or dir to your project.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     embed:
       github: initdc/embed.cr
   ```

2. Run `shards install`

## Usage

```crystal
require "embed"

posix = Path::Kind.native == Path::Kind::POSIX

file = posix ? "#{__DIR__}/testdata/testfile" : "#{__DIR__}\\testdata\\testfile"
dir = posix ? "#{__DIR__}/testdata" : "#{__DIR__}\\testdata"
pattern = posix ? "#{__DIR__}/testdata/.*" : "#{__DIR__}\\testdata\\.*"

Embed.embed_file(file)
p Embed.file(file)

Embed.embed_dir(dir)
p Embed.dir(file)

Embed.embed_glob(pattern)
p Embed.glob(file)
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
