class Pbx
  def initialize
    set_file
  end

  def replace_code_sign
    @content = read
    @content.gsub(/(CODE_SIGN_IDENTITY = ").+?;/, "\\1#{@code_sign_identity}\";")
  end

  private

  def read
    File.open(@file_name).read
  end

  def write(new_content)
    File.open(@file_name, "w") { |file| file.puts new_content}
  end

  def set_file
    if ARGV.count < 2
      puts '--> Arguments missing. Usage :'
      puts '--> ruby fastlane_guard.rb "file_name code_sign_identity fid_mobile ad_hoc"'
      exit
    end

    @file_name = ARGV[0]
    @code_sign_identity = ARGV[1]
    @fid_mobile = ARGV[2] if ARGV[2]
    @ad_hoc = ARGV[3] if ARGV[3]
  end
end


@pbx = Pbx.new()
@pbx.replace_code_sign

