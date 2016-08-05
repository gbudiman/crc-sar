class Crc
  attr_accessor :crc_bits, :display_steps, :dataword, :dataword_bit_size, :generator
  attr_reader :remainder

  def initialize
    @dataword             = 0xDDA
    @dataword_bit_size    = 12
    @generator            = 0x1D

    @codeword             = nil
    @crc_bits             = 0
    @remainder            = 0

    @display_steps        = true
  end

  def calculate
    generator_s         = sprintf("%b", @generator)
    bit_length          = generator_s.length - 1
    mask                = 2 ** generator_s.length - 1
    codeword_bit_length = bit_length + @dataword_bit_size

    dataword_padded = (@dataword << bit_length) + @crc_bits

    resultant = dataword_padded >> (@dataword_bit_size - 1) & mask

    if display_steps
      puts sprintf("%0#{codeword_bit_length}b (0x%X)", dataword_padded, @dataword)
      codeword_bit_length.times { print "-" }
      puts
    end

    @dataword_bit_size.times do |i|
      right_shift = @dataword_bit_size - i - 1
      _a = resultant
      _f = (_a >> bit_length) & 0x1
      _g = _f == 1 ? @generator : 0
      
      if display_steps
        i.times { print " " }
        puts sprintf("%0#{generator_s.length}b", _a)
        i.times { print " " }
        puts sprintf("%0#{generator_s.length}b", _g)
        codeword_bit_length.times { print "-" }
        puts
      end

      resultant = (((_a ^ _g) << 1) & mask) + ((dataword_padded >> (right_shift - 1)) & 0x1)
    end

    resultant = resultant >> 1
    @remainder = resultant

    if display_steps
      @dataword_bit_size.times { print " " }
      puts sprintf("%0#{bit_length}b", @remainder)
      puts
    end
    puts(sprintf("0x%X (%s) => 0x%X (%b)",     
         @dataword,                           
         Formatter::binary(@dataword),        
         @remainder,                          
         @remainder))
  end

  def debug
  end

  def determine_burst_error_length_against _x
    first_error = nil
    last_error = nil

    @dataword_bit_size.times do |i|
      if ((@dataword >> i) & 0x1) != ((_x >> i) & 0x1)
        first_error ||= i
        last_error = i
      end
    end

    if first_error
      return last_error - first_error + 1
    else
      return 0
    end
  end
end