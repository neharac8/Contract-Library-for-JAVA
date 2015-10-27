package aspectesting;

import annotations.Contract;

public class Account {

	public int salary;
	public static String getPosition()
	{
		//System.out.println("Reacheddd getsalary");
		return "fulltime";
		
	}
	public static int getSalary()
	{
		//System.out.println("Reacheddd getsalary");
		return 98098;
		
	}
	public static int getBalance()
	{
		//System.out.println("Reacheddd getsalary");
		return 98;
		
	}

	@Contract(invariant_cond={"accountobj.balance>0"},
			  pre_cond={"accountobj.salary<198098","accountobj.position=='fulltime'"},
			  post_cond={"accountobj.position=='fulltime'"},
			  Description="Check Contracts")
	
	public static String amountwithdrawal(Account accountobj,String var,int checxk)
	{
		//System.out.println("The var is"+var);
		return "fulltime";
	}
		public static void main(String[] args) 
		{
			
			Account pra = new Account();
			Employee emp = new Employee();
			pra.salary = 98098;
			pra.salary = 98098;
			
			
			String var = "fulltime";
			int checxk = 100;
			System.out.println(amountwithdrawal(pra,var,checxk));
			emp.position = "fulltime";
			//System.out.println(Account.getSalary());
		    //System.out.println(emp.position);
			//System.out.println(emp.position);
			//System.out.println(pra.salary);

		}

	}

	class Employee {
		
		String position;
		
		
	}


