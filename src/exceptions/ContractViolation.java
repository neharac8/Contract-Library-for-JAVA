package exceptions;

@SuppressWarnings("serial")
public class ContractViolation extends Exception{
	
		public ContractViolation(String message)
		{
			super(message);
			System.exit(1);
		}
		
	}

