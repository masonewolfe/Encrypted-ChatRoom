import javax.crypto.Cipher;
import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.util.Random;
import java.util.Base64;

public class RSA {


    class Key {
        public int X; // n Value for the Key
        public int y; // z Value for the Key
        public Key(int n, int z) {
            X = n;
            y = z;
        }


    }

    /** This Method is used to Generate a Private Key based on the previously produced Public key
     *
     * @param e PublicKey's e value
     * @param n PublicKey's n value
     * @param SecondPart the Sigma value found from the PublicKey's p and q values
     * @return A PrivateKey with the PublicKey's e and resulting d values
     */
    public Key GeneratePrivateKey(int e, int n, int SecondPart)
    {
        int d;
        for (int i = 0; i < SecondPart;i++)
        {
            if((i * e)%SecondPart == 1) {
                d = i;
                return new Key(n,d);
            }
        }
        return null;
    }

    /** This is Used to generate the PublicKey using two different prime numbers
     *
     * @param FirstPrime- The First Prime Number used for the Public Key
     * @param SecondPrime - The Second Prime used for the Public Key
     * @return- A Key object with the outputted the FirstPart and the Random generated Prime Number (e)
     */
    public Key GeneratePublicKey(int FirstPrime, int SecondPrime)
    {

        int FirstPart = FirstPrime * SecondPrime;
        int SecondPart = (FirstPrime - 1)*(SecondPrime -1);
        Random Random = new Random();

            while(true){
                int e = Random.nextInt(SecondPart);
                if (FindPrime(e)) {
                    return new Key(FirstPart,e );
                }
            }

    }

    /** This Method is used to determine if a number is prime and returns a boolean flag
     *
     *
     * @param num  the Number to be tested
     * @return A boolean value
     */
    public boolean FindPrime(int num)
    {
        int count=0,i=1;
        while(i<=num)
        {
            if(num%i==0)
            {
                count++;
            }
            i++;
        }
        if(count==2) {
            return true;
        }
        else {
            return false;
        }
    }


    public int GCD(int n1, int n2)
    {
      if (n1 ==0)
      {
          return n2;
      }
      else
        return GCD(n2 % n1,n1);
    }

    /** Encryption Method used to Encrypt a String, For now we use UNICODE method to get a Number. One that number is produced
     *
     * @param Message String Message used
     * @param e The e value from the Public Key
     * @param n The n value both keys should produce and be the same
     * @return a Number for Now
     */
    public BigInteger Encrpyt (String Message, int e, int n)
    {

        BigInteger En = BigInteger.valueOf(Integer.parseInt(Message));
        BigInteger result = En.pow(e);
        result = result.mod(BigInteger.valueOf(n));
        return result;
    }

    /** Decyprtion Method used to decrypt a string, Requires a Number produced from the encyrption
     *
     * @param En Number, in this case a Biginteger used to decyrpt
     * @param d Private Key's d value
     * @param n Universal Key n value which should match
     * @return For Now, Identical Numbers to the Encryption method.
     */
    public String Decrypt(BigInteger En,int d,int n)
    {
        String Message ="";
        // Problem Here with Rounding
        BigInteger M = En.pow(d);
        M = M.mod(BigInteger.valueOf(n));
        Message += M;
        return Message;
    }

    public static void main(String [] args)
    {
        RSA Test = new RSA();
        Key PublicKey = Test.GeneratePublicKey(73,97);
        int SecondPart = (73 - 1)*(97 -1);

        Key PrivateKey = Test.GeneratePrivateKey(PublicKey.y, PublicKey.X,SecondPart );
        System.out.print("n = " + PublicKey.X + "\tz = " + PublicKey.y);
        System.out.print("\nn = " + PrivateKey.X + "\td = " + PrivateKey.y);
        String Message = "23";
        BigInteger EncyrptionNumber = Test.Encrpyt(Message, PublicKey.y, PublicKey.X);
        System.out.println("\nEncrypted Number = " + EncyrptionNumber);
        System.out.println("Decrypted Number = " + Test.Decrypt(EncyrptionNumber, PrivateKey.y, PrivateKey.X));



    }
}
