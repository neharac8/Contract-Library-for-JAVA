
package aspectesting;
import java.util.Hashtable;
import java.util.Scanner;
import java.lang.annotation.*;
import java.lang.reflect.AnnotatedElement;

import annotations.Contract;


@SuppressWarnings("unused")
public class Program_Sum {
	
	@Contract(invariant_cond={"var>0"},
			  pre_cond={"var>2","var<200"},
			  post_cond={"var>0","var>-1"},
			  Description="Check Contracts")

	public static int methodsum(int var)
	{
		int i=1234;
		
			var = var + i;
	
		System.out.println("The results are: ");
		System.out.println("Sum of 1 to ..n is " +var);
		return var;
		
	}

	@Contract(invariant_cond={"var>-1"},
			  pre_cond={"var>1","var<100"},
			  post_cond={"sum>1"},
			  Description="Check Contracts")
	public static int methodproduct(int var)
	{
		int sum=1,i;
		for(i=1;i<=var;i++)
		{
			sum = sum * i;
		}
		System.out.println("Product of 1 to ..n is " +sum);
		return sum;
		
	}
	public static void main(String[] args) {
		
		
          int x= methodsum(8);
          int y = methodproduct(2);
	}

}
