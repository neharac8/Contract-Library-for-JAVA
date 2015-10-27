
package aspectesting;

import annotations.ContractLambda;

public class Java8Test12 {
	public static void main(String args[]){
      Java8Test12 tester = new Java8Test12();
		
      CheckOperation chek = (int a) -> a>0;
      ConcatOperation chekconcat = (String a) -> a!=null;
      
      MathOperation addition = (int a, int b) -> a + b;
		
     
      MathOperation subtraction = (a, b) -> a - b;
		
      
      MathOperation multiplication = (int a, int b) -> { return a * b; };
		
     
      MathOperation division = (int a, int b) -> a / b;
		
      System.out.println("10 + 5 = " + tester.operate(10, 5, addition));
      System.out.println("10 - 5 = " + tester.operate(10, 5, subtraction));
      System.out.println("10 x 5 = " + tester.operate(10, 5, multiplication));
      System.out.println("10 / 5 = " + tester.operate(10, 5, division));
      System.out.println("The check function : " + tester.chk(10));
      System.out.println("The check function with three arguments : " + tester.chk1(10, 12, "kl", chek));
      System.out.println("Parsing string  function : " + tester.chekconcat("Hi", chekconcat));
      
   }
	
   interface MathOperation {
      int operation(int a, int b);
   }
   interface ConcatOperation{
	   boolean operation(String a);
   }
 interface CheckOperation{
	
	 boolean operation(int a);
 }
 
 @ContractLambda(invariant_cond_lambda={"a -> a%2==0"},
		         pre_cond_lambda={"a -> a > 0"},
		         post_cond_lambda={"a -> a==true"},
		         Description="Check Lambda Expression Contracts")
 
 public boolean chk(int a)
	{
	 	if(a>0)
	 	{
		return true;
	 	}
	 	return false;
		
	}
 
 
 @ContractLambda(invariant_cond_lambda={"a -> a%2 == 0"},
         		 pre_cond_lambda={"b -> b > 0"},
                 post_cond_lambda={"c -> c==true"},
                 Description="Check Lambda Expression Contracts")
 
 public boolean chk1(int a,int b, String c, CheckOperation checkoperation)
	{
		return checkoperation.operation(a);
		
	}
 @ContractLambda(invariant_cond_lambda={"a -> a!=null"},
		         pre_cond_lambda={"a -> a!=null"},
	             post_cond_lambda={"a -> a!=null"},
		         Description="Check Lambda Expression Contracts")
 public boolean chekconcat(String a, ConcatOperation concatoperation)
 {
	 return concatoperation.operation(a);
 }
 
 
 @ContractLambda(invariant_cond_lambda={"a -> a>0"},
         		pre_cond_lambda={"b -> b>0"},
         		post_cond_lambda={"a -> a>0"},
         		Description="Check Lambda Expression Contracts")
 
 public int operate(int a, int b, MathOperation mathOperation){
     return mathOperation.operation(a, b);
  }
}