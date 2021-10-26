@IsTest
public with sharing class BcryptTest {
    
    @IsTest
    public static void hashTest(){
        String hash = Bcrypt.hash('hashing_password');
        System.assert(Bcrypt.compare('hashing_password', hash), 'Password should match');   
    }
    @IsTest
    public static void hashFailedTest(){
        String hash = Bcrypt.hash('hashing_password');
        System.assert(!Bcrypt.compare('wrong_password', hash), 'Password should\'nt match');   
    }

    @IsTest
    public static void hashWithLessRoundsTest(){
        String hash = Bcrypt.hash('hashing_password', 3);
        System.assert(Bcrypt.compare('hashing_password', hash), 'Password should match');   
    }

    @IsTest
    public static void hashWithMoreRoundsTest(){
        String hash = Bcrypt.hash('hashing_password', 32);
        System.assert(Bcrypt.compare('hashing_password', hash), 'Password should match');   
    }

    @IsTest
    public static void wrongHashTest(){
        try{
           String hash = Bcrypt.hash('hashing_password', 'weirdhash');
           System.assert(false, 'Should throw IllegalArgumentException');
        }
        catch(Exception e){
            System.assert(e.getTypeName() == 'System.IllegalArgumentException', 'Should throw IllegalArgumentException');
        }
    }

    @IsTest
    public static void wrongHashLengthCompareTest(){
        try{
            Bcrypt.compare('hashing_password', 'weirdhash');
            System.assert(false, 'Should throw IllegalArgumentException');
         }
         catch(Exception e){
             System.assert(e.getTypeName() == 'System.IllegalArgumentException', 'Should throw IllegalArgumentException');
         } 
    }


}
