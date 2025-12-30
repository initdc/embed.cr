require "./spec_helper"

describe Embed do
  posix = Path::Kind.native == Path::Kind::POSIX

  file = posix ? "#{__DIR__}/testdata/testfile" : "#{__DIR__}\\testdata\\testfile"
  dir = posix ? "#{__DIR__}/testdata" : "#{__DIR__}\\testdata"
  pattern = posix ? "#{__DIR__}/testdata/.*" : "#{__DIR__}\\testdata\\.*"

  it "embed_file" do
    Embed.embed_file(file)
    Embed.file(file).gsub("\r\n", "\n").should eq "Hello,\nworld!"
  end

  it "embed_dir" do
    Embed.embed_dir(dir)
    Embed.dir(dir)[0].gsub("\r\n", "\n").should eq "Hello,\ndot!"
  end

  it "list_children" do
    Embed.list_children(dir)
    Embed.children(dir)[0].should eq Path[__DIR__].to_native.to_s + Path::SEPARATORS[0] + ".dotfile"
  end

  it "list_entries" do
    Embed.list_entries(dir)
    Embed.entries(dir)[0].should eq Path[__DIR__].to_native.to_s + Path::SEPARATORS[0] + "."
  end

  it "embed_glob" do
    Embed.embed_glob(pattern, match: File::MatchOptions::All)
    Embed.glob(pattern)[0].gsub("\r\n", "\n").should eq "Hello,\ndot!"
  end
end
