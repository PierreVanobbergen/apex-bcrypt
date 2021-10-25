public class Radix64Encoder {

    private static final Integer[] DECODE_TABLE = new Integer[]{
            -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
            -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
            -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 0, 1, 54, 55, 56, 57,
            58, 59, 60, 61, 62, 63, -1, -1, -1, -2, -1, -1, -1, 2, 3, 4, 5, 6, 7,
            8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
            26, 27, -1, -1, -1, -1, -1, -1, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37,
            38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53};

    private static final  String[] MAPPER = new String[]{
            '.', '/', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
            'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V',
            'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h',
            'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
            'u', 'v', 'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5',
            '6', '7', '8', '9'
    };
    private static Map < String, Integer > hexMap = new Map < String, Integer > ();
        static{
        hexMap.put('0', 0);
        hexMap.put('1', 1);
        hexMap.put('2', 2);
        hexMap.put('3', 3);
        hexMap.put('4', 4);
        hexMap.put('5', 5);
        hexMap.put('6', 6);
        hexMap.put('7', 7);
        hexMap.put('8', 8);
        hexMap.put('9', 9);
        hexMap.put('A', 10);
        hexMap.put('B', 11);
        hexMap.put('C', 12);
        hexMap.put('D', 13);
        hexMap.put('E', 14);
        hexMap.put('F', 15);
        hexMap.put('a', 10);
        hexMap.put('b', 11);
        hexMap.put('c', 12);
        hexMap.put('d', 13);
        hexMap.put('e', 14);
        hexMap.put('f', 15);
        }
    
    public static String encode(Blob data, Long len) {
        Integer[] b = blobToIntegerArray(data);
        
        Integer off = 0;
        String[] rs = new List<String>();
        Integer c1;
        Integer c2;

        if(len <= 0 || len > b.size()){
            throw new IllegalArgumentException('Illegal len to encode ' + len.format());
        }
        while (off < len) {
            c1 = b[off++] & 255;
            rs.add(MAPPER[(c1 >> 2) & 63]);
            c1 = (c1 & 3) << 4;
            if (off >= len) {
                rs.add(MAPPER[c1 & 63]);
                break;
            }
            c2 = b[off++] & 255;
            c1 |= (c2 >> 4) & 15;
            rs.add(MAPPER[c1 & 63]);
            c1 = (c2 & 15) << 2;
            if (off >= len) {
                rs.add(MAPPER[c1 & 63]);
                break;
            }
            c2 = b[off++] & 255;
            c1 |= (c2 >> 6) & 3;
            rs.add(MAPPER[c1 & 63]);
            rs.add(MAPPER[c2 & 63]);
        }
        return String.join(rs, '');

    }

    public static Blob decode(String s, Long len){
        Integer off = 0;
        Integer slen = s.length();
        Integer olen = 0;
        String[] rs = new List<String>();
        Integer c1, c2, c3, c4, o, code;
        if (len <= 0){
            throw new IllegalArgumentException('Illegal len to decode ' + len.format());  
        }
     
        while (off < slen - 1 && olen < len) {  
            code = s.charAt(off++);
            c1 = code < DECODE_TABLE.size() ? DECODE_TABLE[code] : -1;
            code = s.charAt(off++);
            c2 = code < DECODE_TABLE.size() ? DECODE_TABLE[code] : -1;
            if (c1 == -1 || c2 == -1)
                break;
            o = (c1 << 2) >>> 0;
            o |= (c2 & 48) >> 4;
            rs.add(String.fromCharArray(new Integer[]{o}));
            if (++olen >= len || off >= slen)
                break;
            code = s.charAt(off++);
            c3 = code < DECODE_TABLE.size() ? DECODE_TABLE[code] : -1;
            if (c3 == -1)
                break;
            o = ((c2 & 15) << 4) >>> 0;
            o |= (c3 & 60) >> 2;
            rs.add(String.fromCharArray(new Integer[]{o}));
            if (++olen >= len || off >= slen)
                break;
            code = s.charAt(off++);
            c4 = code < DECODE_TABLE.size() ? DECODE_TABLE[code] : -1;
            o = ((c3 & 3) << 6) >>> 0;
            o |= c4;
            rs.add(String.fromCharArray(new Integer[]{o}));
            ++olen;
        }
        Integer[] res = new List<Integer>();
        for (off = 0; off<olen; off++)
            res.add(rs[off].codePointAt(0));
        return Blob.valueOf(String.fromCharArray(res));
    }
    public class UTFException extends Exception{
    }

    public static List < Integer > hexToInt(String hex) {
        List < Integer > retVal = new List < Integer > ();
        Integer i = 0;
        while(i < hex.length()) {
      
          // http://en.wikipedia.org/wiki/UTF-8
          integer numberOfBytes = 1;
          integer byte1 = 0,
          byte2 = 0,
          byte3 = 0,
          byte4 = 0;
          integer utfCode = 0;
          byte1 = (hexMap.get(hex.substring(i, i + 1)) * 16) + (hexMap.get(hex.substring(i + 1, i + 2)));
      
          //invalid sequences for byte1
          if(byte1 >= 128 && byte1 <= 191) {
            throw new UTFException('UTF-8:Continuation byte as first byte');
          }
          if(byte1 >= 192 && byte1 <= 193) {
            throw new UTFException('UTF-8:Invalid 2-byte sequence');
          }
          if(byte1 >= 245) {
            throw new UTFException('UTF-8:Invalid 4,5 or 6-byte sequence');
          }
      
          if(byte1 >= 192) {
            numberOfBytes = 2;
            byte2 = (hexMap.get(hex.substring(i + 2, i + 2 + 1)) * 16) + (hexMap.get(hex.substring(i + 2 + 1, i + 2 + 2)));
          }
          if(byte1 >= 224) {
            numberOfBytes = 3;
            byte3 = (hexMap.get(hex.substring(i + 4, i + 4 + 1)) * 16) + (hexMap.get(hex.substring(i + 4 + 1, i + 4 + 2)));
          }
          if(byte1 >= 240) {
            numberOfBytes = 4;
            byte4 = (hexMap.get(hex.substring(i + 6, i + 6 + 1)) * 16) + (hexMap.get(hex.substring(i + 6 + 1, i + 6 + 2)));
          }
          if(numberOfBytes == 1) {
            utfCode = byte1;
          } else if(numberOfBytes == 2) {
            utfCode = Math.mod(byte1, 32) * 64 + Math.mod(byte2, 64);
          } else if(numberOfBytes == 3) {
            utfCode = Math.mod(byte1, 16) * 64 * 64 + Math.mod(byte2, 64) * 64 + Math.mod(byte3, 64);
          } else if(numberOfBytes == 4) {
            utfCode = Math.mod(byte1, 8) * 64 * 64 * 64 + Math.mod(byte2, 64) * 64 * 64 + Math.mod(byte3, 64) * 64 + Math.mod(byte4, 64);
          }
      
          retVal.add(utfCode);
          i += 2 * numberOfBytes;
        }
        return retVal;
      }
      

    public static Integer[] blobToIntegerArray (Blob data){
        return Radix64Encoder.hexToInt(EncodingUtil.convertToHex(data));
    }
    
}