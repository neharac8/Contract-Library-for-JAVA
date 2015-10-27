package aspectesting;
import annotations.ContractLambda;
import aspectesting.Java8Test12.CheckOperation;

public class sammn {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		sammn obj = new sammn();
		boolean d = obj.chk(2);

	}
	@ContractLambda(invariant_cond_lambda={"a>0"},
			  pre_cond_lambda={"var>2","var<200"},
			  post_cond_lambda={"var>0","var>-1"},
			  Description="Check Lambda Expression Contracts")
	 
	 public boolean chk(int a)
		{
			return true;
			
		}
}
