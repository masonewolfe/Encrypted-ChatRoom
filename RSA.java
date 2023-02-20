import javax.crypto.*;
import java.io.IOException;
import java.io.Serializable;
import java.io.UnsupportedEncodingException;
import java.security.*;
import java.util.Base64;

/** This Class is Used to Implement the RSA Algorithm for our Hybrid Encryption
 *
 */
public class RSA {

    private PrivateKey Private;
    private PublicKey Public;

    /** The Constructor is Used to Generate the Key pair for the Client using a key size of 1048 bits
     *  Both the Private key and the Public Key is generated for client using the RSA Algorithm
     * @throws NoSuchAlgorithmException - Encryption Algorithm does not exist
     */
    public RSA() throws NoSuchAlgorithmException {
        KeyPairGenerator Generator = KeyPairGenerator.getInstance("RSA");
        Generator.initialize(1048);
        KeyPair Pair = Generator.generateKeyPair();
        Private = Pair.getPrivate();
        Public = Pair.getPublic();

    }

    /** This Method Encrypts a Message by taking the Bytes of the Message and encrypting it with RSA, Mode of Operation ECB (Electronic Code Book) and the Use of PKCS Padding as the Cipher
     * The Public Key is Used to encrypt the Message
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
        Cipher Encryption = Cipher.getInstance("RSA/ECB/PKCS1Padding");
        Encryption.init(Cipher.ENCRYPT_MODE, Public);
        byte[] encryptedBytes = Encryption.doFinal(ByteMessages);
        encrptyedMessage = Base64.getEncoder().encodeToString(encryptedBytes);
        return encrptyedMessage;
    }

    /** This Method Decrypts an encrypted message using the Private Key and the Block Cipher mode ECB and PKCS Padding
     *
     * @param EncryptedMessage RSA encrypted Message
     * @return Decrypted Message or the Original Message before Encryption
     * @throws NoSuchPaddingException- Padding does not exist
     * @throws NoSuchAlgorithmException- Encryption Algorithm does not exist
     * @throws InvalidKeyException- Incorrect Key length or encoding
     * @throws IllegalBlockSizeException- Block Cipher size must match
     * @throws BadPaddingException- Prevents Incorrect Padding
     * @throws InvalidAlgorithmParameterException - Wrong Algorithm
     * @throws UnsupportedEncodingException - Encoding is not supported
     */
    public String Decrypt(String EncryptedMessage) throws NoSuchPaddingException, NoSuchAlgorithmException, InvalidKeyException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException {
        byte[] decryptedBytes = Base64.getDecoder().decode(EncryptedMessage);
        Cipher decryption = Cipher.getInstance("RSA/ECB/PKCS1Padding");
        decryption.init(Cipher.DECRYPT_MODE, Private);
        byte[] decrypted = decryption.doFinal(decryptedBytes);
        return new String(decrypted, "UTF8");
    }

    /** This Method is used to Decrypt Key Objects
     *
     * @param Object Sealed Object that requires Decryption
     * @return The Object Unsealed using the RSA Private Key
     * @throws NoSuchPaddingException- Padding does not exist
     * @throws NoSuchAlgorithmException- Encryption Algorithm does not exist
     * @throws InvalidKeyException- Incorrect Key length or encoding
     * @throws IllegalBlockSizeException- Block Cipher size must match
     * @throws BadPaddingException- Prevents Incorrect Padding
     * @throws InvalidAlgorithmParameterException - Wrong Algorithm
     * @throws IOException - Used for failed or Interrupted I/O operations
     * @throws ClassNotFoundException - Tries to find a class that exists
     */
    public Serializable DecryptObject(SealedObject Object) throws NoSuchPaddingException, NoSuchAlgorithmException, InvalidKeyException, IllegalBlockSizeException, BadPaddingException, InvalidAlgorithmParameterException, IOException, ClassNotFoundException {
        Cipher decryption = Cipher.getInstance("RSA/ECB/PKCS1Padding");
        decryption.init(Cipher.DECRYPT_MODE, Private);
        Serializable UnsealObject = (Serializable)  Object.getObject(decryption);
        return UnsealObject;
    }

    /** This Method encrypts a Serizilaible Object Using the RSA Public Key
     *
     * @param Object Any Serializer Object that can be encrypted
     * @return The sealed Object or the encrypted Object using the RSA Public Key
     * @throws NoSuchPaddingException- Padding does not exist
     * @throws NoSuchAlgorithmException- Encryption Algorithm does not exist
     * @throws InvalidKeyException- Incorrect Key length or encoding
     * @throws IllegalBlockSizeException- Block Cipher size must match
     * @throws BadPaddingException- Prevents Incorrect Padding
     * @throws IOException - Used for failed or Interrupted I/O operations
     */
    public SealedObject encryptObject(Serializable Object) throws NoSuchPaddingException, NoSuchAlgorithmException, InvalidKeyException, IllegalBlockSizeException, BadPaddingException, IOException {
        Cipher Encryption = Cipher.getInstance("RSA/ECB/PKCS1Padding");
        Encryption.init(Cipher.ENCRYPT_MODE, Public);
        SealedObject sealedObject = new SealedObject(Object,Encryption);
        return sealedObject;
    }

    /** Accessor Method for the Private Key
     *
     * @return the Private Key
     */
    public PrivateKey getPrivate() {
        return Private;
    }

    /** Accessor Method for the Public Key
     *
     * @return the Public Key
     */
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
