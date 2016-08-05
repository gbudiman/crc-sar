class Formatter
  def self.binary _x
    result = ''
    i = 0
    
    sprintf("%b", _x).reverse.each_char do |e|
      if (i % 4 == 0) and i != 0
        result += ' '
      end

      result += e
      i += 1
    end

    return result.reverse
  end
end