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

    public static Integer hexToInt(String sourceHex) {
        String hex = '0123456789abcdef';
        String[] hexValue = sourceHex.split('');
        Integer result = 0;
        for(Integer index = 0; index < hexValue.size(); index++) {
            result = (result * 16) + hex.indexOf(hexValue[index]);
        }
        return result;
      }
      

    public static Integer[] blobToIntegerArray (Blob data){
        String hex = EncodingUtil.convertToHex(data);
        Integer[] res = new List<Integer>();
        for (Integer i = 0; i < hex.length(); i+=2){
            res.add(hexToInt(hex.substring(i, i + 2)));
        }
        return res;
    }
    
    
}