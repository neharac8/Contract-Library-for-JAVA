package aspectesting;

import java.util.function.Function;

import javax.tools.JavaCompiler;

import pl.joegreen.lambdaFromString.classFactory.*;
import pl.joegreen.lambdaFromString.*;

public class Java8Tester {
	private LambdaFactory factory;
	//@Contract(pre_cond={(int j) -> j>0})
	
	//public static int gh(int j)
	{
		
		
	}
	
   public static void main(String args[]){
      Java8Tester tester = new Java8Tester();
		
      CheckOperation chek = (int a) -> a>0;
      
      int i = 9;
      String str = "i -> i+1";

      String str1 = "i -> i <= 5 ";
      LambdaFactory factory=LambdaFactory.get();
      //Function<Integer, Integer> lambda = factory.createLambdaUnchecked(
      	//	str1, new TypeReference<Function<Integer, Integer>>() {});
      		//"i -> i+1", new TypeReference<Function<Integer, Integer>>() {});

    //  Function<Integer, Boolean> lambda = factory.createLambdaUnchecked(
    //  		str1, new TypeReference<Function<Integer, Boolean>>() {});
      		//"i -> i+1", new TypeReference<Function<Integer, Integer>>() {});

      //boolean n = lambda.apply(i);

      //System.out.println(n);
      
      String str2 = "a -> a >106 ";
      Function<Integer, Boolean> lambda = factory.createLambdaUnchecked(
        		str2, new TypeReference<Function<Integer, Boolean>>() {});
      boolean n = lambda.apply(i);
      MathOperation addition = (int a, int b) -> a + b;
		
     
      MathOperation subtraction = (a, b) -> a - b;
		
      
      MathOperation multiplication = (int a, int b) -> { return a * b; };
		
     
      MathOperation division = (int a, int b) -> a / b;
		
      System.out.println("10 + 5 = " + tester.operate(10, 5, addition));
      System.out.println("10 - 5 = " + tester.operate(10, 5, subtraction));
      System.out.println("10 x 5 = " + tester.operate(10, 5, multiplication));
      System.out.println("10 / 5 = " + tester.operate(10, 5, division));
      System.out.println("10 / 5 :p:p:p= " + tester.chk(10, chek));
      
   }
	
   interface MathOperation {
      int operation(int a, int b);
   }
	
 interface CheckOperation{
	 boolean operation(int a);
 }
	private boolean chk(int a, CheckOperation checkoperation)
	{
		return checkoperation.operation(a);
		
	}
   private int operate(int a, int b, MathOperation mathOperation){
      return mathOperation.operation(a, b);
   }
}