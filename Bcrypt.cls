public with sharing class Bcrypt {

    public static Blob random(Integer len) {
        Integer[] r = new List<Integer>();
        for (Integer i = 0; i < len; i++){
            r.add(Integer.valueOf(Math.random() * 255));
        }
        return Blob.valueOf(String.fromCharArray(r));
        
    }
    public static String genSalt(Integer rounds) {
        if (rounds < 4){
            rounds = 4;
        }    
        else if (rounds > 31){
           rounds = 31; 
        }
            
        String[] salt = new List<String>();
        salt.add('$2a$');
        if (rounds < 10){
            salt.add('0');
        }   
        salt.add(String.valueOf(rounds));
        salt.add('$');
        salt.add(Radix64Encoder.encode(random(BcryptImplementation.BCRYPT_SALT_LEN), BcryptImplementation.BCRYPT_SALT_LEN)); // May throw
        return String.join(salt, '');
    }

    public static String hash(String s, String salt) {
        return BcryptImplementation.hash(s, salt);
    }

    public static String hash(String s){
        String salt = genSalt( BcryptImplementation.GENSALT_DEFAULT_LOG2_ROUNDS);
        return BcryptImplementation.hash(s, salt);
    }

    public static Boolean compare(String s, String hash){
        if(hash.length() != 60){
            throw new IllegalArgumentException('Hash not does not have correct length');
        }
        String res = hash(s, hash.substring(0, 29));
        return safeStringCompare(hash, res);

    }

    private static Boolean safeStringCompare(String known, String unknown) {
        Integer diff = known.length() ^ unknown.length();
        for (Integer i = 0; i < known.length(); ++i) {
            diff |= known.charAt(i) ^ unknown.charAt(i);
        }
        return diff == 0;
    }

}