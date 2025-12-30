module Embed
  VERSION = "0.1.0"

  @@data = Hash(String, Array(String)).new

  extend self

  def embed_file(filename : String)
    key = "FILE_" + filename
    @@data[key] = [File.read(filename)]
  end

  def file(filename : String)
    key = "FILE_" + filename
    @@data[key][0]
  end

  def list_children(path : String)
    key = "CHILDREN_" + path

    @@data[key] = full_path(path)
  end

  def children(path : String)
    key = "CHILDREN_" + path
    @@data[key]
  end

  def list_entries(path : String)
    key = "ENTRIES_" + path
    @@data[key] = full_path(path, entries: true)
  end

  def entries(path : String)
    key = "ENTRIES_" + path
    @@data[key]
  end

  def embed_dir(path : String)
    key = "DIR_" + path

    path = Path[path]
    files = Dir.new(path).children.sort
    if files.empty?
      raise File::NotFoundError.new("embed_dir #{path.inspect} no files found", file: path)
    end

    @@data[key] = read_files(path, files)
  end

  def dir(path : String)
    key = "DIR_" + path
    @@data[key]
  end

  def embed_glob(pattern : String, match : File::MatchOptions = File::MatchOptions.GLOB_default, follow_symlinks : Bool = false)
    key = "GLOB_" + pattern

    path = Path[pattern].parent

    files = Dir.cd(path) do
      win_pattern = pattern.sub(path.to_s + Path::SEPARATORS[0], "")
      Dir.glob(win_pattern, match: match, follow_symlinks: follow_symlinks).sort
    end
    if files.empty?
      raise File::NotFoundError.new("embed_glob #{pattern.inspect} doesn't match any file", file: pattern)
    end

    @@data[key] = read_files(path, files)
  end

  def glob(pattern : String)
    key = "GLOB_" + pattern
    @@data[key]
  end

  private def full_path(path : String, *, entries = false) : Array(String)
    path = Path[path]
    parent = path.parent.to_s
    files = entries ? Dir.new(path).entries.sort : Dir.new(path).children.sort

    files.map do |file|
      parent + Path::SEPARATORS[0] + file
    end
  end

  private def read_files(path : Path, files : Array(String)) : Array(String)
    files.compact_map do |file|
      filename = path.join(file)
      if File.file?(filename)
        File.read(filename)
      end
    end
  end
end
