import javax.crypto.*;
import javax.crypto.spec.GCMParameterSpec;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

public class AES {
     private SecretKey Key;
     private Cipher Encryption;
     private int Tlen = 128;


    public void CreateKey() throws NoSuchAlgorithmException {
        KeyGenerator Generator = KeyGenerator.getInstance("AES");
        Generator.init(128);
        Key = Generator.generateKey();
    }
    public String encrypt(String Message) throws NoSuchPaddingException, NoSuchAlgorithmException, InvalidKeyException, IllegalBlockSizeException, BadPaddingException {
        String encrptyedMessage = null;
        byte[] ByteMessages = Message.getBytes();
        Encryption = Cipher.getInstance("AES/GCM/NoPadding");
        Encryption.init(Cipher.ENCRYPT_MODE,Key);
        byte [] encryptedBytes = Encryption.doFinal(ByteMessages);
         encrptyedMessage = Base64.getEncoder().encodeToString(encryptedBytes);
        return encrptyedMessage;
    }
    public String Decrypt(String EncryptedMessage) throws NoSuchPaddingException, NoSuchAlgorithmException, InvalidKeyException, IllegalBlockSizeException, BadPaddingException, InvalidAlgorithmParameterException {
        byte [] decryptedBytes = Base64.getDecoder().decode(EncryptedMessage);
        Cipher decryption = Cipher.getInstance("AES/GCM/NoPadding");
        GCMParameterSpec Spec = new GCMParameterSpec(Tlen,Encryption.getIV());
        decryption.init(Cipher.DECRYPT_MODE,Key,Spec);
        byte [] decrypted = decryption.doFinal(decryptedBytes);
        return new String(decrypted);

    }
    public static void main(String [] args) throws NoSuchAlgorithmException, NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException, InvalidKeyException, InvalidAlgorithmParameterException {
        AES N = new AES();
        N.CreateKey();
            String enc = N.encrypt("Hey");
            String de = N.Decrypt(enc);
            System.out.println(enc);
            System.out.println(de);

    }
}
