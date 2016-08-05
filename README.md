# crc-sar
CRC Utility

```
$ ruby crcs.rb -h
Options:
  -s, --display-steps            Display step-by-step computation
  -d, --dataword=<s>             Dataword value. Used to determine burst error length when --brute-force option is
                                 passed (default: 0xDDA)
  -b, --dataword-bit-size=<i>    Dataword size in bits (default: 12)
  -c, --crc=<s>                  CRC appended to dataword (default: 0)
  -g, --generator=<s>            CRC generator (default: 0x1D)
  -r, --brute-force              Brute force datawords to obtain remainder of 0
  -h, --help                     Show this message
```
# Example 1: Obtaining CRC given a generator

```
$ ruby crcs.rb -d 0xDDA --generator 0x1D
0xDDA (1101 1101 1010) => 0x5 (101)
```

# Example 2: Checking codeword given CRC

```
$ ruby crcs.rb -d 0xDDA --generator 0x1D --crc 5
0xDDA (1101 1101 1010) => 0x0 (0)
```

# Example 3: Display calculation steps
```
$ ruby crcs.rb -d 0xDDA --generator 0x1D --crc 5 --display-steps
1101110110100101 (0xDDA)
----------------
11011
11101
----------------
 01101
 00000
----------------
  11010
  11101
----------------
   01111
   00000
----------------
    11111
    11101
----------------
     00100
     00000
----------------
      01001
      00000
----------------
       10010
       11101
----------------
        11110
        11101
----------------
         00111
         00000
----------------
          01110
          00000
----------------
           11101
           11101
----------------
            0000

0xDDA (1101 1101 1010) => 0x0 (0)
```

# Example 4: Brute-forcing dataword collision given CRC
```
$ ruby crcs.rb -d 0xDDA --generator 0x1D --crc 5 --display-steps --brute-force


     0 => [
        [0] 3546
    ],
     5 => [
        [0] 858,
        [1] 2714,
        [2] 3082,
        [3] 3378,
        [4] 3502,
        [5] 3527,
        [6] 3552,
        [7] 3706
    ],
     6 => [
        [0] 1050,
        [1] 2362,
        [2] 3298,
        [3] 3398,
        [4] 3476,
        [5] 3581,
        [6] 4010
    ],
     7 => [
        [ 0] 250,
        [ 1] 1978,
        
...
```

# Advanced examples
```
// Longer dataword bit-length
// Use -b option to speciy bits
$ ruby crcs.rb -d 0xEDDA --generator 0x93D -b 16
0xEDDA (1110 1101 1101 1010) => 0x3A (111010)
