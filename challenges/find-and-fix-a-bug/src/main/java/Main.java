public class Main {
    public static void main(String[] args) {
        ValidateISBN validator = new ValidateISBN();
        boolean result = validator.checkISBN("9781853260087");
        System.out.println("Is the ISBN valid? " + result);

    }
}