module Embed
  VERSION = "0.1.0"

  alias Data = NamedTuple(name: String, path: Path, info: File::Info, data: String)

  macro extended
    @@db = Hash(Symbol, Array(Data)).new
    @@db[:FILE] = Array(Data).new
    @@db[:CHILDREN] = Array(Data).new
    @@db[:ENTRIES] = Array(Data).new
    @@db[:DIR] = Array(Data).new
    @@db[:GLOB] = Array(Data).new
  end

  extend self

  def embed_file(input : String)
    path = Path[input]
    data = {name: input, path: path, info: File.info(path), data: File.read(path)}
    @@db[:FILE] << data
  end

  def file(input : String)
    @@db[:FILE].select { |data| data[:name] == input }[0]
  end

  def list_children(input : String)
    @@db[:CHILDREN] += list_info(input)
  end

  def children(input : String)
    @@db[:CHILDREN].select { |data| data[:name] == input }
  end

  def list_entries(input : String)
    @@db[:ENTRIES] += list_info(input, entries: true)
  end

  def entries(input : String)
    @@db[:ENTRIES].select { |data| data[:name] == input }
  end

  def embed_dir(input : String)
    dir_path = Path[input]
    dir_str = dir_path.to_s
    files = Dir.new(dir_path).children.sort

    if files.empty?
      raise File::NotFoundError.new("embed_dir #{dir_str.inspect} no files found", file: dir_str)
    end
    @@db[:DIR] += read_files(input, dir_path, files)
  end

  def dir(input : String)
    @@db[:DIR].select { |data| data[:name] == input }
  end

  def embed_glob(input : String, match : File::MatchOptions = File::MatchOptions::All, follow_symlinks : Bool = false)
    dir_path = Path[input]
    dir_str = dir_path.to_s
    parent_path = dir_path.parent
    parent_str = parent_path.to_s

    files = Dir.cd(parent_path) do
      win_pattern = dir_str.sub(parent_str + Path::SEPARATORS[0], "")
      Dir.glob(win_pattern, match: match, follow_symlinks: follow_symlinks).sort
    end

    if files.empty?
      raise File::NotFoundError.new("embed_glob #{dir_str.inspect} doesn't match any file", file: dir_str)
    end
    @@db[:GLOB] += read_files(input, parent_path, files)
  end

  def glob(input : String)
    @@db[:GLOB].select { |data| data[:name] == input }
  end

  private def list_info(input : String, *, entries = false) : Array(Data)
    dir_path = Path[input]
    files = entries ? Dir.new(dir_path).entries.sort : Dir.new(dir_path).children.sort

    files.map do |file|
      path = dir_path.join(file)
      {name: input, path: path, info: File.info(path), data: ""}
    end
  end

  private def read_files(input : String, dir_path : Path, files : Array(String)) : Array(Data)
    files.compact_map do |file|
      path = dir_path.join(file)
      if File.file?(path)
        {name: input, path: path, info: File.info(path), data: File.read(path)}
      end
    end
  end
end
