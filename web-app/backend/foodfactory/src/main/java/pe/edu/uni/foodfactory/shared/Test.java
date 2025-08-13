package pe.edu.uni.foodfactory.shared;

import java.util.Optional;

public class Test {

    public static void main(String[] args) {

        int n1 = 12, n2 = 0;

        Optional<Float> result = division(5, 0);

        result.ifPresentOrElse(
                r -> System.out.println(r),
                () -> System.out.println("No se puede dividir")
        );

        /*
        float r;

        try {
            r = division(n1,n2);
            System.out.println(r);
        } catch (Exception e) {
            System.err.println(e.getMessage());
            r = 0;
        } finally {
            System.out.println("Terminó la ejecución");
        }

         */

    }

    public static Optional<Float> division(int n, int m) {//throws Exception {
        if (m == 0) {
            return Optional.empty();
        }
        return Optional.of((float) n/m);

        /*
        try {

        } catch (Exception e) {
            System.out.println("Error");
            System.err.println(e.getMessage());
        } finally {
            System.out.println("Terminó el proceso");
        }

         */
    }
}
