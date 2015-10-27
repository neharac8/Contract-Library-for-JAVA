
package aspectesting;

import annotations.Contract;
import annotations.FUNCTIONCHECK;

public class Sample_Contract_find_func {
	
	public static int x=0;
	
	// For empty invariants
	
	@SuppressWarnings("unused")
	@Contract(invariant_cond={},
			  pre_cond={"FUNCTIONCHECK:obj.checking"},
			  post_cond={"FUNCTIONCHECK:obj.checking"},
			  Description="Check Contracts")
	
	public static int methodsum(int sum[],Sample_Contract_find_func obj)
	{
		sum[0] = 100;
		sum[1] = 100123;
		int i=21;
		int var = 8;
		//while(sum < 164)
		//{
		
		//	sum = sum + i;
			//methodsum(sum,obj);
		//}
		//System.out.println("Sum of 1 to ..n is" +sum);
		return sum[0];
		
		
	}
	
	@SuppressWarnings("unused")
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Sample_Contract_find_func par = new Sample_Contract_find_func();
		int sum[]= {1,2};
         int x= methodsum(sum,par);
         //checking(x);
		
          
	}

	//function for aspectJ
	
	@FUNCTIONCHECK(Description="Include functions in conditions")
	public static boolean checking(int sum[],Sample_Contract_find_func obj)
	{
		
		System.out.println("true");
		System.out.println(sum[0]);
		return true;
		
		
		//return 0;
			
	}
	
}
