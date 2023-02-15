import javax.crypto.*;
import java.awt.event.MouseAdapter;
import java.io.IOException;
import java.io.Serializable;
import java.io.UnsupportedEncodingException;
import java.security.*;
import java.util.Base64;

public class RSA {
    private PrivateKey Private;
    private PublicKey Public;

    public RSA() throws NoSuchAlgorithmException {
        KeyPairGenerator Generator = KeyPairGenerator.getInstance("RSA");
        Generator.initialize(1048);
        KeyPair Pair = Generator.generateKeyPair();
        Private = Pair.getPrivate();
        Public = Pair.getPublic();

    }

    public String encrypt(String Message) throws NoSuchPaddingException, NoSuchAlgorithmException, InvalidKeyException, IllegalBlockSizeException, BadPaddingException {
        String encrptyedMessage = null;
        byte[] ByteMessages = Message.getBytes();
        Cipher Encryption = Cipher.getInstance("RSA/ECB/PKCS1Padding");
        Encryption.init(Cipher.ENCRYPT_MODE, Public);
        byte[] encryptedBytes = Encryption.doFinal(ByteMessages);
        encrptyedMessage = Base64.getEncoder().encodeToString(encryptedBytes);
        return encrptyedMessage;
    }

    public String Decrypt(String EncryptedMessage) throws NoSuchPaddingException, NoSuchAlgorithmException, InvalidKeyException, IllegalBlockSizeException, BadPaddingException, InvalidAlgorithmParameterException, UnsupportedEncodingException {
        byte[] decryptedBytes = Base64.getDecoder().decode(EncryptedMessage);
        Cipher decryption = Cipher.getInstance("RSA/ECB/PKCS1Padding");
        decryption.init(Cipher.DECRYPT_MODE, Private);
        byte[] decrypted = decryption.doFinal(decryptedBytes);
        return new String(decrypted, "UTF8");
    }
    public Serializable DecryptKey(SealedObject Key) throws NoSuchPaddingException, NoSuchAlgorithmException, InvalidKeyException, IllegalBlockSizeException, BadPaddingException, InvalidAlgorithmParameterException, IOException, ClassNotFoundException {
        Cipher decryption = Cipher.getInstance("RSA/ECB/PKCS1Padding");
        decryption.init(Cipher.DECRYPT_MODE, Private);
        SecretKey unsealKey = (SecretKey) Key.getObject(decryption);
        return unsealKey;
    }
    public SealedObject encryptKey(SecretKey Key) throws NoSuchPaddingException, NoSuchAlgorithmException, InvalidKeyException, IllegalBlockSizeException, BadPaddingException, IOException {
        Cipher Encryption = Cipher.getInstance("RSA/ECB/PKCS1Padding");
        Encryption.init(Cipher.ENCRYPT_MODE, Public);
        SealedObject sealedKey = new SealedObject(Key,Encryption);
        return sealedKey;
    }

    public PrivateKey getPrivate() {
        return Private;
    }

    public PublicKey getPublic() {
        return Public;
    }

    public static void main(String [] args) throws NoSuchAlgorithmException, NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException, InvalidKeyException, InvalidAlgorithmParameterException, UnsupportedEncodingException {
        RSA rsa = new RSA();
        String enc = rsa.encrypt("Hello");
        String dec = rsa.Decrypt(enc);
        System.out.println(rsa.Public);
        System.out.println(rsa.Private);

        System.out.println(enc);
        System.out.println(dec);

    }
}