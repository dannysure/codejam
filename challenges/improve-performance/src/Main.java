import java.math.BigInteger;
import java.util.List;

public class Main {
    public static void main(String[] args) {

        Long start = System.currentTimeMillis();

        PrimeGenerator primeGenerator = new PrimeGenerator();
        List<BigInteger> results = primeGenerator.getPrimes(100);
        Long end = System.currentTimeMillis();
        System.out.println("The time taken was " + (end - start) + " ms.");
        System.out.println("The first number found was : " + results.get(0));
    }
}