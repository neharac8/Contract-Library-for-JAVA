package aspectesting;
import java.util.function.Function;

import javax.tools.JavaCompiler;

import pl.joegreen.lambdaFromString.classFactory.*;
import pl.joegreen.lambdaFromString.*;

public class sampleobjectlambdas {
	private static LambdaFactory factory;
	public int salary;
	public static int getSalary()
	{
		//System.out.println("Reacheddd getsalary");
		return 98098;
		
	}
	public static void main(String[] args) 
	{
		
		sampleobjectlambdas pra = new sampleobjectlambdas();
		
		pra.salary = 98098;
		
		 String str2 = "a -> a >106 ";
	      Function<Object, Boolean> lambda = factory.createLambdaUnchecked(
	        		str2, new TypeReference<Function<Object, Boolean>>() {});
	      boolean n = lambda.apply(pra);
	}
}
