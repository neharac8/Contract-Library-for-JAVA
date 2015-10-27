package aspectesting;
import java.util.function.Function;

import javax.tools.JavaCompiler;

import pl.joegreen.lambdaFromString.classFactory.*;
import pl.joegreen.lambdaFromString.*;
/*import javax.tools.JavaCompiler;
import java.math.BigDecimal;
import java.util.Arrays;
import java.util.function.BiFunction;
import java.util.function.IntBinaryOperator;
import java.util.function.Supplier;
import java.util.stream.IntStream;*/

public class Exam {
	private LambdaFactory factory;
	public static void main(String[] args) {
		// TODO Auto-generated method stub
System.out.println("HELLO WORLDS");
int i = 9;

String str = "i -> i+1";

String str1 = "i -> i <= 5 ";
LambdaFactory factory=LambdaFactory.get();
//Function<Integer, Integer> lambda = factory.createLambdaUnchecked(
	//	str1, new TypeReference<Function<Integer, Integer>>() {});
		//"i -> i+1", new TypeReference<Function<Integer, Integer>>() {});

Function<Integer, Boolean> lambda = factory.createLambdaUnchecked(
		str1, new TypeReference<Function<Integer, Boolean>>() {});
		//"i -> i+1", new TypeReference<Function<Integer, Integer>>() {});

boolean n = lambda.apply(i);

System.out.println(n);
//assertTrue(1 == lambda.apply(0));

	}
	
}
