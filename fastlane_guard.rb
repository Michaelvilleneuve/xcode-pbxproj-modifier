class Pbx
  def initialize
    set_file
  end

  def replace_code_sign
    @content = read
    @content.gsub!(/(CODE_SIGN_IDENTITY = ").+?;/, "\\1#{@code_sign_identity}\";")
    write(@content)
  end

  def replace_provisionning_profile
    new_content = ""
    read.each_line do |line|

      if line.include?("CODE_SIGN_ENTITLEMENTS")
        @replacement = get_replacement(line)
      elsif line.include?("INFOPLIST_FILE")
        @replacement = get_replacement(line)
      elsif line.include?("PROVISIONING_PROFILE ")
        line = line.gsub(/(PROVISIONING_PROFILE = ").+?;/, "\\1#{@replacement}\";")
      end

      new_content += line
    end

    write(new_content)
  end

  private

  def get_replacement(line)
    if line.include?("WatchKit Extension")
      "$(sigh_#{@fid_mobile}.watchkitextension_#{@ad_hoc})"
    elsif line.include?("WatchKit App")
      "$(sigh_#{@fid_mobile}.watchkitapp_#{@ad_hoc})"
    else
      "$(sigh_#{@fid_mobile}_#{@ad_hoc})"
    end
  end

  def read
    File.open(@file_name).read
  end

  def write(new_content)
    File.open(@file_name, "w") { |file| file.puts new_content}
  end

  def set_file
    if ARGV.count < 3
      puts '--> Arguments missing. Usage :'
      puts '--> ruby fastlane_guard.rb "file_name" "code_sign_identity" "fid_mobile" "ad_hoc"'
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
@pbx.replace_provisionning_profile
puts "--> Done"