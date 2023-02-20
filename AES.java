import javax.crypto.*;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

/** This Class is used to Implement the AES Algorithm into our Hybrid Encryption
 *
 */
public class AES {
    private SecretKey Key;      // AES Key
    private Cipher Encryption;  // Block Cipher Used
    private int Tlen = 128;     // Length for the Authentication Tag

    /** This Method is used to Generate an AES Key using the 128 bits which transfers to a 10 round encryption and decryption process
     *
     * @throws NoSuchAlgorithmException- Encryption Algorithm does not exist
     */
    public void CreateKey() throws NoSuchAlgorithmException {
        KeyGenerator Generator = KeyGenerator.getInstance("AES");
        Generator.init(128);
        Key = Generator.generateKey();
    }

    /** This Method Encrypts a Message by taking the Bytes of the Message and encrypting it with AES and Mode of Operation GCM (Galois Counter Mode)
     * The Single AES generated Key is Used to encrypt the Message
     * @param Message the Message to be encrypted
     * @return The Message Encoded in Base64
     * @throws NoSuchPaddingException - Padding does not exist
     * @throws NoSuchAlgorithmException - Encryption Algorithm does not exist
     * @throws InvalidKeyException - Incorrect Key length or encoding
     * @throws IllegalBlockSizeException - Block Cipher size must match
     * @throws BadPaddingException - Prevents Incorrect Padding
     */
    public String encrypt(String Message) throws NoSuchPaddingException, NoSuchAlgorithmException, InvalidKeyException, IllegalBlockSizeException, BadPaddingException {
        String encrptyedMessage = null;
        byte[] ByteMessages = Message.getBytes();
        Encryption = Cipher.getInstance("AES/GCM/NoPadding");
        Encryption.init(Cipher.ENCRYPT_MODE,Key);
        byte [] encryptedBytes = Encryption.doFinal(ByteMessages);
        encrptyedMessage = Base64.getEncoder().encodeToString(encryptedBytes);
        return encrptyedMessage;
    }

    /**
     *
     /** This Method Decrypts an encrypted message using the Private Key and the Block Cipher mode GCM
     *
     * @param EncryptedMessage RSA encrypted Message
     * @param key byte array of the AES Key
     * @return Decrypted Message or the Original Message before Encryption
     * @throws NoSuchPaddingException- Padding does not exist
     * @throws NoSuchAlgorithmException- Encryption Algorithm does not exist
     * @throws InvalidKeyException- Incorrect Key length or encoding
     * @throws IllegalBlockSizeException- Block Cipher size must match
     * @throws BadPaddingException- Prevents Incorrect Padding
     * @throws InvalidAlgorithmParameterException - Wrong Algorithm
     */
    public String Decrypt(String EncryptedMessage,byte [] key) throws NoSuchPaddingException, NoSuchAlgorithmException, InvalidKeyException, IllegalBlockSizeException, BadPaddingException, InvalidAlgorithmParameterException {
        byte [] decryptedBytes = Base64.getDecoder().decode(EncryptedMessage);

        Cipher decryption = Cipher.getInstance("AES/GCM/NoPadding");

        GCMParameterSpec Spec = new GCMParameterSpec(Tlen,Encryption.getIV());
        SecretKey S = new SecretKeySpec(key,"AES");
        decryption.init(Cipher.DECRYPT_MODE,S,Spec);
        byte [] decrypted = decryption.doFinal(decryptedBytes);
        return new String(decrypted);

    }

    /** Accessor for the AES generated key
     *
     * @return
     */
    public SecretKey getKey() {
        return Key;
    }

    public static void main(String [] args) throws NoSuchAlgorithmException, NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException, InvalidKeyException, InvalidAlgorithmParameterException {
        AES N = new AES();
        N.CreateKey();
        String enc = N.encrypt("Hey");
        System.out.println(enc);

    }
}