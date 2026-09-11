import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class PrimeGenerator {

    public List<BigInteger> getPrimes(int size) {

        System.out.println("About to find " + size + " primes.");

       List<BigInteger> primes = new ArrayList<>();
        
        for (int i = 0; i < size; i++) {
            primes.add(new BigInteger(2000, new Random()).nextProbablePrime());
        }

        System.out.println("Found all " + primes.size() + " primes.");
        return primes;          
    }
}