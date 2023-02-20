import javax.crypto.*;
import javax.crypto.spec.SecretKeySpec;
import java.io.IOException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

public class CombinedEncryption {
    public static void main(String [] args) throws NoSuchAlgorithmException, NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException, InvalidKeyException, InvalidAlgorithmParameterException, IOException, ClassNotFoundException {
        //Initialize Objects
        // RSA object will generate the Keypair within its Constructor
        RSA rsa = new RSA();
        AES aes = new AES();

        //Generate the AES Key
        aes.CreateKey();
        // Convert AES to a byte Array
        byte [] AESKey =  Base64.getEncoder().encode(aes.getKey().getEncoded());
        System.out.println("This is the Original AES key:\t" + new String(AESKey));


        // Encrypt the AES Key as a String using the RSA Public Key
        // In the Future this will be the Sender's Logic for sending a Message
        String AesEncryptedKey = rsa.encrypt(new String(AESKey));
        String Message = "Hello from Group 2";
        String AESEncryptedMessage = aes.encrypt(Message);



        // Decrypt the AES key using the RSA Generated Private Key and Decrypting the AES encrypted Message with the Decrypted AES Key
        String AESDecryptedKeyString = rsa.Decrypt(AesEncryptedKey);


        // Reinitializes the AES Key from the RSA decryption
        byte[] decodedKey = Base64.getDecoder().decode(AESDecryptedKeyString);
        SecretKey DecryptedAESKey = new SecretKeySpec(decodedKey,"AES");


        // Uses the decrypted AES key to decrypt the AES encrypted Message
        String AESDecryptedMessage = aes.Decrypt(AESEncryptedMessage, DecryptedAESKey.getEncoded());






        System.out.println("This is the RSA encrypted AES Key: "+ AesEncryptedKey);
        System.out.println("This is the RSA decrypted AES Key:\t" + AESDecryptedKeyString);
        System.out.println("This is the decrypted AES Message:\t" + AESDecryptedMessage);

    }
}