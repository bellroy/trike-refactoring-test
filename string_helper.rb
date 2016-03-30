module StringHelper
  def empty?(str)
    # nil, empty or just whitespace
    str.to_s.strip.length == 0
  end

  def case_insensitive_equal?(str1, str2)
    str1.downcase == str2.downcase
  end
end