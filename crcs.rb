require 'trollop'
require 'awesome_print'
require_relative 'crc.rb'
require_relative 'formatter.rb'

opts = Trollop::options do
  opt :display_steps, "Display step-by-step computation", default: false, short: 's'
  opt :dataword, "Dataword value. Used to determine burst error length when --brute-force option is passed", default: "0xDDA"
  opt :dataword_bit_size, "Dataword size in bits", default: 12, short: 'b'
  opt :crc, "CRC appended to dataword", default: "0"
  opt :generator, "CRC generator", default: "0x1D"
  opt :brute_force, "Brute force datawords to obtain remainder of 0", default: false
end

c = Crc.new
c.dataword = Integer(opts[:dataword])
c.dataword_bit_size = opts[:dataword_bit_size]
c.crc_bits = Integer(opts[:crc])
c.generator = Integer(opts[:generator])
c.display_steps = opts[:display_steps]

if opts[:brute_force]
  res = Hash.new
  c.display_steps = false
  (0..2**Integer(opts[:dataword_bit_size])-1).each do |i|
    c.dataword = i
    c.calculate
    if c.remainder == 0
      bel = c.determine_burst_error_length_against Integer(opts[:dataword])
      res[bel] ||= Array.new
      res[bel].push i
    end
  end

  ap Hash[res.sort]
else
  c.calculate
end