import javax.crypto.*;
import javax.crypto.spec.SecretKeySpec;
import java.io.IOException;
import java.io.Serializable;
import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

public class CombinedEncrytpion {
    class Key
    {
        public Key(Serializable key)
        {

        }
    }

    public static void main(String [] args) throws NoSuchAlgorithmException, NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException, InvalidKeyException, InvalidAlgorithmParameterException, IOException, ClassNotFoundException {
        RSA rsa = new RSA();
        AES aes = new AES();
        aes.CreateKey();
        byte [] Key = aes.getKey().getEncoded();

        System.out.println("This is the AES key\t" + new String(Key));
        String AesEncryptedKey = rsa.encrypt(new String(aes.getKey().getEncoded()));

        String AESDecryptedKey = rsa.Decrypt(AesEncryptedKey);
        String Message = "Hello";
        String L = aes.encrypt(Message);
        String K = aes.Decrypt(L,Key);



        System.out.println("This is the RSA encrypted AES Key "+ AesEncryptedKey);
        System.out.println("This is the RSA decrytped Key\t" + AESDecryptedKey);
        System.out.println("This is the decrypted AES Message\t" + K);

    }
}