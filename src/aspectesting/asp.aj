package aspectesting;

import java.lang.reflect.Method;
import java.lang.annotation.*;
import java.util.Arrays;
import java.util.Objects;
import java.util.function.Function;

import org.aspectj.lang.Signature;
import org.aspectj.lang.reflect.*;

import exceptions.ContractViolation;
import annotations.Contract;

import javax.tools.JavaCompiler;

import annotations.ContractLambda;
import aspectesting.Java8Tester.CheckOperation;
import aspectesting.Java8Tester.MathOperation;
import pl.joegreen.lambdaFromString.classFactory.*;
import pl.joegreen.lambdaFromString.*;

public aspect asp {
	
	
pointcut function() : execution(* *(..));

	before() : function()
	{
		/*
		The flag values are:
		objflag = 1 : For object contracts
		flag = 1 :For > symbol
		flag = 2 :For < symbol
		flag = 3 :For >= symbol
		flag = 4 :For <= symbol
		flag = 5 :For != symbol
		flag = 6 :For == symbol
		intflag = 0 :For normal integers, ex: num < 0
		intflag =1 : For argument integers, ex: num < val, where val is an argument
		stringflag = 0: For string comparisons like, ex: position = "Full time"
		stringflag =1 : For string comparisons like, ex: position = string_val where string_val is an argument
		*/
		int flag = 0;
		int objflag =0;
		int intflag=0;
		int stringflag=0;
		
		int stringflagindex = 0;
		
		
		Signature sig = thisJoinPoint.getSignature();
		Method method = ((MethodSignature)sig).getMethod();
		
		
		//Annotations for pre conditions
		
		Annotation[] annost = method.getDeclaredAnnotations();
		LambdaFactory factory=LambdaFactory.get();
		
	    try
	    {
    
		for(Annotation annotation : annost)
		{
	    if(annost == null)
		{
				
		}
	    else if(annotation instanceof Contract)
	    {
	    	System.out.println("");
	    	System.out.println("Checking for Contracts for the method : " +sig.getName());
	    	
	    	Contract annos = (Contract) annotation;
	    	String[] invariant_cond = annos.invariant_cond();
	    	String[] pre_cond = annos.pre_cond();
	    
	    	if(invariant_cond.length>=1)
	    	{
	    	System.out.println("");
			System.out.println("Checking for Invariants ");
			
			
		    System.out.println( "The Invariant conditions are : " + Arrays.asList(invariant_cond));
		  
		    System.out.println("The Total num of Invariant conditions are:"+invariant_cond.length);
		       
		   
		    //To check if the condition has an object which is of the form Classname.object for bean property.
		    
		    int t;
		    for(t=0;t<invariant_cond.length;t++)
		    {
		    	if(invariant_cond[t].contains("."))
		        {
		    		objflag=1;
		        }
		    }
		    //for loop to locate the symbols in the condition
		    
		    for(t=0;t<invariant_cond.length;t++)
		    {
		    if(invariant_cond[t].contains(">="))
		    {
		    	flag=3;
		        if(invariant_cond[t].contains("."))
			    {
		        	objflag=1;
		        	//System.out.println("The argument has object contracts");
		        	String foo=invariant_cond[t];
		        	System.out.println(invariant_cond[t]);
		        	int u=0;
		        	int intflagindex=0;
		        	objflag=1;
			    
		        	String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
		        	Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
		        	Object[] num1 = thisJoinPoint.getArgs();
		        	String[] result=foo.split("\\>="); 
		        	String[] parts = foo.split(">=");
		        	String part1 = parts[0].trim(); 
		        	String part2 = parts[1].trim(); 
				        
		        	for (u = 0; u < num1.length; u++) 
		        	{
		        		String part3 = names[u].trim();
		        		if(part2.equals(part3))
		        		{
		        			intflag = 1;	
		        			intflagindex = u;
		        		}
		        		else
		        		{
		        			intflag = 0;
		        		}
		        	}
		        	int i;
		        	String className = null;
				    String classname=null;
				    int gh=0;
				    
				    for(gh=0;gh<num1.length;gh++)
		  		       {
		  		        
		  		   	  className = types[gh].getName();
		  		   	  boolean objcompareint;
		  		    boolean objcomparestring;
		  		   	  objcompareint = Objects.equals(className, "int");
		  		   	objcomparestring = Objects.equals(className, "java.lang.String");
		  		   	
		  		    	 if(objcompareint == true && objcomparestring == false)
		  		    	 {
		  		    		  
		  		    	  }
		  		    	 else if(objcompareint == false && objcomparestring == true)
		  		    	 {
		  		    		 
		  		    	 }
		  		    	 else
		  		    	 {
		  		    		 classname = className;
		  		    	 }
		  		       }
				    
				   
				    String parsecondition = invariant_cond[t];
				   
				      
				    int condparsefrom=0;
				    int condparseto=0;
				    i=0;
				    for(int parseindex=0;parseindex<parsecondition.length();parseindex++)
				    {
				    	char ch = parsecondition.charAt(parseindex);
				    	if(ch == '.')
				    	{
				    		condparsefrom = parseindex+1;
				    	}
				    	if(ch == '>' || ch == '<' || ch =='!' || ch == '=')
				    	{
				    		condparseto = parseindex-1;
				    		int hj = parseindex;
				    		char ch1 = parsecondition.charAt(hj);
				    		if(ch1 == '=')
				    		{
				    			condparseto = parseindex-2;
				    		}
				    	}
				     }
				        
				     char arrsd[] = new char[condparseto - condparsefrom +1];
				   
				     int j=1;
				     arrsd[0] = Character.toUpperCase(parsecondition.charAt(condparsefrom));
				     for(int lk=condparsefrom+1;lk<condparseto+1;lk++)
				     {
				    	 arrsd[j] = parsecondition.charAt(lk);
				    	 j++;
				     }
				     
				     String ab = new String(arrsd);
				     String s2 = classname + "." + "get"+ab+"()";
				     String s3 = "get" + ab;
				     Object cls = Class.forName(classname).newInstance(); 
				     Class c = cls.getClass();
				     
				     Method[] meths = c.getDeclaredMethods();
				     if (meths.length != 0) 
				     {
				    	 for (Method m : meths)
				         {
				    		 int comparisonResult = s3.compareTo(m.getName());
				    		 if(comparisonResult == 0)
				    		 {
				    			 Object bbb = m.invoke(cls);
				    			 int numb = Integer.parseInt( bbb.toString() );
				    			 int dis = t+1;
				    			 if(intflag == 0 && numb >= Integer.parseInt(part2.trim()))
				    			 {
								 System.out.println("The Invariant : " +dis+ " is correct");
								 }
			        	         else if(intflag == 1 && numb >= (Integer)num1[intflagindex])
			        		     {
			        	        	 System.out.println("The Invariant : " +dis+ " is correct");
								 }
								 else
								 {
									 System.out.println("INVARIANT VIOLATION");
									 System.out.println("INVARIANT CONDITION : " +dis+ " IS WRONG");
									 throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
								 }
				             }//end of "if"
				        }//end for "for" loop
				      }//end for "if"
				      else 
				      {
				    	  System.out.println("  -- no methods --%n");
				      }  
				 }//end of "if" containing "."
		        		
		         else
		         {
		         int i=0;
				 String foo=invariant_cond[t];
				 
				 //Split the string to get the variable and result[0] has var,result[1] has 0. 
				 String[] result=foo.split(">="); 
				    		    		
				 //Split the string to get the variable and result[0] has var,result[1] has 0. 
				 Object[] num1 = thisJoinPoint.getArgs();
				    				
				 String parsecondition = foo;
				 int condparsefrom=0;
				 int condparseto=0;
				 int hj=0;
				 i=0;
				 int parseindex = 0;
				 for(parseindex=0;parseindex<parsecondition.length();parseindex++)
				 {
				 char ch = parsecondition.charAt(parseindex);
				 if(ch == '>' || ch == '<' || ch =='!' || ch == '=')
				 {
					 condparseto = parseindex-1;
					 hj = parseindex+1;
					 char ch1 = parsecondition.charAt(hj);
					 if(ch1 == '=')
					 {
					 condparseto = hj+1;
					 }
				 }
				 }
				 int condparsetoult = parseindex-1;
				 int ju=0;
				 char arrsd[] = new char[condparsetoult-condparseto];
				 for(int lk=hj;lk<parsecondition.length();lk++)
				 {
					 arrsd[ju] = parsecondition.charAt(lk);
					 ju++;
				 }
				 String ab = new String(arrsd);
				 String part1 = result[0].trim(); 
				 String part2 = ab.trim();
				 result[1] = ab.trim();
						        	
				 int wl;
				 int wr;
				 int wl1=0;
				 int wr1=0;
				 int occurnceleft = 0;
				 int occurncetypeleft = 0;
				 int occurnceright = 0;
				 int occurncetyperight = 0;
				 int leftside=0;
				 int rightside=0;
				    				
				 String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
				 Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
				    			    
				 for (wl = 0; wl < num1.length; wl++) 
				 {
					 if(part1.equals(names[wl]))
					 {
						 occurnceleft = 1;
						 wl1=wl;
				    			    		  
						 if(types[wl].getName().equals("int"))
						 {
							 occurncetypeleft=1;
						 }
					 }
				 }//end of "for" loop
				    			      
				 for (wr = 0; wr < num1.length; wr++) 
				 {	  
				 if(part2.equals(names[wr]))
				 {
					 occurnceright = 1;
				     if(types[wr].getName().equals("int"))
				     {
				    	 occurncetyperight = 1;
				     }
				 }
				 } //end of "for" loop
				    			     
				 if(occurnceleft == 1 && occurncetypeleft == 1)
				 {
				 if(occurnceright == 1 && occurncetyperight == 1)
				 {
					 leftside=(Integer)num1[wl1];
					 rightside = (Integer) (num1[wr1]);
				 }
				 else if(occurnceright == 0 && occurncetyperight == 0)
				 {
					 leftside=(Integer)num1[wl1];
					 rightside = Integer.parseInt(result[1]);
				    				    			 
				 }
				 else
				 {
				    			    			  
				 }
				 }//end of "if"
				    			    	  
				 else { }
				 int n=i;
				 int count=n+1;
				 int dis = t+1;
			     if(leftside >= rightside)
				 {
			    	 System.out.println("The Invariant condition: " +dis+ "  is correct");
				 }
				 else
				 {
					 System.out.println("INVARIANT VIOLATION");
					 System.out.println("INVARIANT CONDITION : " +dis+ " IS WRONG");
					 throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
				 }
				 }//end of "else"
		        		
		    }//end of "else of >= "
		    
		    else if(invariant_cond[t].contains(">"))
		    {
		    	flag=1;
		    	if(invariant_cond[t].contains("."))
		    	{
		    		//System.out.println("The argument has object contracts");
				    String foo=invariant_cond[t];
					int u=0;
					int intflagindex=0;
		        	objflag=1;
			        
					Object[] num1 = thisJoinPoint.getArgs();
					String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
					Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
							        
					String[] result=foo.split("\\>"); 
					String[] parts = foo.split(">");
					String part1 = parts[0].trim(); 
					String part2 = parts[1].trim();
						        
					for (u = 0; u < num1.length; u++) 
					{
						String part3 = names[u].trim();
						if(part2.equals(part3))
						{
							intflag = 1;	
							intflagindex = u;
						}
						else
						{
							intflag = 0;
						}
					}
					        	
					int i;	         
					
					String classname=null;
					int gh=0;
					String className = null;
		  	          for(gh=0;gh<num1.length;gh++)
		  		       {
		  		        
		  		   	  className = types[gh].getName();
		  		   	  boolean objcompareint;
		  		    boolean objcomparestring;
		  		   	  objcompareint = Objects.equals(className, "int");
		  		   	objcomparestring = Objects.equals(className, "java.lang.String");
		  		   	
		  		    	 if(objcompareint == true && objcomparestring == false)
		  		    	 {
		  		    		  
		  		    	  }
		  		    	 else if(objcompareint == false && objcomparestring == true)
		  		    	 {
		  		    		 
		  		    	 }
		  		    	 else
		  		    	 {
		  		    		 classname = className;
		  		    	 }
		  		       }
					String parsecondition = invariant_cond[t];
					int condparsefrom=0;
					int condparseto=0;
					i=0;
					for(int parseindex=0;parseindex<parsecondition.length();parseindex++)
					{
						char ch = parsecondition.charAt(parseindex);
						if(ch == '.')
						{
							condparsefrom = parseindex+1;
						}
						if(ch == '>' || ch == '<' || ch =='!' || ch == '=')
						{
							condparseto = parseindex-1;
						}
					 }
						        
					 char arrsd[] = new char[condparseto - condparsefrom +1];
					 int j=1;
					 arrsd[0] = Character.toUpperCase(parsecondition.charAt(condparsefrom));
					 for(int lk=condparsefrom+1;lk<condparseto+1;lk++)
					 {
						 arrsd[j] = parsecondition.charAt(lk);
						 j++;
					 }
					 String ab = new String(arrsd);
					 String s2 = classname + "." + "get"+ab+"()";
					 String s3 = "get" + ab;
					 Object cls = Class.forName(classname).newInstance(); 
					 Class c = cls.getClass();
					 Method[] meths = c.getDeclaredMethods();
					 if (meths.length != 0) 
					 {
					 for (Method m : meths)
					 {
					 int comparisonResult = s3.compareTo(m.getName());
					 if(comparisonResult == 0)
					 {
						 Object bbb = m.invoke(cls);
						 
						 int numb = Integer.parseInt( bbb.toString() );
						 int dis = t+1;
						 if(intflag == 0 && numb > Integer.parseInt(part2.trim()))
						 {
							 System.out.println("The Invariant condition : " +dis+ " is correct");
						 }
						 else if(intflag == 1 && numb > (Integer)num1[intflagindex])
						 {
							 System.out.println("The Invariant condition : " +dis+ "is correct");
						 }
						 else
						 {
							 System.out.println("INVARIANT VIOLATION");
							 System.out.println("INVARIANT CONDITION : " +dis+ " IS WRONG");
							 throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
						 }
					  }//close for "if(comparisonResult == 0)
					  }//close for "Method m: meths"
					  }//close for "meths.length!=0"
					  else 
					  {
						  System.out.println("  -- no methods --%n");
					  }  
				 }//close of if "contains[.]"
		         else
		         {
		         int i=0;
				 String foo=invariant_cond[t];
				    			        
				 //Split the string to get the variable and result[0] has var,result[1] has 0. 
				 String[] result=foo.split(">"); 
				    		    		
				 //Split the string to get the variable and result[0] has var,result[1] has 0. 
				 Object[] num1 = thisJoinPoint.getArgs();
				    				
				 String part1 = result[0].trim();
				 String part2 = result[1].trim();
				    				
				 int wl;
				 int wr;
				 int wl1=0;
				 int wr1=0;
				 int occurnceleft = 0;
				 int occurncetypeleft = 0;
				 int occurnceright = 0;
				 int occurncetyperight = 0;
				 int leftside=0;
				 int rightside=0;
				    				
				 String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
				 Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
				    			    
				 for (wl = 0; wl < num1.length; wl++) 
				 {
				 if(part1.equals(names[wl]))
				 {
					 occurnceleft = 1;
				     wl1=wl;
				     if(types[wl].getName().equals("int"))
				     {
				    	 occurncetypeleft=1;
				     }
				 }
				 }
				 for (wr = 0; wr < num1.length; wr++) 
				 {	  
					 if(part2.equals(names[wr]))
				     {
						 occurnceright = 1;
				    	 if(types[wr].getName().equals("int"))
				    	 {
				    		 occurncetyperight = 1;
				    	 }
				     }
				 } 
				 if(occurnceleft == 1 && occurncetypeleft == 1)
				 {
				 if(occurnceright == 1 && occurncetyperight == 1)
				 {
					 leftside=(Integer)num1[wl1];
				     rightside = (Integer) (num1[wr1]);
				 }
				 else if(occurnceright == 0 && occurncetyperight == 0)
				 {
					 leftside=(Integer)num1[wl1];
				     rightside = Integer.parseInt(result[1]);
				 }
				 else
				 {
				 }
				 }
				 else 
				 {
				 }
				 int n=i;
				 int count=n+1;
				 int dis = t+1;
				 
				 if(leftside > rightside)
				 {
					 System.out.println("The Invariant condition:" +dis+ " is correct");
				 }
				 else
				 {
					 System.out.println("INVARIANT VIOLATION");
					 System.out.println("INVARIANT CONDITION : " +dis+ " IS WRONG");
					 throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
				 }
				}//close of "else"
    	    }// close of "invariant_cond[t].contains(">")"	
		    
		    else if(invariant_cond[t].contains("<="))
		    {
		    	flag=4;
		        if(invariant_cond[t].contains("."))
			    {
		        	objflag=1;
			        //System.out.println("The argument has object contracts");
					String foo=invariant_cond[t];
				    int u=0;
				    int intflagindex=0;
			        objflag=1;
				        		
				    String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
					Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
					Object[] num1 = thisJoinPoint.getArgs();
					    
					String[] result=foo.split("\\<="); 
				    String[] parts = foo.split("<=");
			        String part1 = parts[0].trim(); 
			        String part2 = parts[1].trim(); 
				        
			        for (u = 0; u < num1.length; u++) 
			        {
			        	String part3 = names[u].trim();
					    if(part2.equals(part3))
					    {
					    	intflag = 1;	
					    	intflagindex = u;
					    }
					    else
					    {
					    	intflag = 0;
					    }
			        }
			        int i;
				    String classname=null;
				    int gh=0;
				    String className = null;
		  	          for(gh=0;gh<num1.length;gh++)
		  		       {
		  		        
		  		   	  className = types[gh].getName();
		  		   	  boolean objcompareint;
		  		    boolean objcomparestring;
		  		   	  objcompareint = Objects.equals(className, "int");
		  		   	objcomparestring = Objects.equals(className, "java.lang.String");
		  		   	
		  		    	 if(objcompareint == true && objcomparestring == false)
		  		    	 {
		  		    		  
		  		    	  }
		  		    	 else if(objcompareint == false && objcomparestring == true)
		  		    	 {
		  		    		 
		  		    	 }
		  		    	 else
		  		    	 {
		  		    		 classname = className;
		  		    	 }
		  		       }
				    String parsecondition = invariant_cond[t];
				        
				    int condparsefrom=0;
				    int condparseto=0;
				    i=0;
				    for(int parseindex=0;parseindex<parsecondition.length();parseindex++)
				    {
				    	char ch = parsecondition.charAt(parseindex);
				    	if(ch == '.')
				    	{
				    		condparsefrom = parseindex+1;
				    	}
				    	if(ch == '>' || ch == '<' || ch =='!' || ch == '=')
				    	{
				    		condparseto = parseindex-1;
				    		int hj = parseindex;
				    		char ch1 = parsecondition.charAt(hj);
				    		if(ch1 == '=')
				    		{
				    			condparseto = parseindex-2;
				    		}
				    	}
				     }//close of "for" loop
				     
				     char arrsd[] = new char[condparseto - condparsefrom +1];
				     int j=1;
				     arrsd[0] = Character.toUpperCase(parsecondition.charAt(condparsefrom));
				     for(int lk=condparsefrom+1;lk<condparseto+1;lk++)
				     {
				    	 arrsd[j] = parsecondition.charAt(lk);
				    	 j++;
				     }
				     String ab = new String(arrsd);
				     String s2 = classname + "." + "get"+ab+"()";
				     String s3 = "get" + ab;
				     Object cls = Class.forName(classname).newInstance(); 
				     Class c = cls.getClass();
				     Method[] meths = c.getDeclaredMethods();
				       
				     if (meths.length != 0) 
				     {
				     for (Method m : meths)
				     {
				    	 int comparisonResult = s3.compareTo(m.getName());
				         if(comparisonResult == 0)
				         {
				        	 Object bbb = m.invoke(cls);
				        	 int numb = Integer.parseInt( bbb.toString() );
				        	 int dis = t+1;
				        	 if(intflag == 0 && numb <= Integer.parseInt(part2.trim()))
							 {
				        		 System.out.println("The Invariant condition : " +dis+ "is correct");
							 }
				        	 else if(intflag == 1 && numb <= (Integer)num1[intflagindex])
							 {
				        		 System.out.println("The Invariant condition : " +dis+ " is correct");
							 }
							 else
							 {
								 System.out.println("INVARIANT VIOLATION");
								 System.out.println("INVARIANT CONDITION : " +dis+ "IS WRONG");
								 throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
							 }
				           }//end of "comparisonResult==0"
				      }//end of "for"
				      }//end of "if"
				      else 
				      {
				    	  System.out.println("  -- no methods --%n");
				      }  
	            }//end of invariant_cond[t].contains(".")
		        else
		        {
		        	int i=0;
		        	String foo=invariant_cond[t];
				    			        
				    //Split the string to get the variable and result[0] has var,result[1] has 0. 
				    String[] result=foo.split("<="); 
				    		    		
				    //Split the string to get the variable and result[0] has var,result[1] has 0. 
				    Object[] num1 = thisJoinPoint.getArgs();
				    				
				    String parsecondition = foo;
								      
					int condparsefrom=0;
					int condparseto=0;
					int hj=0;
					i=0;
				    int parseindex = 0;
					for(parseindex=0;parseindex<parsecondition.length();parseindex++)
					{
						char ch = parsecondition.charAt(parseindex);
				    	if(ch == '>' || ch == '<' || ch =='!' || ch == '=')
						{
				    		condparseto = parseindex-1;
							hj = parseindex+1;
							char ch1 = parsecondition.charAt(hj);
							if(ch1 == '=')
							{
								condparseto = hj+1;
							}
					     }
					 }
					 int condparsetoult = parseindex-1;
				     int ju=0;
				     char arrsd[] = new char[condparsetoult-condparseto];
				     for(int lk=hj;lk<parsecondition.length();lk++)
					 {
				    	 arrsd[ju] = parsecondition.charAt(lk);
						 ju++;
					 }
					 String ab = new String(arrsd);
							      
				     String part1 = result[0].trim(); 
				     String part2 = ab.trim();
					 result[1] = ab.trim();
						        	
				     int wl;
				     int wr;
				     int wl1=0;
				     int wr1=0;
				     int occurnceleft = 0;
				     int occurncetypeleft = 0;
				     int occurnceright = 0;
				     int occurncetyperight = 0;
				     int leftside=0;
				     int rightside=0;
				    				
				     String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
				     Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
				    			    
				     for (wl = 0; wl < num1.length; wl++) 
				     {
				    	 if(part1.equals(names[wl]))
				    	 {
				    		 occurnceleft = 1;
				    		 wl1=wl;
				    		 if(types[wl].getName().equals("int"))
				    		 {
				    			 occurncetypeleft=1;
				    		 }
				    	 }
				      }
				    			      
				     for (wr = 0; wr < num1.length; wr++) 
				     {	  
				    	 if(part2.equals(names[wr]))
				    	 {
				    		 occurnceright = 1;
				    		 if(types[wr].getName().equals("int"))
				    		 {
				    			 occurncetyperight = 1;
				    		 }
				    	 }
				     } 
				    			     
				    if(occurnceleft == 1 && occurncetypeleft == 1)
				    {
				    	if(occurnceright == 1 && occurncetyperight == 1)
				    	{
				    		leftside=(Integer)num1[wl1];
				    		rightside = (Integer) (num1[wr1]);
				    	}
				    	else if(occurnceright == 0 && occurncetyperight == 0)
				    	{
				    		leftside=(Integer)num1[wl1];
				    		rightside = Integer.parseInt(result[1]);
				        }
				    	else
				    	{
				    	}
				     }
				     else 
				     {
				     }
				     int n=i;
				     int count=n+1;
				     int dis = t+1;
				     if(leftside <= rightside)
				     {
				    	 System.out.println("The Invariant condition:"+dis+"  is correct");
				     }
				     else
				     {
				    	 System.out.println("INVARIANT VIOLATION");
				    	 System.out.println("INVARIANT CONDITION : " +dis+ " IS WRONG");
				    	 throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
				     }
			    }//end of "else"
		  }// end of "else if invariant_cond[t].contains("<=")
		          	
		  else if(invariant_cond[t].contains("<"))
		  {
			  flag=2;
		      if(invariant_cond[t].contains("."))
			  {
		    	 
		    	  objflag=1;
			      //System.out.println("The argument has object contracts");
				  String foo=invariant_cond[t];
				  int u=0;
				  int intflagindex=0;
		          objflag=1;
			      Object[] num1 = thisJoinPoint.getArgs();
				  String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
				  Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
					        
				  String[] result=foo.split("\\<"); 
				  String[] parts = foo.split("<");
			      String part1 = parts[0].trim(); 
			      String part2 = parts[1].trim(); 
				        
			      for (u = 0; u < num1.length; u++) 
			      {
			    	  String part3 = names[u].trim();
					  if(part2.equals(part3))
					  {
						  intflag = 1;	
					      intflagindex = u;
					  }
					  else
					  {
						  intflag = 0;
					  }
			       }
			     
			       int i;
				   String classname=null;
				   int gh=0;
				   String className = null;
		  	          for(gh=0;gh<num1.length;gh++)
		  		       {
		  		        
		  		   	  className = types[gh].getName();
		  		   	  boolean objcompareint;
		  		    boolean objcomparestring;
		  		   	  objcompareint = Objects.equals(className, "int");
		  		   	objcomparestring = Objects.equals(className, "java.lang.String");
		  		   	
		  		    	 if(objcompareint == true && objcomparestring == false)
		  		    	 {
		  		    		  
		  		    	  }
		  		    	 else if(objcompareint == false && objcomparestring == true)
		  		    	 {
		  		    		 
		  		    	 }
		  		    	 else
		  		    	 {
		  		    		 classname = className;
		  		    	 }
		  		       }
				   String parsecondition = invariant_cond[t];
				   int condparsefrom=0;
				   int condparseto=0;
				   i=0;
				   for(int parseindex=0;parseindex<parsecondition.length();parseindex++)
				   {
					   char ch = parsecondition.charAt(parseindex);
				       if(ch == '.')
				       {
				    	   condparsefrom = parseindex+1;
				       }
				       if(ch == '>' || ch == '<' || ch =='!' || ch == '=')
				       {
				    	   condparseto = parseindex-1;
				       }
				   }
				   char arrsd[] = new char[condparseto - condparsefrom +1];
				   int j=1;
				   arrsd[0] = Character.toUpperCase(parsecondition.charAt(condparsefrom));
				   for(int lk=condparsefrom+1;lk<condparseto+1;lk++)
				   {
					   arrsd[j] = parsecondition.charAt(lk);
				       j++;
				   }
				   String ab = new String(arrsd);
				  
				   String s2 = classname + "." + "get"+ab+"()";
				   String s3 = "get" + ab;
				      
				   
				   Object cls = Class.forName(classname).newInstance(); 
				   Class c = cls.getClass();
				   Method[] meths = c.getDeclaredMethods();
				   if (meths.length != 0) 
				   {
					   for (Method m : meths)
				       {
						   
						   int comparisonResult = (s3.trim()).compareTo(m.getName());
						 
						   if(comparisonResult == 0)
				           {
							  
							   Object bbb = m.invoke(cls);
							   //int numb = Integer.parseInt( bbb.toString());
							   int numb = (Integer) bbb;
				        	   int dis = t+1;
				        	  
				        	   if(intflag == 0 && numb < Integer.parseInt(part2.trim()))
							   {
									System.out.println("The Invariant condition : " +dis+ " is correct");
							   }
				        	   else if(intflag == 1 && numb < (Integer)num1[intflagindex])
							   {
									System.out.println("The Invariant condition : " +dis+ " is correct");
							   }
				        	   else
							   {
									System.out.println("INVARIANT VIOLATION");
									System.out.println("INVARIANT CONDITION : " +dis+ " IS WRONG");
									throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
							   }
				            }//end of if comparisonResult==0
				        }
				     }
				     else 
				     {
				    	 System.out.println("  -- no methods --%n");
				     }  
			  }//the if for invariant_cond[t].contains(.)
		      else
			  {
		    	  int i=0;
				  String foo=invariant_cond[t];
					    			        
				  //Split the string to get the variable and result[0] has var,result[1] has 0. 
				  String[] result=foo.split("<"); 
					    		    		
				  //Split the string to get the variable and result[0] has var,result[1] has 0. 
				  Object[] num1 = thisJoinPoint.getArgs();
					    				
				  String part1 = result[0].trim(); 
				  String part2 = result[1].trim(); 
					    				
				  int wl;
				  int wr;
				  int wl1=0;
				  int wr1=0;
				  int occurnceleft = 0;
				  int occurncetypeleft = 0;
				  int occurnceright = 0;
				  int occurncetyperight = 0;
				  int leftside=0;
				  int rightside=0;
					    				
				  String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
				  Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
					    			    
				  for (wl = 0; wl < num1.length; wl++) 
				  {
					  if(part1.equals(names[wl]))
					  {
						  occurnceleft = 1;
					      wl1=wl;
					      if(types[wl].getName().equals("int"))
					      {
					    	  occurncetypeleft=1;
					      }
					   }
				   }
				   for (wr = 0; wr < num1.length; wr++) 
				   {	  
					   if(part2.equals(names[wr]))
					   {
						   occurnceright = 1;
					       if(types[wr].getName().equals("int"))
					       {
					    	   occurncetyperight = 1;
					       }
					    }
					} 
					if(occurnceleft == 1 && occurncetypeleft == 1)
					{
						if(occurnceright == 1 && occurncetyperight == 1)
					    {
							leftside=(Integer)num1[wl1];
					    	rightside = (Integer) (num1[wr1]);
					    }
					    else if(occurnceright == 0 && occurncetyperight == 0)
					    {
					    	leftside=(Integer)num1[wl1];
					    	rightside = Integer.parseInt(result[1]);
					    }
					    else
					    {
					    }
					 }
					 else
					 {
					    			    		  
					 }
					 int n=i;
					 int count=n+1;
					 int dis = t+1;
					 if(leftside < rightside)
					 {
						 System.out.println("The Invariant condition:"+dis+"  is correct");
					 }
					 else
					 {
						 System.out.println("INVARIANT VIOLATION");
						 System.out.println("INVARIANT CONDITION : " +dis+ " IS WRONG");
						 throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
					 }
					    			       	
		       }//end of else
		        			
		  }// end of else if contains "<"
		  else if(invariant_cond[t].contains("!="))
		  {
			  flag=5;
		      if(invariant_cond[t].contains("."))
			  {
		    	  objflag=1;
			      //System.out.println("The argument has object contracts");
				  String foo=invariant_cond[t];
				  int u=0;
				  int intflagindex=0;
			      objflag=1;
				        		
				  Object[] num1 = thisJoinPoint.getArgs();
				  String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
				  Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
				  
				  String[] result=foo.split("\\!="); 
				  String[] parts = foo.split("!=");
			      String part1 = parts[0].trim(); 
			      String part2 = parts[1].trim(); 
				        
			      int gh=0;
			      for (u = 0; u < num1.length; u++) 
			      {
			    	  String part3 = names[u].trim();
					  if(part2.equals(part3))
					  {
						  intflag = 1;	
						  intflagindex = u;
					  }
					  else if(types[u].getName().equals("String"))
					  {
						  stringflag = 1;
						  stringflagindex=u;
					  }
					  else
					  {
						  intflag = 0;
					  }
			       }
			        	
			       int i;
				   String classname=null;
				   gh=0;
				   String className = null;
		  	          for(gh=0;gh<num1.length;gh++)
		  		       {
		  		        
		  		   	  className = types[gh].getName();
		  		   	  boolean objcompareint;
		  		    boolean objcomparestring;
		  		   	  objcompareint = Objects.equals(className, "int");
		  		   	objcomparestring = Objects.equals(className, "java.lang.String");
		  		   	
		  		    	 if(objcompareint == true && objcomparestring == false)
		  		    	 {
		  		    		  
		  		    	  }
		  		    	 else if(objcompareint == false && objcomparestring == true)
		  		    	 {
		  		    		 
		  		    	 }
		  		    	 else
		  		    	 {
		  		    		 classname = className;
		  		    	 }
		  		       }
				   String parsecondition = invariant_cond[t];
				        
				   int condparsefrom=0;
				   int condparseto=0;
				   i=0;
				   for(int parseindex=0;parseindex<parsecondition.length();parseindex++)
				   {
					   char ch = parsecondition.charAt(parseindex);
				       if(ch == '.')
				       {
				    	   condparsefrom = parseindex+1;
				       }
				       if(ch == '>' || ch == '<' || ch =='!' || ch == '=')
				       {
				    	   condparseto = parseindex-1;
				    	   int hj = parseindex;
				    	   char ch1 = parsecondition.charAt(hj);
				    	   if(ch1 == '=')
				    	   {
				    		   condparseto = parseindex-2;
				    	   }
				        }
				     }
				     char arrsd[] = new char[condparseto - condparsefrom +1];
				     int j=1;
				     arrsd[0] = Character.toUpperCase(parsecondition.charAt(condparsefrom));
				     for(int lk=condparsefrom+1;lk<condparseto+1;lk++)
				     {
				    	 arrsd[j] = parsecondition.charAt(lk);
				    	 j++;
				     }
				     String ab = new String(arrsd);
				     String s2 = classname + "." + "get"+ab+"()";
				     String s3 = "get" + ab;
				      
				     Object cls = Class.forName(classname).newInstance(); 
				     Class c = cls.getClass();
				     Method[] meths = c.getDeclaredMethods();
				     if (meths.length != 0) 
				     {
				    	 for (Method m : meths)
				         {
				    		 int comparisonResult = s3.compareTo(m.getName());
				        	 if(comparisonResult == 0)
				        	 {
				        		 Object bbb = m.invoke(cls);
				        		 part2.trim().replace("'", "");
				        		 int dis = t+1;
				        		 if(stringflag == 0 && (bbb.toString().equals(part2.trim().replace("'", "").toString()))==false)
								 {
				        			 System.out.println("The Invariant condition : " +dis+ " is correct");
				        		 
								 }
				        	     else if(stringflag == 1 && bbb.toString().equals((String)num1[stringflagindex])==false)
								 {
				        	    	 System.out.println("The Invariant condition : " +dis+ " is correct");
				        		 }
				        	     else
								 {
									System.out.println("INVARIANT VIOLATION");
									System.out.println("INVARIANT CONDITION : " +dis+ " IS WRONG");
									throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
							     }
				               }
				          }
				       }
				       else 
				       {
				    	   System.out.println("  -- no methods --%n");
				       }  
				}// close for invariant_cond[t] contains(.)
		        		
			}//invariant_cond[t].contains("!=")
		    //	if(invariant_cond[t].contains("=="))
		    
		    
		
		  else if(invariant_cond[t].startsWith("FUNCTIONCHECK"))
		  {
			  
			 
	  		  String parsecondition = invariant_cond[t];
	  		 
	  		  int parseindex=0;
	  		  int condparsefrom=0;
	  	        int condparseto=0;
	  	         int i=0;
	  	        for(parseindex=0;parseindex<parsecondition.length();parseindex++)
	  	        {
	  	    	  char ch = parsecondition.charAt(parseindex);
	  	    	  if(ch == '.')
	  	    	  {
	  	    		  condparsefrom = parseindex+1;
	  	    	  }
	  	        }
	  	    	  
	  	    		  condparseto = parseindex-1;
	  	    	
	  	        char arrsd[] = new char[condparseto - condparsefrom+1];
	  	   
	  	        int j=0;
	  	        for(int lk=condparsefrom;lk<condparseto+1;lk++)
	  	        {
	  	      	   arrsd[j] = parsecondition.charAt(lk);
	  	    	   j++;
	  	        }
	  	       String ab = new String(arrsd);
	  	       Object[] num1 = thisJoinPoint.getArgs();
	          	String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
	  	        Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
	  	       
	  	        String classname=null;
	  	        String className = null;
	  	      
	  	      int gh=0;
  	          for(gh=0;gh<num1.length;gh++)
  		       {
  		        
  		   	  className = types[gh].getName();
  		   	  boolean objcompareint;
  		    boolean objcomparestring;
  		   	  objcompareint = Objects.equals(className, "int");
  		   	objcomparestring = Objects.equals(className, "java.lang.String");
  		   	
  		    	 if(objcompareint == true && objcomparestring == false)
  		    	 {
  		    		  
  		    	  }
  		    	 else if(objcompareint == false && objcomparestring == true)
  		    	 {
  		    		 
  		    	 }
  		    	 else
  		    	 {
  		    		 classname = className;
  		    	 }
  		       }
	  	    	
	  	          Object cls = Class.forName(classname).newInstance(); 
	  				Class c = cls.getClass();
	  		        Method[] meths = c.getDeclaredMethods();
	  		       
	  		        if (meths.length != 0) 
	  		        {
	  		        for (Method m : meths)
	  		        {
	  		        	
	  		        	int comparisonResult = ab.compareTo(m.getName());
	  		        	
			        	 if(comparisonResult == 0)
		  		        	{
		  		        		if(num1.length == 1)
		  		        		{
		  		        			Object o = m.invoke(cls,num1[0]);
		  		        			boolean di = (Boolean)o;
		  		        			int dis = t+1;
						            if(String.valueOf(di) == "true")
										{
						        		System.out.println("The Invariant condition : " +dis+ " is correct");	
										}
						        	else
										{
											System.out.println("INVARIANT VIOLATION");
											System.out.println("INVARIANT CONDITION : " +dis+ " IS WRONG");	
											throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
						        	    } 
		  		        		}
		  		        		else if(num1.length == 2)
		  		        		{
		  		        			Object o = m.invoke(cls,num1[0],num1[1]);
		  		        			boolean di = (Boolean)o;
		  		        			int dis = t+1;
		  		        			 if(String.valueOf(di) == "true")
										{
						        		System.out.println("The Invariant condition : " +dis+ " is correct");	
										}
						        	else
										{
											System.out.println("INVARIANT VIOLATION");
											System.out.println("INVARIANT CONDITION : " +dis+ " IS WRONG");
											throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
						        	    } 
		  		        		}
		  		        		else if(num1.length == 3)
		  		        		{
		  		        			Object o = m.invoke(cls,num1[0],num1[1],num1[2]);
		  		        			boolean di = (Boolean)o;
		  		        			int dis = t+1;
		  		        			 if(String.valueOf(di) == "true")
										{
						        		System.out.println("The Invariant condition : " +dis+ " is correct");	
										}
						        	else
										{
											System.out.println("INVARIANT VIOLATION");
											System.out.println("INVARIANT CONDITION : " +dis+ " IS WRONG");	
											throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
						        	    } 
		  		        		}
		  		        		else if(num1.length == 4)
		  		        		{
		  		        			Object o = m.invoke(cls,num1[0],num1[1],num1[2],num1[3]);
		  		        			boolean di = (Boolean)o;
		  		        			int dis = t+1;
		  		        			 if(String.valueOf(di) == "true")
										{
						        		System.out.println("The Invariant condition : " +dis+ " is correct");	
										}
						        	else
										{
											System.out.println("INVARIANT VIOLATION");
											System.out.println("INVARIANT CONDITION : " +dis+ " IS WRONG");
											throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
						        	    } 
		  		        		}
		  		        		else if(num1.length == 5)
		  		        		{
		  		        			Object o = m.invoke(cls,num1[0],num1[1],num1[2],num1[3],num1[4]);
		  		        			boolean di = (Boolean)o;
		  		        			int dis = t+1;
		  		        			 if(String.valueOf(di) == "true")
										{
						        		System.out.println("The Invariant condition : " +dis+ " is correct");	
										}
						        	else
										{
											System.out.println("INVARIANT VIOLATION");
											System.out.println("INVARIANT CONDITION : " +dis+ " IS WRONG");	
											throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
						        	    } 
		  		        		}
		  		        		else if(num1.length == 6)
		  		        		{
		  		        			Object o = m.invoke(cls,num1[0],num1[1],num1[2],num1[3],num1[4],num1[5]);
		  		        			boolean di = (Boolean)o;
		  		        			int dis = t+1;
		  		        			 if(String.valueOf(di) == "true")
										{
						        		System.out.println("The Invariant condition : " +dis+ " is correct");	
										}
						        	else
										{
											System.out.println("INVARIANT VIOLATION");
											System.out.println("INVARIANT CONDITION : " +dis+ " IS WRONG");	
											throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
						        	    } 
		  		        		}
		  		        		else if(num1.length == 7)
		  		        		{
		  		        			Object o = m.invoke(cls,num1[0],num1[1],num1[2],num1[3],num1[4],num1[5],num1[6]);
		  		        			boolean di = (Boolean)o;
		  		        			int dis = t+1;
		  		        			 if(String.valueOf(di) == "true")
										{
						        		System.out.println("The Invariant condition : " +dis+ " is correct");	
										}
						        	else
										{
											System.out.println("INVARIANT VIOLATION");
											System.out.println("INVARIANT CONDITION : " +dis+ " IS WRONG");	
											throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
						        	    } 
		  		        		}
		  		        		else
		  		        		{
		  		        		Object o = m.invoke(cls,num1[0],num1[1],num1[2],num1[3],num1[4],num1[5],num1[6],num1[7]);
		  		        	
		  		        		boolean di = (Boolean)o;
		  		        		int dis = t+1;
		  		        		 if(String.valueOf(di) == "true")
									{
					        		System.out.println("The Invariant condition : " +dis+ " is correct");	
									}
					        	else
									{
										System.out.println("INVARIANT VIOLATION");
										System.out.println("INVARIANT CONDITION : " +dis+ " IS WRONG");
										throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
					        	    } 
		  		        		}
		  			     
		  			      
		  			      
		  		        	}//close of comparisonResult == 0
	  		        
	  		        }
	  		        }
		  
		  }
		
		    
		    else if(invariant_cond[t].contains("=="))
		    {
		    	flag=6;
		        if(invariant_cond[t].contains("."))
			    {
		        	objflag=1;
			        //System.out.println("The argument has object contracts");
					String foo=invariant_cond[t];
					int u=0;
					int intflagindex=0;
			        objflag=1;
				        		
				    Object[] num1 = thisJoinPoint.getArgs();
				    String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
					Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
					        
				    String[] result=foo.split("\\=="); 
				    String[] parts = foo.split("==");
			        String part1 = parts[0].trim(); 
			        String part2 = parts[1].trim(); 
				        
			        int gh=0;
			        	
			        for (u = 0; u < num1.length; u++) 
			        {
			        	String part3 = names[u].trim();
					    if(part2.equals(part3))
					    {
					    	intflag = 1;	
					    	intflagindex = u;
					    }
					    else if(types[u].getName().equals("String"))
					    {
					    	stringflag = 1;
					    	stringflagindex=u;
					    }
					    else
					    {
					    	intflag = 0;
					    }
			        }
			        	
			        int i;
				    String classname=null;
				    gh=0;
				   
				    
				    
				    String className = null;
		  	          for(gh=0;gh<num1.length;gh++)
		  		       {
		  		        
		  		   	  className = types[gh].getName();
		  		   	  boolean objcompareint;
		  		    boolean objcomparestring;
		  		   	  objcompareint = Objects.equals(className, "int");
		  		   	objcomparestring = Objects.equals(className, "java.lang.String");
		  		   	
		  		    	 if(objcompareint == true && objcomparestring == false)
		  		    	 {
		  		    		  
		  		    	  }
		  		    	 else if(objcompareint == false && objcomparestring == true)
		  		    	 {
		  		    		 
		  		    	 }
		  		    	 else
		  		    	 {
		  		    		 classname = className;
		  		    	 }
		  		       }
		  	          
				    String parsecondition = invariant_cond[t];
				  
				    int condparsefrom=0;
				    int condparseto=0;
				    i=0;
				    for(int parseindex=0;parseindex<parsecondition.length();parseindex++)
				    {
				    	char ch = parsecondition.charAt(parseindex);
				    	if(ch == '.')
				    	{
				    		condparsefrom = parseindex+1;
				    	}
				    	if(ch == '>' || ch == '<' || ch =='!' || ch == '=')
				    	{
				    		condparseto = parseindex-1;
				    		int hj = parseindex;
				    		char ch1 = parsecondition.charAt(hj);
				    		if(ch1 == '=')
				    		{
				    			condparseto = parseindex-2;
				    		 }
				    	 }
				     }
				     char arrsd[] = new char[condparseto - condparsefrom + 1];
				     int j=1;
				     arrsd[0] = Character.toUpperCase(parsecondition.charAt(condparsefrom));
				     for(int lk=condparsefrom+1;lk<condparseto+1;lk++)
				     {
				    	 arrsd[j] = parsecondition.charAt(lk);
				    	 j++;
				     }
				     String ab = new String(arrsd);
				     String s2 = classname + "." + "get"+ab+"()";
				     String s3 = "get" + ab;
				     
				     Object cls = Class.forName(classname).newInstance(); 
				     Class c = cls.getClass();
				     Method[] meths = c.getDeclaredMethods();
				     if (meths.length != 0) 
				     {
				    	 for (Method m : meths)
				    	 {
				    		 int comparisonResult = s3.compareTo(m.getName());
				        	 if(comparisonResult == 0)
				        	 {
				        		 Object bbb = m.invoke(cls);
				        		 part2.trim().replace("'", "");
				        		 int dis = t+1;
				        		 if(stringflag == 0 && (bbb.toString().equals(part2.trim().replace("'", "").toString()))==true)
				        		 {
				        		
									System.out.println("The Invariant condition : " +dis+ " is correct");
				        		 }
				        		 else if(stringflag == 1 && bbb.toString().equals((String)num1[stringflagindex])==true)
								 {
				        			 System.out.println("The Invariant condition : " +dis+ " is correct");
				        		 
								 }
				        		 else
				        		 {
									System.out.println("INVARIANT VIOLATION");
									System.out.println("INVARIANT CONDITION : " +dis+ "IS WRONG");
									throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
								}
				        
				        	 }
				           }
				       }
				       else
				       {
				    	   System.out.println("  -- no methods --%n");
				       }  
			      } // close for . of ==
		      } // close of else
		    else
		    {
		    	//Not supported
		    }
		   } // end of main for loop
		        
    	
	    	
	    	
	    	
	    	
	    	
            }//close of "if invariant_cond == null
	    	
	    
		if(pre_cond.length>=1)
		{
			System.out.println("");
			System.out.println("Checking for Preconditions ");
			
			
			
		    System.out.println( "The Pre conditions are : " + Arrays.asList(pre_cond));
		  
		    System.out.println("The Total num of Pre conditions are:"+pre_cond.length);
		    System.out.println("");    
		    System.out.println("Executing the function : ");
		   
		    
		    
		    //To check if the condition has an object which is of the form Classname.object for bean property.
		    
		    int t;
		    for(t=0;t<pre_cond.length;t++)
		    {
		    	if(pre_cond[t].contains("."))
		        {
		    		objflag=1;
		        }
		    }
		    //for loop to locate the symbols in the condition
		    
		    for(t=0;t<pre_cond.length;t++)
		    {
		    if(pre_cond[t].contains(">="))
		    {
		    	flag=3;
		        if(pre_cond[t].contains("."))
			    {
		        	objflag=1;
		        	//System.out.println("The argument has object contracts");
		        	String foo=pre_cond[t];
		        	System.out.println(pre_cond[t]);
		        	int u=0;
		        	int intflagindex=0;
		        	objflag=1;
			    
		        	String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
		        	Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
		        	Object[] num1 = thisJoinPoint.getArgs();
		        	String[] result=foo.split("\\>="); 
		        	String[] parts = foo.split(">=");
		        	String part1 = parts[0].trim(); 
		        	String part2 = parts[1].trim(); 
				        
		        	for (u = 0; u < num1.length; u++) 
		        	{
		        		String part3 = names[u].trim();
		        		if(part2.equals(part3))
		        		{
		        			intflag = 1;	
		        			intflagindex = u;
		        		}
		        		else
		        		{
		        			intflag = 0;
		        		}
		        	}
		        	int i;
		        	String className = null;
				    String classname=null;
				    int gh=0;
				    
				    for(gh=0;gh<num1.length;gh++)
		  		       {
		  		        
		  		   	  className = types[gh].getName();
		  		   	  boolean objcompareint;
		  		    boolean objcomparestring;
		  		   	  objcompareint = Objects.equals(className, "int");
		  		   	objcomparestring = Objects.equals(className, "java.lang.String");
		  		   	
		  		    	 if(objcompareint == true && objcomparestring == false)
		  		    	 {
		  		    		  
		  		    	  }
		  		    	 else if(objcompareint == false && objcomparestring == true)
		  		    	 {
		  		    		 
		  		    	 }
		  		    	 else
		  		    	 {
		  		    		 classname = className;
		  		    	 }
		  		       }
				    
				   
				    String parsecondition = pre_cond[t];
				   
				      
				    int condparsefrom=0;
				    int condparseto=0;
				    i=0;
				    for(int parseindex=0;parseindex<parsecondition.length();parseindex++)
				    {
				    	char ch = parsecondition.charAt(parseindex);
				    	if(ch == '.')
				    	{
				    		condparsefrom = parseindex+1;
				    	}
				    	if(ch == '>' || ch == '<' || ch =='!' || ch == '=')
				    	{
				    		condparseto = parseindex-1;
				    		int hj = parseindex;
				    		char ch1 = parsecondition.charAt(hj);
				    		if(ch1 == '=')
				    		{
				    			condparseto = parseindex-2;
				    		}
				    	}
				     }
				        
				     char arrsd[] = new char[condparseto - condparsefrom +1];
				   
				     int j=1;
				     arrsd[0] = Character.toUpperCase(parsecondition.charAt(condparsefrom));
				     for(int lk=condparsefrom+1;lk<condparseto+1;lk++)
				     {
				    	 arrsd[j] = parsecondition.charAt(lk);
				    	 j++;
				     }
				     
				     String ab = new String(arrsd);
				     String s2 = classname + "." + "get"+ab+"()";
				     String s3 = "get" + ab;
				     Object cls = Class.forName(classname).newInstance(); 
				     Class c = cls.getClass();
				     
				     Method[] meths = c.getDeclaredMethods();
				     if (meths.length != 0) 
				     {
				    	 for (Method m : meths)
				         {
				    		 int comparisonResult = s3.compareTo(m.getName());
				    		 if(comparisonResult == 0)
				    		 {
				    			 Object bbb = m.invoke(cls);
				    			 int numb = Integer.parseInt( bbb.toString() );
				    			 int dis = t+1;
				    			 if(intflag == 0 && numb >= Integer.parseInt(part2.trim()))
				    			 {
								 System.out.println("The Precondition : " +dis+ " is correct");
								 }
			        	         else if(intflag == 1 && numb >= (Integer)num1[intflagindex])
			        		     {
			        	        	 System.out.println("The Precondition :" +dis+ " is correct");
								 }
								 else
								 {
									 System.out.println("CONTRACT VIOLATION");
									 System.out.println("PRECONDITION :" +dis+ " IS WRONG");
									 throw new ContractViolation("PRECONDITION "+dis+" IS WRONG");
								 }
				             }//end of "if"
				        }//end for "for" loop
				      }//end for "if"
				      else 
				      {
				    	  System.out.println("  -- no methods --%n");
				      }  
				 }//end of "if" containing "."
		        		
		         else
		         {
		         int i=0;
				 String foo=pre_cond[t];
				 
				 //Split the string to get the variable and result[0] has var,result[1] has 0. 
				 String[] result=foo.split(">="); 
				    		    		
				 //Split the string to get the variable and result[0] has var,result[1] has 0. 
				 Object[] num1 = thisJoinPoint.getArgs();
				    				
				 String parsecondition = foo;
				 int condparsefrom=0;
				 int condparseto=0;
				 int hj=0;
				 i=0;
				 int parseindex = 0;
				 for(parseindex=0;parseindex<parsecondition.length();parseindex++)
				 {
				 char ch = parsecondition.charAt(parseindex);
				 if(ch == '>' || ch == '<' || ch =='!' || ch == '=')
				 {
					 condparseto = parseindex-1;
					 hj = parseindex+1;
					 char ch1 = parsecondition.charAt(hj);
					 if(ch1 == '=')
					 {
					 condparseto = hj+1;
					 }
				 }
				 }
				 int condparsetoult = parseindex-1;
				 int ju=0;
				 char arrsd[] = new char[condparsetoult-condparseto];
				 for(int lk=hj;lk<parsecondition.length();lk++)
				 {
					 arrsd[ju] = parsecondition.charAt(lk);
					 ju++;
				 }
				 String ab = new String(arrsd);
				 String part1 = result[0].trim(); 
				 String part2 = ab.trim();
				 result[1] = ab.trim();
						        	
				 int wl;
				 int wr;
				 int wl1=0;
				 int wr1=0;
				 int occurnceleft = 0;
				 int occurncetypeleft = 0;
				 int occurnceright = 0;
				 int occurncetyperight = 0;
				 int leftside=0;
				 int rightside=0;
				    				
				 String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
				 Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
				    			    
				 for (wl = 0; wl < num1.length; wl++) 
				 {
					 if(part1.equals(names[wl]))
					 {
						 occurnceleft = 1;
						 wl1=wl;
				    			    		  
						 if(types[wl].getName().equals("int"))
						 {
							 occurncetypeleft=1;
						 }
					 }
				 }//end of "for" loop
				    			      
				 for (wr = 0; wr < num1.length; wr++) 
				 {	  
				 if(part2.equals(names[wr]))
				 {
					 occurnceright = 1;
				     if(types[wr].getName().equals("int"))
				     {
				    	 occurncetyperight = 1;
				     }
				 }
				 } //end of "for" loop
				    			     
				 if(occurnceleft == 1 && occurncetypeleft == 1)
				 {
				 if(occurnceright == 1 && occurncetyperight == 1)
				 {
					 leftside=(Integer)num1[wl1];
					 rightside = (Integer) (num1[wr1]);
				 }
				 else if(occurnceright == 0 && occurncetyperight == 0)
				 {
					 leftside=(Integer)num1[wl1];
					 rightside = Integer.parseInt(result[1]);
				    				    			 
				 }
				 else
				 {
				    			    			  
				 }
				 }//end of "if"
				    			    	  
				 else { }
				 int n=i;
				 int count=n+1;
				 int dis = t+1;
			     if(leftside >= rightside)
				 {
			    	 System.out.println("The Precondition: " +dis+ "  is correct");
				 }
				 else
				 {
					 System.out.println("CONTRACT VIOLATION");
					 System.out.println("PRECONDITION : " +dis+ " IS WRONG");
					 throw new ContractViolation("PRECONDITION "+dis+" IS WRONG");
				 }
				 }//end of "else"
		        		
		    }//end of "else of >= "
		    
		    else if(pre_cond[t].contains(">"))
		    {
		    	flag=1;
		    	if(pre_cond[t].contains("."))
		    	{
		    		//System.out.println("The argument has object contracts");
				    String foo=pre_cond[t];
					int u=0;
					int intflagindex=0;
		        	objflag=1;
			        
					Object[] num1 = thisJoinPoint.getArgs();
					String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
					Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
							        
					String[] result=foo.split("\\>"); 
					String[] parts = foo.split(">");
					String part1 = parts[0].trim(); 
					String part2 = parts[1].trim();
						        
					for (u = 0; u < num1.length; u++) 
					{
						String part3 = names[u].trim();
						if(part2.equals(part3))
						{
							intflag = 1;	
							intflagindex = u;
						}
						else
						{
							intflag = 0;
						}
					}
					        	
					int i;	         
					
					String classname=null;
					int gh=0;
					String className = null;
		  	          for(gh=0;gh<num1.length;gh++)
		  		       {
		  		        
		  		   	  className = types[gh].getName();
		  		   	  boolean objcompareint;
		  		    boolean objcomparestring;
		  		   	  objcompareint = Objects.equals(className, "int");
		  		   	objcomparestring = Objects.equals(className, "java.lang.String");
		  		   	
		  		    	 if(objcompareint == true && objcomparestring == false)
		  		    	 {
		  		    		  
		  		    	  }
		  		    	 else if(objcompareint == false && objcomparestring == true)
		  		    	 {
		  		    		 
		  		    	 }
		  		    	 else
		  		    	 {
		  		    		 classname = className;
		  		    	 }
		  		       }
					String parsecondition = pre_cond[t];
					int condparsefrom=0;
					int condparseto=0;
					i=0;
					for(int parseindex=0;parseindex<parsecondition.length();parseindex++)
					{
						char ch = parsecondition.charAt(parseindex);
						if(ch == '.')
						{
							condparsefrom = parseindex+1;
						}
						if(ch == '>' || ch == '<' || ch =='!' || ch == '=')
						{
							condparseto = parseindex-1;
						}
					 }
						        
					 char arrsd[] = new char[condparseto - condparsefrom +1];
					 int j=1;
					 arrsd[0] = Character.toUpperCase(parsecondition.charAt(condparsefrom));
					 for(int lk=condparsefrom+1;lk<condparseto+1;lk++)
					 {
						 arrsd[j] = parsecondition.charAt(lk);
						 j++;
					 }
					 String ab = new String(arrsd);
					 String s2 = classname + "." + "get"+ab+"()";
					 String s3 = "get" + ab;
					 Object cls = Class.forName(classname).newInstance(); 
					 Class c = cls.getClass();
					 Method[] meths = c.getDeclaredMethods();
					 if (meths.length != 0) 
					 {
					 for (Method m : meths)
					 {
					 int comparisonResult = s3.compareTo(m.getName());
					 if(comparisonResult == 0)
					 {
						 Object bbb = m.invoke(cls);
						 System.out.println("In method : "+m.getName());
						 int numb = Integer.parseInt( bbb.toString() );
						 int dis = t+1;
						 if(intflag == 0 && numb > Integer.parseInt(part2.trim()))
						 {
							 System.out.println("The Precondition : " +dis+ " is correct");
						 }
						 else if(intflag == 1 && numb > (Integer)num1[intflagindex])
						 {
							 System.out.println("The Precondition : " +dis+ "is correct");
						 }
						 else
						 {
							 System.out.println("CONTRACT VIOLATION");
							 System.out.println("PRECONDITION : " +dis+ " IS WRONG");
							 throw new ContractViolation("PRECONDITION "+dis+" IS WRONG");
						 }
					  }//close for "if(comparisonResult == 0)
					  }//close for "Method m: meths"
					  }//close for "meths.length!=0"
					  else 
					  {
						  System.out.println("  -- no methods --%n");
					  }  
				 }//close of if "contains[.]"
		         else
		         {
		         int i=0;
				 String foo=pre_cond[t];
				    			        
				 //Split the string to get the variable and result[0] has var,result[1] has 0. 
				 String[] result=foo.split(">"); 
				    		    		
				 //Split the string to get the variable and result[0] has var,result[1] has 0. 
				 Object[] num1 = thisJoinPoint.getArgs();
				    				
				 String part1 = result[0].trim();
				 String part2 = result[1].trim();
				    				
				 int wl;
				 int wr;
				 int wl1=0;
				 int wr1=0;
				 int occurnceleft = 0;
				 int occurncetypeleft = 0;
				 int occurnceright = 0;
				 int occurncetyperight = 0;
				 int leftside=0;
				 int rightside=0;
				    				
				 String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
				 Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
				    			    
				 for (wl = 0; wl < num1.length; wl++) 
				 {
				 if(part1.equals(names[wl]))
				 {
					 occurnceleft = 1;
				     wl1=wl;
				     if(types[wl].getName().equals("int"))
				     {
				    	 occurncetypeleft=1;
				     }
				 }
				 }
				 for (wr = 0; wr < num1.length; wr++) 
				 {	  
					 if(part2.equals(names[wr]))
				     {
						 occurnceright = 1;
				    	 if(types[wr].getName().equals("int"))
				    	 {
				    		 occurncetyperight = 1;
				    	 }
				     }
				 } 
				 if(occurnceleft == 1 && occurncetypeleft == 1)
				 {
				 if(occurnceright == 1 && occurncetyperight == 1)
				 {
					 leftside=(Integer)num1[wl1];
				     rightside = (Integer) (num1[wr1]);
				 }
				 else if(occurnceright == 0 && occurncetyperight == 0)
				 {
					 leftside=(Integer)num1[wl1];
				     rightside = Integer.parseInt(result[1]);
				 }
				 else
				 {
				 }
				 }
				 else 
				 {
				 }
				 int n=i;
				 int count=n+1;
				 int dis = t+1;
				 
				 if(leftside > rightside)
				 {
					 System.out.println("The Precondition:" +dis+ " is correct");
				 }
				 else
				 {
					 System.out.println("CONTRACT VIOLATION");
					 System.out.println("PRECONDITION : " +dis+ " IS WRONG");
					 throw new ContractViolation("PRECONDITION "+dis+" IS WRONG");
				 }
				}//close of "else"
    	    }// close of "pre_cond[t].contains(">")"	
		    
		    else if(pre_cond[t].contains("<="))
		    {
		    	flag=4;
		        if(pre_cond[t].contains("."))
			    {
		        	objflag=1;
			        //System.out.println("The argument has object contracts");
					String foo=pre_cond[t];
				    int u=0;
				    int intflagindex=0;
			        objflag=1;
				        		
				    String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
					Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
					Object[] num1 = thisJoinPoint.getArgs();
					    
					String[] result=foo.split("\\<="); 
				    String[] parts = foo.split("<=");
			        String part1 = parts[0].trim(); 
			        String part2 = parts[1].trim(); 
				        
			        for (u = 0; u < num1.length; u++) 
			        {
			        	String part3 = names[u].trim();
					    if(part2.equals(part3))
					    {
					    	intflag = 1;	
					    	intflagindex = u;
					    }
					    else
					    {
					    	intflag = 0;
					    }
			        }
			        int i;
				    String classname=null;
				    int gh=0;
				    String className = null;
		  	          for(gh=0;gh<num1.length;gh++)
		  		       {
		  		        
		  		   	  className = types[gh].getName();
		  		   	  boolean objcompareint;
		  		    boolean objcomparestring;
		  		   	  objcompareint = Objects.equals(className, "int");
		  		   	objcomparestring = Objects.equals(className, "java.lang.String");
		  		   	
		  		    	 if(objcompareint == true && objcomparestring == false)
		  		    	 {
		  		    		  
		  		    	  }
		  		    	 else if(objcompareint == false && objcomparestring == true)
		  		    	 {
		  		    		 
		  		    	 }
		  		    	 else
		  		    	 {
		  		    		 classname = className;
		  		    	 }
		  		       }
				    String parsecondition = pre_cond[t];
				        
				    int condparsefrom=0;
				    int condparseto=0;
				    i=0;
				    for(int parseindex=0;parseindex<parsecondition.length();parseindex++)
				    {
				    	char ch = parsecondition.charAt(parseindex);
				    	if(ch == '.')
				    	{
				    		condparsefrom = parseindex+1;
				    	}
				    	if(ch == '>' || ch == '<' || ch =='!' || ch == '=')
				    	{
				    		condparseto = parseindex-1;
				    		int hj = parseindex;
				    		char ch1 = parsecondition.charAt(hj);
				    		if(ch1 == '=')
				    		{
				    			condparseto = parseindex-2;
				    		}
				    	}
				     }//close of "for" loop
				     
				     char arrsd[] = new char[condparseto - condparsefrom +1];
				     int j=1;
				     arrsd[0] = Character.toUpperCase(parsecondition.charAt(condparsefrom));
				     for(int lk=condparsefrom+1;lk<condparseto+1;lk++)
				     {
				    	 arrsd[j] = parsecondition.charAt(lk);
				    	 j++;
				     }
				     String ab = new String(arrsd);
				     String s2 = classname + "." + "get"+ab+"()";
				     String s3 = "get" + ab;
				     Object cls = Class.forName(classname).newInstance(); 
				     Class c = cls.getClass();
				     Method[] meths = c.getDeclaredMethods();
				       
				     if (meths.length != 0) 
				     {
				     for (Method m : meths)
				     {
				    	 int comparisonResult = s3.compareTo(m.getName());
				         if(comparisonResult == 0)
				         {
				        	 Object bbb = m.invoke(cls);
				        	 int numb = Integer.parseInt( bbb.toString() );
				        	 int dis = t+1;
				        	 if(intflag == 0 && numb <= Integer.parseInt(part2.trim()))
							 {
				        		 System.out.println("The Precondition : " +dis+ "is correct");
							 }
				        	 else if(intflag == 1 && numb <= (Integer)num1[intflagindex])
							 {
				        		 System.out.println("The Precondition : " +dis+ " is correct");
							 }
							 else
							 {
								 System.out.println("CONTRACT VIOLATION");
								 System.out.println("PRECONDITION : " +dis+ "IS WRONG");
								 throw new ContractViolation("PRECONDITION "+dis+" IS WRONG");
							 }
				           }//end of "comparisonResult==0"
				      }//end of "for"
				      }//end of "if"
				      else 
				      {
				    	  System.out.println("  -- no methods --%n");
				      }  
	            }//end of pre_cond[t].contains(".")
		        else
		        {
		        	int i=0;
		        	String foo=pre_cond[t];
				    			        
				    //Split the string to get the variable and result[0] has var,result[1] has 0. 
				    String[] result=foo.split("<="); 
				    		    		
				    //Split the string to get the variable and result[0] has var,result[1] has 0. 
				    Object[] num1 = thisJoinPoint.getArgs();
				    				
				    String parsecondition = foo;
								      
					int condparsefrom=0;
					int condparseto=0;
					int hj=0;
					i=0;
				    int parseindex = 0;
					for(parseindex=0;parseindex<parsecondition.length();parseindex++)
					{
						char ch = parsecondition.charAt(parseindex);
				    	if(ch == '>' || ch == '<' || ch =='!' || ch == '=')
						{
				    		condparseto = parseindex-1;
							hj = parseindex+1;
							char ch1 = parsecondition.charAt(hj);
							if(ch1 == '=')
							{
								condparseto = hj+1;
							}
					     }
					 }
					 int condparsetoult = parseindex-1;
				     int ju=0;
				     char arrsd[] = new char[condparsetoult-condparseto];
				     for(int lk=hj;lk<parsecondition.length();lk++)
					 {
				    	 arrsd[ju] = parsecondition.charAt(lk);
						 ju++;
					 }
					 String ab = new String(arrsd);
							      
				     String part1 = result[0].trim(); 
				     String part2 = ab.trim();
					 result[1] = ab.trim();
						        	
				     int wl;
				     int wr;
				     int wl1=0;
				     int wr1=0;
				     int occurnceleft = 0;
				     int occurncetypeleft = 0;
				     int occurnceright = 0;
				     int occurncetyperight = 0;
				     int leftside=0;
				     int rightside=0;
				    				
				     String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
				     Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
				    			    
				     for (wl = 0; wl < num1.length; wl++) 
				     {
				    	 if(part1.equals(names[wl]))
				    	 {
				    		 occurnceleft = 1;
				    		 wl1=wl;
				    		 if(types[wl].getName().equals("int"))
				    		 {
				    			 occurncetypeleft=1;
				    		 }
				    	 }
				      }
				    			      
				     for (wr = 0; wr < num1.length; wr++) 
				     {	  
				    	 if(part2.equals(names[wr]))
				    	 {
				    		 occurnceright = 1;
				    		 if(types[wr].getName().equals("int"))
				    		 {
				    			 occurncetyperight = 1;
				    		 }
				    	 }
				     } 
				    			     
				    if(occurnceleft == 1 && occurncetypeleft == 1)
				    {
				    	if(occurnceright == 1 && occurncetyperight == 1)
				    	{
				    		leftside=(Integer)num1[wl1];
				    		rightside = (Integer) (num1[wr1]);
				    	}
				    	else if(occurnceright == 0 && occurncetyperight == 0)
				    	{
				    		leftside=(Integer)num1[wl1];
				    		rightside = Integer.parseInt(result[1]);
				        }
				    	else
				    	{
				    	}
				     }
				     else 
				     {
				     }
				     int n=i;
				     int count=n+1;
				     int dis = t+1;
				     if(leftside <= rightside)
				     {
				    	 System.out.println("The Precondition:"+dis+"  is correct");
				     }
				     else
				     {
				    	 System.out.println("CONTRACT VIOLATION");
				    	 System.out.println("PRECONDITION : " +dis+ " IS WRONG");
				    	 throw new ContractViolation("PRECONDITION "+dis+" IS WRONG");
				     }
			    }//end of "else"
		  }// end of "else if pre_cond[t].contains("<=")
		          	
		  else if(pre_cond[t].contains("<"))
		  {
			  flag=2;
		      if(pre_cond[t].contains("."))
			  {
		    	 
		    	  objflag=1;
			      //System.out.println("The argument has object contracts");
				  String foo=pre_cond[t];
				  int u=0;
				  int intflagindex=0;
		          objflag=1;
			      Object[] num1 = thisJoinPoint.getArgs();
				  String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
				  Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
					        
				  String[] result=foo.split("\\<"); 
				  String[] parts = foo.split("<");
			      String part1 = parts[0].trim(); 
			      String part2 = parts[1].trim(); 
				        
			      for (u = 0; u < num1.length; u++) 
			      {
			    	  String part3 = names[u].trim();
					  if(part2.equals(part3))
					  {
						  intflag = 1;	
					      intflagindex = u;
					  }
					  else
					  {
						  intflag = 0;
					  }
			       }
			     
			       int i;
				   String classname=null;
				   int gh=0;
				   String className = null;
		  	          for(gh=0;gh<num1.length;gh++)
		  		       {
		  		        
		  		   	  className = types[gh].getName();
		  		   	  boolean objcompareint;
		  		    boolean objcomparestring;
		  		   	  objcompareint = Objects.equals(className, "int");
		  		   	objcomparestring = Objects.equals(className, "java.lang.String");
		  		   	
		  		    	 if(objcompareint == true && objcomparestring == false)
		  		    	 {
		  		    		  
		  		    	  }
		  		    	 else if(objcompareint == false && objcomparestring == true)
		  		    	 {
		  		    		 
		  		    	 }
		  		    	 else
		  		    	 {
		  		    		 classname = className;
		  		    	 }
		  		       }
				   String parsecondition = pre_cond[t];
				   int condparsefrom=0;
				   int condparseto=0;
				   i=0;
				   for(int parseindex=0;parseindex<parsecondition.length();parseindex++)
				   {
					   char ch = parsecondition.charAt(parseindex);
				       if(ch == '.')
				       {
				    	   condparsefrom = parseindex+1;
				       }
				       if(ch == '>' || ch == '<' || ch =='!' || ch == '=')
				       {
				    	   condparseto = parseindex-1;
				       }
				   }
				   char arrsd[] = new char[condparseto - condparsefrom +1];
				   int j=1;
				   arrsd[0] = Character.toUpperCase(parsecondition.charAt(condparsefrom));
				   for(int lk=condparsefrom+1;lk<condparseto+1;lk++)
				   {
					   arrsd[j] = parsecondition.charAt(lk);
				       j++;
				   }
				   String ab = new String(arrsd);
				  
				   String s2 = classname + "." + "get"+ab+"()";
				   String s3 = "get" + ab;
				      
				   
				   Object cls = Class.forName(classname).newInstance(); 
				   Class c = cls.getClass();
				   Method[] meths = c.getDeclaredMethods();
				   if (meths.length != 0) 
				   {
					   for (Method m : meths)
				       {
						   
						   int comparisonResult = (s3.trim()).compareTo(m.getName());
						 
						   if(comparisonResult == 0)
				           {
							  
							   Object bbb = m.invoke(cls);
							   //int numb = Integer.parseInt( bbb.toString());
							   int numb = (Integer) bbb;
				        	   int dis = t+1;
				        	  
				        	   if(intflag == 0 && numb < Integer.parseInt(part2.trim()))
							   {
									System.out.println("The Precondition : " +dis+ " is correct");
							   }
				        	   else if(intflag == 1 && numb < (Integer)num1[intflagindex])
							   {
									System.out.println("The Precondition : " +dis+ " is correct");
							   }
				        	   else
							   {
									System.out.println("CONTRACT VIOLATION");
									System.out.println("PRECONDITION : " +dis+ "IS WRONG");
									throw new ContractViolation("PRECONDITION "+dis+" IS WRONG");
							   }
				            }//end of if comparisonResult==0
				        }
				     }
				     else 
				     {
				    	 System.out.println("  -- no methods --%n");
				     }  
			  }//the if for pre_cond[t].contains(.)
		      else
			  {
		    	  int i=0;
				  String foo=pre_cond[t];
					    			        
				  //Split the string to get the variable and result[0] has var,result[1] has 0. 
				  String[] result=foo.split("<"); 
					    		    		
				  //Split the string to get the variable and result[0] has var,result[1] has 0. 
				  Object[] num1 = thisJoinPoint.getArgs();
					    				
				  String part1 = result[0].trim(); 
				  String part2 = result[1].trim(); 
					    				
				  int wl;
				  int wr;
				  int wl1=0;
				  int wr1=0;
				  int occurnceleft = 0;
				  int occurncetypeleft = 0;
				  int occurnceright = 0;
				  int occurncetyperight = 0;
				  int leftside=0;
				  int rightside=0;
					    				
				  String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
				  Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
					    			    
				  for (wl = 0; wl < num1.length; wl++) 
				  {
					  if(part1.equals(names[wl]))
					  {
						  occurnceleft = 1;
					      wl1=wl;
					      if(types[wl].getName().equals("int"))
					      {
					    	  occurncetypeleft=1;
					      }
					   }
				   }
				   for (wr = 0; wr < num1.length; wr++) 
				   {	  
					   if(part2.equals(names[wr]))
					   {
						   occurnceright = 1;
					       if(types[wr].getName().equals("int"))
					       {
					    	   occurncetyperight = 1;
					       }
					    }
					} 
					if(occurnceleft == 1 && occurncetypeleft == 1)
					{
						if(occurnceright == 1 && occurncetyperight == 1)
					    {
							leftside=(Integer)num1[wl1];
					    	rightside = (Integer) (num1[wr1]);
					    }
					    else if(occurnceright == 0 && occurncetyperight == 0)
					    {
					    	leftside=(Integer)num1[wl1];
					    	rightside = Integer.parseInt(result[1]);
					    }
					    else
					    {
					    }
					 }
					 else
					 {
					    			    		  
					 }
					 int n=i;
					 int count=n+1;
					 int dis = t+1;
					 if(leftside < rightside)
					 {
						 System.out.println("The Precondition:"+dis+"  is correct");
					 }
					 else
					 {
						 System.out.println("CONTRACT VIOLATION");
						 System.out.println("PRECONDITION : " +dis+ " IS WRONG");
						 throw new ContractViolation("PRECONDITION "+dis+" IS WRONG");
					 }
					    			       	
		       }//end of else
		        			
		  }// end of else if contains "<"
		  else if(pre_cond[t].contains("!="))
		  {
			  flag=5;
		      if(pre_cond[t].contains("."))
			  {
		    	  objflag=1;
			      //System.out.println("The argument has object contracts");
				  String foo=pre_cond[t];
				  int u=0;
				  int intflagindex=0;
			      objflag=1;
				        		
				  Object[] num1 = thisJoinPoint.getArgs();
				  String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
				  Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
				  
				  String[] result=foo.split("\\!="); 
				  String[] parts = foo.split("!=");
			      String part1 = parts[0].trim(); 
			      String part2 = parts[1].trim(); 
				        
			      int gh=0;
			      for (u = 0; u < num1.length; u++) 
			      {
			    	  String part3 = names[u].trim();
					  if(part2.equals(part3))
					  {
						  intflag = 1;	
						  intflagindex = u;
					  }
					  else if(types[u].getName().equals("String"))
					  {
						  stringflag = 1;
						  stringflagindex=u;
					  }
					  else
					  {
						  intflag = 0;
					  }
			       }
			        	
			       int i;
				   String classname=null;
				   gh=0;
				   String className = null;
		  	          for(gh=0;gh<num1.length;gh++)
		  		       {
		  		        
		  		   	  className = types[gh].getName();
		  		   	  boolean objcompareint;
		  		    boolean objcomparestring;
		  		   	  objcompareint = Objects.equals(className, "int");
		  		   	objcomparestring = Objects.equals(className, "java.lang.String");
		  		   	
		  		    	 if(objcompareint == true && objcomparestring == false)
		  		    	 {
		  		    		  
		  		    	  }
		  		    	 else if(objcompareint == false && objcomparestring == true)
		  		    	 {
		  		    		 
		  		    	 }
		  		    	 else
		  		    	 {
		  		    		 classname = className;
		  		    	 }
		  		       }
				   String parsecondition = pre_cond[t];
				        
				   int condparsefrom=0;
				   int condparseto=0;
				   i=0;
				   for(int parseindex=0;parseindex<parsecondition.length();parseindex++)
				   {
					   char ch = parsecondition.charAt(parseindex);
				       if(ch == '.')
				       {
				    	   condparsefrom = parseindex+1;
				       }
				       if(ch == '>' || ch == '<' || ch =='!' || ch == '=')
				       {
				    	   condparseto = parseindex-1;
				    	   int hj = parseindex;
				    	   char ch1 = parsecondition.charAt(hj);
				    	   if(ch1 == '=')
				    	   {
				    		   condparseto = parseindex-2;
				    	   }
				        }
				     }
				     char arrsd[] = new char[condparseto - condparsefrom +1];
				     int j=1;
				     arrsd[0] = Character.toUpperCase(parsecondition.charAt(condparsefrom));
				     for(int lk=condparsefrom+1;lk<condparseto+1;lk++)
				     {
				    	 arrsd[j] = parsecondition.charAt(lk);
				    	 j++;
				     }
				     String ab = new String(arrsd);
				     String s2 = classname + "." + "get"+ab+"()";
				     String s3 = "get" + ab;
				      
				     Object cls = Class.forName(classname).newInstance(); 
				     Class c = cls.getClass();
				     Method[] meths = c.getDeclaredMethods();
				     if (meths.length != 0) 
				     {
				    	 for (Method m : meths)
				         {
				    		 int comparisonResult = s3.compareTo(m.getName());
				        	 if(comparisonResult == 0)
				        	 {
				        		 Object bbb = m.invoke(cls);
				        		 part2.trim().replace("'", "");
				        		 int dis = t+1;
				        		 if(stringflag == 0 && (bbb.toString().equals(part2.trim().replace("'", "").toString()))==false)
								 {
				        			 System.out.println("The Precondition : " +dis+ " is correct");
				        		 
								 }
				        	     else if(stringflag == 1 && bbb.toString().equals((String)num1[stringflagindex])==false)
								 {
				        	    	 System.out.println("The Precondition : " +dis+ " is correct");
				        		 }
				        	     else
								 {
									System.out.println("CONTRACT VIOLATION");
									System.out.println("PRECONDITION : " +dis+ " IS WRONG");
									throw new ContractViolation("PRECONDITION "+dis+" IS WRONG");
							     }
				               }
				          }
				       }
				       else 
				       {
				    	   System.out.println("  -- no methods --%n");
				       }  
				}// close for pre_cond[t] contains(.)
		        		
			}//pre_cond[t].contains("!=")
		    //	if(pre_cond[t].contains("=="))
		    
		    
		
		  else if(pre_cond[t].startsWith("FUNCTIONCHECK"))
		  {
			  
			 
	  		  String parsecondition = pre_cond[t];
	  		 
	  		  int parseindex=0;
	  		  int condparsefrom=0;
	  	        int condparseto=0;
	  	         int i=0;
	  	        for(parseindex=0;parseindex<parsecondition.length();parseindex++)
	  	        {
	  	    	  char ch = parsecondition.charAt(parseindex);
	  	    	  if(ch == '.')
	  	    	  {
	  	    		  condparsefrom = parseindex+1;
	  	    	  }
	  	        }
	  	    	  
	  	    		  condparseto = parseindex-1;
	  	    	
	  	        char arrsd[] = new char[condparseto - condparsefrom+1];
	  	   
	  	        int j=0;
	  	        for(int lk=condparsefrom;lk<condparseto+1;lk++)
	  	        {
	  	      	   arrsd[j] = parsecondition.charAt(lk);
	  	    	   j++;
	  	        }
	  	       String ab = new String(arrsd);
	  	       Object[] num1 = thisJoinPoint.getArgs();
	          	String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
	  	        Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
	  	       
	  	        String classname=null;
	  	        String className = null;
	  	      
	  	      int gh=0;
  	          for(gh=0;gh<num1.length;gh++)
  		       {
  		        
  		   	  className = types[gh].getName();
  		   	  boolean objcompareint;
  		    boolean objcomparestring;
  		   	  objcompareint = Objects.equals(className, "int");
  		   	objcomparestring = Objects.equals(className, "java.lang.String");
  		   	
  		    	 if(objcompareint == true && objcomparestring == false)
  		    	 {
  		    		  
  		    	  }
  		    	 else if(objcompareint == false && objcomparestring == true)
  		    	 {
  		    		 
  		    	 }
  		    	 else
  		    	 {
  		    		 classname = className;
  		    	 }
  		       }
	  	    	
	  	          Object cls = Class.forName(classname).newInstance(); 
	  				Class c = cls.getClass();
	  		        Method[] meths = c.getDeclaredMethods();
	  		       
	  		        if (meths.length != 0) 
	  		        {
	  		        for (Method m : meths)
	  		        {
	  		        	
	  		        	int comparisonResult = ab.compareTo(m.getName());
	  		        	
			        	 if(comparisonResult == 0)
		  		        	{
		  		        		if(num1.length == 1)
		  		        		{
		  		        			Object o = m.invoke(cls,num1[0]);
		  		        			boolean di = (Boolean)o;
		  		        			int dis = t+1;
						            if(String.valueOf(di) == "true")
										{
						        		System.out.println("The Precondition : " +dis+ " is correct");	
										}
						        	else
										{
											System.out.println("CONTRACT VIOLATION");
											System.out.println("PRECONDITION : " +dis+ " IS WRONG");	
											throw new ContractViolation("PRECONDITION "+dis+" IS WRONG");
						        	    } 
		  		        		}
		  		        		else if(num1.length == 2)
		  		        		{
		  		        			Object o = m.invoke(cls,num1[0],num1[1]);
		  		        			boolean di = (Boolean)o;
		  		        			int dis = t+1;
		  		        			 if(String.valueOf(di) == "true")
										{
						        		System.out.println("The Precondition : " +dis+ " is correct");	
										}
						        	else
										{
											System.out.println("CONTRACT VIOLATION");
											System.out.println("PRECONDITION : " +dis+ " IS WRONG");
											throw new ContractViolation("PRECONDITION "+dis+" IS WRONG");
						        	    } 
		  		        		}
		  		        		else if(num1.length == 3)
		  		        		{
		  		        			Object o = m.invoke(cls,num1[0],num1[1],num1[2]);
		  		        			boolean di = (Boolean)o;
		  		        			int dis = t+1;
		  		        			 if(String.valueOf(di) == "true")
										{
						        		System.out.println("The Precondition : " +dis+ " is correct");	
										}
						        	else
										{
											System.out.println("CONTRACT VIOLATION");
											System.out.println("PRECONDITION : " +dis+ " IS WRONG");	
											throw new ContractViolation("PRECONDITION "+dis+" IS WRONG");
						        	    } 
		  		        		}
		  		        		else if(num1.length == 4)
		  		        		{
		  		        			Object o = m.invoke(cls,num1[0],num1[1],num1[2],num1[3]);
		  		        			boolean di = (Boolean)o;
		  		        			int dis = t+1;
		  		        			 if(String.valueOf(di) == "true")
										{
						        		System.out.println("The Precondition : " +dis+ " is correct");	
										}
						        	else
										{
											System.out.println("CONTRACT VIOLATION");
											System.out.println("PRECONDITION : " +dis+ " IS WRONG");
											throw new ContractViolation("PRECONDITION "+dis+" IS WRONG");
						        	    } 
		  		        		}
		  		        		else if(num1.length == 5)
		  		        		{
		  		        			Object o = m.invoke(cls,num1[0],num1[1],num1[2],num1[3],num1[4]);
		  		        			boolean di = (Boolean)o;
		  		        			int dis = t+1;
		  		        			 if(String.valueOf(di) == "true")
										{
						        		System.out.println("The Precondition : " +dis+ " is correct");	
										}
						        	else
										{
											System.out.println("CONTRACT VIOLATION");
											System.out.println("PRECONDITION : " +dis+ " IS WRONG");	
											throw new ContractViolation("PRECONDITION "+dis+" IS WRONG");
						        	    } 
		  		        		}
		  		        		else if(num1.length == 6)
		  		        		{
		  		        			Object o = m.invoke(cls,num1[0],num1[1],num1[2],num1[3],num1[4],num1[5]);
		  		        			boolean di = (Boolean)o;
		  		        			int dis = t+1;
		  		        			 if(String.valueOf(di) == "true")
										{
						        		System.out.println("The Precondition : " +dis+ " is correct");	
										}
						        	else
										{
											System.out.println("CONTRACT VIOLATION");
											System.out.println("PRECONDITION : " +dis+ " IS WRONG");	
											throw new ContractViolation("PRECONDITION "+dis+" IS WRONG");
						        	    } 
		  		        		}
		  		        		else if(num1.length == 7)
		  		        		{
		  		        			Object o = m.invoke(cls,num1[0],num1[1],num1[2],num1[3],num1[4],num1[5],num1[6]);
		  		        			boolean di = (Boolean)o;
		  		        			int dis = t+1;
		  		        			 if(String.valueOf(di) == "true")
										{
						        		System.out.println("The Precondition : " +dis+ " is correct");	
										}
						        	else
										{
											System.out.println("CONTRACT VIOLATION");
											System.out.println("PRECONDITION : " +dis+ " IS WRONG");	
											throw new ContractViolation("PRECONDITION "+dis+" IS WRONG");
						        	    } 
		  		        		}
		  		        		else
		  		        		{
		  		        		Object o = m.invoke(cls,num1[0],num1[1],num1[2],num1[3],num1[4],num1[5],num1[6],num1[7]);
		  		        	
		  		        		boolean di = (Boolean)o;
		  		        		int dis = t+1;
		  		        		 if(String.valueOf(di) == "true")
									{
					        		System.out.println("The Precondition : " +dis+ " is correct");	
									}
					        	else
									{
										System.out.println("CONTRACT VIOLATION");
										System.out.println("PRECONDITION : " +dis+ " IS WRONG");
										throw new ContractViolation("PRECONDITION "+dis+" IS WRONG");
					        	    } 
		  		        		}
		  			     
		  			      
		  			      
		  		        	}//close of comparisonResult == 0
	  		        
	  		        }
	  		        }
		  
		  }
		
		    
		    else if(pre_cond[t].contains("=="))
		    {
		    	flag=6;
		        if(pre_cond[t].contains("."))
			    {
		        	objflag=1;
			        //System.out.println("The argument has object contracts");
					String foo=pre_cond[t];
					int u=0;
					int intflagindex=0;
			        objflag=1;
				        		
				    Object[] num1 = thisJoinPoint.getArgs();
				    String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
					Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
					        
				    String[] result=foo.split("\\=="); 
				    String[] parts = foo.split("==");
			        String part1 = parts[0].trim(); 
			        String part2 = parts[1].trim(); 
				        
			        int gh=0;
			        	
			        for (u = 0; u < num1.length; u++) 
			        {
			        	String part3 = names[u].trim();
					    if(part2.equals(part3))
					    {
					    	intflag = 1;	
					    	intflagindex = u;
					    }
					    else if(types[u].getName().equals("String"))
					    {
					    	stringflag = 1;
					    	stringflagindex=u;
					    }
					    else
					    {
					    	intflag = 0;
					    }
			        }
			        	
			        int i;
				    String classname=null;
				    gh=0;
				   
				    
				    
				    String className = null;
		  	          for(gh=0;gh<num1.length;gh++)
		  		       {
		  		        
		  		   	  className = types[gh].getName();
		  		   	  boolean objcompareint;
		  		    boolean objcomparestring;
		  		   	  objcompareint = Objects.equals(className, "int");
		  		   	objcomparestring = Objects.equals(className, "java.lang.String");
		  		   	
		  		    	 if(objcompareint == true && objcomparestring == false)
		  		    	 {
		  		    		  
		  		    	  }
		  		    	 else if(objcompareint == false && objcomparestring == true)
		  		    	 {
		  		    		 
		  		    	 }
		  		    	 else
		  		    	 {
		  		    		 classname = className;
		  		    	 }
		  		       }
		  	          
				    String parsecondition = pre_cond[t];
				  
				    int condparsefrom=0;
				    int condparseto=0;
				    i=0;
				    for(int parseindex=0;parseindex<parsecondition.length();parseindex++)
				    {
				    	char ch = parsecondition.charAt(parseindex);
				    	if(ch == '.')
				    	{
				    		condparsefrom = parseindex+1;
				    	}
				    	if(ch == '>' || ch == '<' || ch =='!' || ch == '=')
				    	{
				    		condparseto = parseindex-1;
				    		int hj = parseindex;
				    		char ch1 = parsecondition.charAt(hj);
				    		if(ch1 == '=')
				    		{
				    			condparseto = parseindex-2;
				    		 }
				    	 }
				     }
				     char arrsd[] = new char[condparseto - condparsefrom + 1];
				     int j=1;
				     arrsd[0] = Character.toUpperCase(parsecondition.charAt(condparsefrom));
				     for(int lk=condparsefrom+1;lk<condparseto+1;lk++)
				     {
				    	 arrsd[j] = parsecondition.charAt(lk);
				    	 j++;
				     }
				     String ab = new String(arrsd);
				     String s2 = classname + "." + "get"+ab+"()";
				     String s3 = "get" + ab;
				     
				     Object cls = Class.forName(classname).newInstance(); 
				     Class c = cls.getClass();
				     Method[] meths = c.getDeclaredMethods();
				     if (meths.length != 0) 
				     {
				    	 for (Method m : meths)
				    	 {
				    		 int comparisonResult = s3.compareTo(m.getName());
				        	 if(comparisonResult == 0)
				        	 {
				        		 Object bbb = m.invoke(cls);
				        		 part2.trim().replace("'", "");
				        		 int dis = t+1;
				        		 if(stringflag == 0 && (bbb.toString().equals(part2.trim().replace("'", "").toString()))==true)
				        		 {
				        		
									System.out.println("The Precondition : " +dis+ " is correct");
				        		 }
				        		 else if(stringflag == 1 && bbb.toString().equals((String)num1[stringflagindex])==true)
								 {
				        			 System.out.println("The Precondition : " +dis+ " is correct");
				        		 
								 }
				        		 else
				        		 {
									System.out.println("CONTRACT VIOLATION");
									System.out.println("PRECONDITION : " +dis+ "IS WRONG");
									throw new ContractViolation("PRECONDITION "+dis+" IS WRONG");
								}
				        
				        	 }
				           }
				       }
				       else
				       {
				    	   System.out.println("  -- no methods --%n");
				       }  
			      } // close for . of ==
		      } // close of else
		    else
		    {
		    	//Not supported
		    }
		   } // end of main for loop
		}//end of pre_cond     
    	}//end of main else if annotaion instance of contract
	    
	    //beginning of lambda contracts
	    
	    if(annotation instanceof ContractLambda)
	    {
	    	System.out.println("");
	    	System.out.println("Checking for Contracts for the method : " +sig.getName());
	    	
	    	ContractLambda annos = (ContractLambda) annotation;
	    	String[] invariant_cond_lambda = annos.invariant_cond_lambda();
	    	String[] pre_cond_lambda = annos.pre_cond_lambda();
	    	
	    	if(invariant_cond_lambda.length>=1)
	    	{
	    	System.out.println("");
			System.out.println("Checking for Invariants for Lambda Expressions ");
			
			String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
        	Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
        	Object[] num1 = thisJoinPoint.getArgs();
        	
		    System.out.println( "The Invariant for Lambda Expressions are : " + Arrays.asList(invariant_cond_lambda));
		  
		    System.out.println("The Total num of Invariants for Lambda Expressions are:"+invariant_cond_lambda.length);
		    int t=0;
		   
		    
		    for(t=0;t<invariant_cond_lambda.length;t++)
		    {
		    	String foo=invariant_cond_lambda[t];
		    	String[] parts = foo.split("->");
		    	String part1 = parts[0].trim();
		    	
		    	
		    	int value_lambda_int=0;
		    	String value_lambda_string=null;
		    	float value_lambda_float=0;
		    	double value_lambda_double=0;
		    	boolean value_lambda_boolean=false;
		    	long value_lambda_long=0;
		    	char value_lambda_char=0;
		    	
		    	
		        String str2 = invariant_cond_lambda[0];
		        
		        int lambdaint=0;
		        int lambdastring=0;
		        int lambdafloat=0;
		        int lambdadouble=0;
		        int lambdaboolean=0;
		        int lambdalong=0;
		        int lambdachar=0;
		        
		        for(int argsk=0;argsk<num1.length;argsk++)
	        	{
	        		
	        		if(part1.equals(names[argsk]))
	        		{
	        			
	        			if(types[argsk].getName().equals("int"))
	        			{
	        				value_lambda_int = (Integer)num1[argsk];
	        				lambdaint=1;
	        			}
	        			if(types[argsk].getName().equals("java.lang.String"))
	        			{
	        				value_lambda_string = (String)num1[argsk];
	        				lambdastring=1;
	        			}
	        			if(types[argsk].getName().equals("float"))
	        			{
	        				value_lambda_float = (Float)num1[argsk];
	        				lambdafloat=1;
	        			}
	        			if(types[argsk].getName().equals("double"))
	        			{
	        				value_lambda_double = (Double)num1[argsk];
	        				lambdadouble=1;
	        			}
	        			if(types[argsk].getName().equals("boolean"))
	        			{
	        				value_lambda_boolean = (Boolean)num1[argsk];
	        				lambdaboolean=1;
	        			}
	        			if(types[argsk].getName().equals("long"))
	        			{
	        				value_lambda_long = (Long)num1[argsk];
	        				lambdalong=1;
	        			}
	        			if(types[argsk].getName().equals("char"))
	        			{
	        				value_lambda_char = (Character)num1[argsk];
	        				lambdachar=1;
	        			}
	        		  
	        		}
	        	}
		       
		        if(lambdaint == 1)
		        {
		        Function<Integer, Boolean> lambda = factory.createLambdaUnchecked(
		        		foo, new TypeReference<Function<Integer, Boolean>>() {});
		     
		        boolean n = lambda.apply(value_lambda_int);
		        int dis = t+1;
		        if(n == true)
		        {
		        	System.out.println("The Invariants for lambda expression : " +dis+ " is correct");			
		        }
		        else
				{
					System.out.println("INVARIANT FOR LAMBDA EXPRESSION VIOLATION");
					System.out.println("INVARIANT FOR LAMBDA EXPRESSION VIOLATION : " +dis+ " IS WRONG");	
					throw new ContractViolation("IINVARIANT FOR LAMBDA EXPRESSION VIOLATION " +dis+ " IS WRONG");
        	    } 
		      
		        }//close of  if(lambdaint == 1)
		        if(lambdastring == 1)
		        {
		        Function<String, Boolean> lambda = factory.createLambdaUnchecked(
		        		foo, new TypeReference<Function<String, Boolean>>() {});
		     
		        boolean n = lambda.apply(value_lambda_string);
		        int dis = t+1;
		        if(n == true)
		        {
		        	System.out.println("The Invariants for lambda expression : " +dis+ " is correct");			
		        }
		        else
				{
					System.out.println("INVARIANT FOR LAMBDA EXPRESSION VIOLATION");
					System.out.println("INVARIANT FOR LAMBDA EXPRESSION VIOLATION : " +dis+ " IS WRONG");	
					throw new ContractViolation("INVARIANT FOR LAMBDA EXPRESSION VIOLATION " +dis+ " IS WRONG");
        	    } 
		      
		        }//close of  if(lambdastring == 1)
		      
		        if(lambdafloat == 1)
		        {
		        Function<Float, Boolean> lambda = factory.createLambdaUnchecked(
		        		foo, new TypeReference<Function<Float, Boolean>>() {});
		     
		        boolean n = lambda.apply(value_lambda_float);
		        int dis = t+1;
		        if(n == true)
		        {
		        	System.out.println("The Invariants for lambda expression : " +dis+ " is correct");			
		        }
		        else
				{
					System.out.println("INVARIANT FOR LAMBDA EXPRESSION VIOLATION");
					System.out.println("INVARIANT FOR LAMBDA EXPRESSION VIOLATION : " +dis+ " IS WRONG");	
					throw new ContractViolation("INVARIANT FOR LAMBDA EXPRESSION VIOLATION " +dis+ " IS WRONG");
        	    } 
		      
		        }//close of  if(lambdafloat == 1)
		        
		        if(lambdadouble == 1)
		        {
		        Function<Double, Boolean> lambda = factory.createLambdaUnchecked(
		        		foo, new TypeReference<Function<Double, Boolean>>() {});
		     
		        boolean n = lambda.apply(value_lambda_double);
		        int dis = t+1;
		        if(n == true)
		        {
		        	System.out.println("The Invariants for lambda expression : " +dis+ " is correct");			
		        }
		        else
				{
					System.out.println("INVARIANT FOR LAMBDA EXPRESSION VIOLATION");
					System.out.println("INVARIANT FOR LAMBDA EXPRESSION VIOLATION : " +dis+ " IS WRONG");	
					throw new ContractViolation("INVARIANT FOR LAMBDA EXPRESSION VIOLATION " +dis+ " IS WRONG");
        	    } 
		      
		        }//close of  if(lambdadouble == 1)
		        
		        if(lambdaboolean == 1)
		        {
		        Function<Boolean, Boolean> lambda = factory.createLambdaUnchecked(
		        		foo, new TypeReference<Function<Boolean, Boolean>>() {});
		     
		        boolean n = lambda.apply(value_lambda_boolean);
		        int dis = t+1;
		        if(n == true)
		        {
		        	System.out.println("The Invariants for lambda expression : " +dis+ " is correct");			
		        }
		        else
				{
					System.out.println("INVARIANT FOR LAMBDA EXPRESSION VIOLATION");
					System.out.println("INVARIANT FOR LAMBDA EXPRESSION VIOLATION : " +dis+ " IS WRONG");	
					throw new ContractViolation("INVARIANT FOR LAMBDA EXPRESSION VIOLATION " +dis+ " IS WRONG");
        	    } 
		      
		        }//close of  if(lambdaboolean == 1)
		        
		        if(lambdalong == 1)
		        {
		        Function<Long, Boolean> lambda = factory.createLambdaUnchecked(
		        		foo, new TypeReference<Function<Long, Boolean>>() {});
		     
		        boolean n = lambda.apply(value_lambda_long);
		        int dis = t+1;
		        if(n == true)
		        {
		        	System.out.println("The Invariants for lambda expression : " +dis+ " is correct");			
		        }
		        else
				{
					System.out.println("INVARIANT FOR LAMBDA EXPRESSION VIOLATION");
					System.out.println("INVARIANT FOR LAMBDA EXPRESSION VIOLATION : " +dis+ " IS WRONG");	
					throw new ContractViolation("INVARIANT FOR LAMBDA EXPRESSION VIOLATION " +dis+ " IS WRONG");
        	    } 
		      
		        }//close of  if(lambdalong == 1)
		        
		        if(lambdachar == 1)
		        {
		        Function<Character, Boolean> lambda = factory.createLambdaUnchecked(
		        		foo, new TypeReference<Function<Character, Boolean>>() {});
		     
		        boolean n = lambda.apply(value_lambda_char);
		        int dis = t+1;
		        if(n == true)
		        {
		        	System.out.println("The Invariants for lambda expression : " +dis+ " is correct");			
		        }
		        else
				{
					System.out.println("INVARIANT FOR LAMBDA EXPRESSION VIOLATION");
					System.out.println("INVARIANT FOR LAMBDA EXPRESSION VIOLATION : " +dis+ " IS WRONG");	
					throw new ContractViolation("INVARIANT FOR LAMBDA EXPRESSION VIOLATION " +dis+ " IS WRONG");
        	    } 
		      
		        }//close of  if(lambdachar == 1)
		    }//close of for loop for all invariant condition lambdas
	    	
	    	}//close of invariant_cond_lambda>=1
	    	
	    	
	    	//Beginning of precondition for Lambda expressions:
	    	
	    	if(pre_cond_lambda.length>=1)
	    	{
	    	System.out.println("");
			//System.out.println("Checking for Preconditions for Lambda Expressions ");
			
			String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
        	Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
        	Object[] num1 = thisJoinPoint.getArgs();
        	
		    System.out.println( "The Preconditions for Lambda Expressions are : " + Arrays.asList(pre_cond_lambda));
		  
		    System.out.println("The Total num of Preconditions for Lambda Expressions are:"+pre_cond_lambda.length);
		    int t=0;
		   
		    
		    for(t=0;t<pre_cond_lambda.length;t++)
		    {
		    	String foo=pre_cond_lambda[t];
		    	String[] parts = foo.split("->");
		    	String part1 = parts[0].trim();
		    	
		    	int value_lambda_int=0;
		    	String value_lambda_string=null;
		    	float value_lambda_float=0;
		    	double value_lambda_double=0;
		    	boolean value_lambda_boolean=false;
		    	long value_lambda_long=0;
		    	char value_lambda_char=0;
		    	
		    	
		        String str2 = invariant_cond_lambda[0];
		        
		        int lambdaint=0;
		        int lambdastring=0;
		        int lambdafloat=0;
		        int lambdadouble=0;
		        int lambdaboolean=0;
		        int lambdalong=0;
		        int lambdachar=0;
		        
		        
		        for(int argsk=0;argsk<num1.length;argsk++)
	        	{

	        		if(part1.equals(names[argsk]))
	        		{
	        			
	        			if(types[argsk].getName().equals("int"))
	        			{
	        				value_lambda_int = (Integer)num1[argsk];
	        				lambdaint=1;
	        			}
	        			if(types[argsk].getName().equals("java.lang.String"))
	        			{
	        				value_lambda_string = (String)num1[argsk];
	        				lambdastring=1;
	        			}
	        			if(types[argsk].getName().equals("float"))
	        			{
	        				value_lambda_float = (Float)num1[argsk];
	        				lambdafloat=1;
	        			}
	        			if(types[argsk].getName().equals("double"))
	        			{
	        				value_lambda_double = (Double)num1[argsk];
	        				lambdadouble=1;
	        			}
	        			if(types[argsk].getName().equals("boolean"))
	        			{
	        				value_lambda_boolean = (Boolean)num1[argsk];
	        				lambdaboolean=1;
	        			}
	        			if(types[argsk].getName().equals("long"))
	        			{
	        				value_lambda_long = (Long)num1[argsk];
	        				lambdalong=1;
	        			}
	        			if(types[argsk].getName().equals("char"))
	        			{
	        				value_lambda_char = (Character)num1[argsk];
	        				lambdachar=1;
	        			}
	        		}
	        	}
		       
		        if(lambdaint == 1)
		        {
		        Function<Integer, Boolean> lambda = factory.createLambdaUnchecked(
		        		foo, new TypeReference<Function<Integer, Boolean>>() {});
		     
		        boolean n = lambda.apply(value_lambda_int);
		        int dis = t+1;
		        if(n == true)
		        {
		        	System.out.println("The Preconditions for Lambda Expression : " +dis+ " is correct");			
		        }
		        else
				{
					System.out.println("PRECONDITION FOR LAMBDA EXPRESSION VIOLATION");
					System.out.println("PRECONDITION FOR LAMBDA EXPRESSION VIOLATION : " +dis+ " IS WRONG");	
					throw new ContractViolation("PRECONDITION FOR LAMBDA EXPRESSION VIOLATION " +dis+ " IS WRONG");
        	    } 
		      
		        }//close of  if(lambdaint == 1)
		        if(lambdastring == 1)
		        {
		        Function<String, Boolean> lambda = factory.createLambdaUnchecked(
		        		foo, new TypeReference<Function<String, Boolean>>() {});
		     
		        boolean n = lambda.apply(value_lambda_string);
		        int dis = t+1;
		        if(n == true)
		        {
		        	System.out.println("The Preconditions for Lambda Expression : " +dis+ " is correct");			
		        }
		        else
				{
					System.out.println("PRECONDITION FOR LAMBDA EXPRESSION VIOLATION");
					System.out.println("PRECONDITION FOR LAMBDA EXPRESSION VIOLATION : " +dis+ " IS WRONG");	
					throw new ContractViolation("PRECONDITION FOR LAMBDA EXPRESSION VIOLATION " +dis+ " IS WRONG");
        	    } 
		      
		        }//close of  if(lambdastring == 1)
		        
		        if(lambdafloat == 1)
		        {
		        Function<Float, Boolean> lambda = factory.createLambdaUnchecked(
		        		foo, new TypeReference<Function<Float, Boolean>>() {});
		     
		        boolean n = lambda.apply(value_lambda_float);
		        int dis = t+1;
		        if(n == true)
		        {
		        	System.out.println("The Preconditions for Lambda Expression : " +dis+ " is correct");			
		        }
		        else
				{
					System.out.println("PRECONDITION FOR LAMBDA EXPRESSION VIOLATION");
					System.out.println("PRECONDITION FOR LAMBDA EXPRESSION VIOLATION : " +dis+ " IS WRONG");	
					throw new ContractViolation("PRECONDITION FOR LAMBDA EXPRESSION VIOLATION " +dis+ " IS WRONG");
        	    } 
		      
		        }//close of  if(lambdafloat == 1)
		        
		        if(lambdadouble == 1)
		        {
		        Function<Double, Boolean> lambda = factory.createLambdaUnchecked(
		        		foo, new TypeReference<Function<Double, Boolean>>() {});
		     
		        boolean n = lambda.apply(value_lambda_double);
		        int dis = t+1;
		        if(n == true)
		        {
		        	System.out.println("The Preconditions for Lambda Expression : " +dis+ " is correct");			
		        }
		        else
				{
					System.out.println("PRECONDITION FOR LAMBDA EXPRESSION VIOLATION");
					System.out.println("PRECONDITION FOR LAMBDA EXPRESSION VIOLATION : " +dis+ " IS WRONG");	
					throw new ContractViolation("PRECONDITION FOR LAMBDA EXPRESSION VIOLATION " +dis+ " IS WRONG");
        	    } 
		      
		        }//close of  if(lambdadouble == 1)
		        
		        if(lambdaboolean == 1)
		        {
		        Function<Boolean, Boolean> lambda = factory.createLambdaUnchecked(
		        		foo, new TypeReference<Function<Boolean, Boolean>>() {});
		     
		        boolean n = lambda.apply(value_lambda_boolean);
		        int dis = t+1;
		        if(n == true)
		        {
		        	System.out.println("The Preconditions for Lambda Expression : " +dis+ " is correct");			
		        }
		        else
				{
					System.out.println("PRECONDITION FOR LAMBDA EXPRESSION VIOLATION");
					System.out.println("PRECONDITION FOR LAMBDA EXPRESSION VIOLATION : " +dis+ " IS WRONG");	
					throw new ContractViolation("PRECONDITION FOR LAMBDA EXPRESSION VIOLATION " +dis+ " IS WRONG");
        	    } 
		      
		        }//close of  if(lambdaboolean == 1)
		        
		        if(lambdalong == 1)
		        {
		        Function<Long, Boolean> lambda = factory.createLambdaUnchecked(
		        		foo, new TypeReference<Function<Long, Boolean>>() {});
		     
		        boolean n = lambda.apply(value_lambda_long);
		        int dis = t+1;
		        if(n == true)
		        {
		        	System.out.println("The Preconditions for Lambda Expression : " +dis+ " is correct");			
		        }
		        else
				{
					System.out.println("PRECONDITION FOR LAMBDA EXPRESSION VIOLATION");
					System.out.println("PRECONDITION FOR LAMBDA EXPRESSION VIOLATION : " +dis+ " IS WRONG");	
					throw new ContractViolation("PRECONDITION FOR LAMBDA EXPRESSION VIOLATION " +dis+ " IS WRONG");
        	    } 
		      
		        }//close of  if(lambdalong == 1)
		        
		        if(lambdachar == 1)
		        {
		        Function<Character, Boolean> lambda = factory.createLambdaUnchecked(
		        		foo, new TypeReference<Function<Character, Boolean>>() {});
		     
		        boolean n = lambda.apply(value_lambda_char);
		        int dis = t+1;
		        if(n == true)
		        {
		        	System.out.println("The Preconditions for Lambda Expression : " +dis+ " is correct");			
		        }
		        else
				{
					System.out.println("PRECONDITION FOR LAMBDA EXPRESSION VIOLATION");
					System.out.println("PRECONDITION FOR LAMBDA EXPRESSION VIOLATION : " +dis+ " IS WRONG");	
					throw new ContractViolation("PRECONDITION FOR LAMBDA EXPRESSION VIOLATION " +dis+ " IS WRONG");
        	    } 
		      
		        }//close of  if(lambdachar == 1)
		      
		    }//close of for loop for all invariant condition lambdas
	    	
	    	}//close of pre_cond_lambda>=1
	    	
	    }//close of if(annotation instanceof ContractLambda)
	    
	    
	}//end of one more for Annotation annotation : annost
		
		
 }//end of try
 catch(Exception e) 
 {
	 // TODO Auto-generated catch block
	 e.printStackTrace();
 }
	
}//end of before advice		
		    		
		    		
//The after advice		    		
after() returning(Object objret): function()
{
		/*
		The flag values are:
		objflag = 1 : For object contracts
		flag = 1 :For > symbol
		flag = 2 :For < symbol
		flag = 3 :For >= symbol
		flag = 4 :For <= symbol
		flag = 5 :For != symbol
		flag = 6 :For == symbol
		intflag = 0 :For normal integers, ex: num < 0
		intflag =1 : For argument integers, ex: num < val, where val is an argument
		stringflag = 0: For string comparisons like, ex: position = "Full time"
		stringflag =1 : For string comparisons like, ex: position = string_val where string_val is an argument
		*/
		int flag = 0;
		int objflag =0;
		int intflag=0;
		int stringflag=0;
		
		int stringflagindex = 0;
		
		
		Signature sig = thisJoinPoint.getSignature();
		Method method = ((MethodSignature)sig).getMethod();
		Annotation[] annost = method.getDeclaredAnnotations();
		LambdaFactory factory=LambdaFactory.get();
		
	    try
	    {
    
		for(Annotation annotation : annost)
		{
			if(annost == null)
			{
				
			}
			
			else if(annotation instanceof Contract)
			{
				Contract annospost = (Contract) annotation;
		    	
		    	 String[] post_cond = annospost.post_cond();
		    	 String[] invariant_cond = annospost.invariant_cond();
		    	
		    	if(post_cond.length>=1)
		    	{
				System.out.println("");
				System.out.println("Checking for Postconditions ");
				
		        
		        System.out.println("After executing the function : ");
			   
			    
		        System.out.println( "The Postconditions are : " + Arrays.asList(post_cond));
		       
		        System.out.println("The Total num of Postconditions are:"+post_cond.length);
		        
			    
		        //To check if the condition has an object which is of the form Classname.object for bean property.
		        int t;
		        for(t=0;t<post_cond.length;t++)
		        {
		        	if(post_cond[t].contains("."))
		        	{
		        		objflag=1;
		        	}
		        }
		        
		        //for loop to locate the symbols in the condition
		        for(t=0;t<post_cond.length;t++)
		        {
		        	if(post_cond[t].contains(">="))
		        	{
		        		flag=3;
		        		if(post_cond[t].contains("."))
			        	{
		        			objflag=1;
			        		//System.out.println("The argument has object contracts");
					        String foo=post_cond[t];
						    int u=0;
						    int intflagindex=0;
			        	    objflag=1;
				        	String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
					        Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
					       
					        Object[] num1 = thisJoinPoint.getArgs();
					        
						    String[] result=foo.split("\\>="); 
						    String[] parts = foo.split(">=");
						    String part1 = parts[0].trim(); 
						    String part2 = parts[1].trim(); 
				        
						    for (u = 0; u < num1.length; u++) 
						    {
						    	String part3 = names[u].trim();
						    	if(part2.equals(part3))
						    	{
						    		intflag = 1;	
						    		intflagindex = u;
						    	}
						    	else
						    	{
						    		intflag = 0;
						    	}
						    }
			        	
			        
			            int i;
				        String classname=null;
				        int gh=0;
				        String className = null;
			  	          for(gh=0;gh<num1.length;gh++)
			  		       {
			  		        
			  		   	  className = types[gh].getName();
			  		   	  boolean objcompareint;
			  		    boolean objcomparestring;
			  		   	  objcompareint = Objects.equals(className, "int");
			  		   	objcomparestring = Objects.equals(className, "java.lang.String");
			  		   	
			  		    	 if(objcompareint == true && objcomparestring == false)
			  		    	 {
			  		    		  
			  		    	  }
			  		    	 else if(objcompareint == false && objcomparestring == true)
			  		    	 {
			  		    		 
			  		    	 }
			  		    	 else
			  		    	 {
			  		    		 classname = className;
			  		    	 }
			  		       }
				    	String parsecondition = post_cond[t];
				        int condparsefrom=0;
				        int condparseto=0;
				        i=0;
				        for(int parseindex=0;parseindex<parsecondition.length();parseindex++)
				        {
				        	char ch = parsecondition.charAt(parseindex);
				        	if(ch == '.')
				        	{
				        		condparsefrom = parseindex+1;
				        	}
				        	if(ch == '>' || ch == '<' || ch =='!' || ch == '=')
				        	{
				        		condparseto = parseindex-1;
				        		int hj = parseindex;
				        		char ch1 = parsecondition.charAt(hj);
				        		if(ch1 == '=')
				        		{
				        			condparseto = parseindex-2;
				        		}
				        	}
				        }
				       
				        char arrsd[] = new char[condparseto - condparsefrom +1];
				        int j=1;
				        arrsd[0] = Character.toUpperCase(parsecondition.charAt(condparsefrom));
				        for(int lk=condparsefrom+1;lk<condparseto+1;lk++)
				        {
				      	   arrsd[j] = parsecondition.charAt(lk);
				    	   j++;
				        }
				        String ab = new String(arrsd);
				        String s2 = classname + "." + "get"+ab+"()";
				        String s3 = "get" + ab;
				        Object cls = Class.forName(classname).newInstance(); 
				        Class c = cls.getClass();
				   
				        Method[] meths = c.getDeclaredMethods();
				       
				        if (meths.length != 0) 
				        {
				        for (Method m : meths)
				        {
				        	int comparisonResult = s3.compareTo(m.getName());
				        	if(comparisonResult == 0)
				        	{
				        		Object bbb = m.invoke(cls);
				        		int numb = Integer.parseInt( bbb.toString() );
				        		int dis = t+1;
				        		if(intflag == 0 && (Integer)objret >= Integer.parseInt(part2.trim()))
				        		{
				        			System.out.println("The Postcondition : " +dis+ "is correct");
								
				        		}
				        		else if(intflag == 1 && (Integer)objret >= (Integer)num1[intflagindex])
				        		{
				        			System.out.println("The Postcondition : " +dis+ " is correct");
								}
								else
								{
									System.out.println("CONTRACT VIOLATION");
									System.out.println("POSTCONDITION : " +dis+ "IS WRONG");
									throw new ContractViolation("POSTCONDITION "+dis+" IS WRONG");
														
				        	    }
				            }
				        }
				        }
				        else 
				        {
				        	System.out.println("  -- no methods --%n");
				        }  
				     }
		        	 else
		        	 {
		        	 int i=0;
					 String foo=post_cond[t];
				    			        
				     //Split the string to get the variable and result[0] has var,result[1] has 0. 
				     String[] result=foo.split(">="); 
				    		    		
				     //Split the string to get the variable and result[0] has var,result[1] has 0. 
				     Object[] num1 = thisJoinPoint.getArgs();
				     String parsecondition = foo;
					 int condparsefrom=0;
					 int condparseto=0;
					 int hj=0;
					 i=0;
					 int parseindex = 0;
					 for(parseindex=0;parseindex<parsecondition.length();parseindex++)
					 {
						 char ch = parsecondition.charAt(parseindex);
				    	 if(ch == '>' || ch == '<' || ch =='!' || ch == '=')
				    	 {
				    		 condparseto = parseindex-1;
							 hj = parseindex+1;
							 char ch1 = parsecondition.charAt(hj);
							 if(ch1 == '=')
							 {
								 condparseto = hj+1;
							 }
						 }
					  }
					  int condparsetoult = parseindex-1;
				      int ju=0;
				      char arrsd[] = new char[condparsetoult-condparseto];
				      for(int lk=hj;lk<parsecondition.length();lk++)
					  {
				    	  arrsd[ju] = parsecondition.charAt(lk);
				    	  ju++;
					  }
				      String ab = new String(arrsd);
				      String part1 = result[0].trim(); 
				      String part2 = ab.trim();
				      result[1] = ab.trim();
				      int wl;
				      int wr;
				      int wl1=0;
				      int wr1=0;
				      int occurnceleft = 0;
				      int occurncetypeleft = 0;
				      int occurnceright = 0;
				      int occurncetyperight = 0;
				      int leftside=0;
				      int rightside=0;
				    				
				      String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
				      Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
				    			    
				      for (wl = 0; wl < num1.length; wl++) 
				      {
				    	  if(part1.equals(names[wl]))
				    	  {
				    		  occurnceleft = 1;
				    		  wl1=wl;
				    		  if(types[wl].getName().equals("int"))
				    		  {
				    			  occurncetypeleft=1;
				    		  }
				    	  }
				      }
				      occurnceleft =2;
				      for (wr = 0; wr < num1.length; wr++) 
				      {	  
				    	  if(part2.equals(names[wr]))
				    	  {
				    		  occurnceright = 1;
				    		  if(types[wr].getName().equals("int"))
				    		  {
				    			  occurncetyperight = 1;
				    		  }
				    	  }
				      } 
				      if(occurnceleft == 2)
				      {
				    	  if(occurnceright == 1 && occurncetyperight == 1)
				    	  {
				    		  leftside=(Integer)objret;
				    		  rightside = (Integer) (num1[wr1]);
				    	  }
				    	  else if(occurnceright == 0 && occurncetyperight == 0)
				    	  {
				    		  leftside=(Integer)objret;
				    		  rightside = Integer.parseInt(result[1]);
				    	  }
				    	  else
				    	  {
				    	  }
				       }
				       else 
				       {
				    			    		  
				       }
				      int n=i;
				      int count=n+1;
				      int dis = t+1;
				      if(leftside >= rightside)
				      {
				    	  System.out.println("The Postcondition: " +dis+ "  is correct");
				      }
				      else
				      {
				    	  System.out.println("CONTRACT VIOLATION");
				    	  System.out.println("POSTCONDITION : " +dis+ " IS WRONG");
				    	  throw new ContractViolation("POSTCONDITION "+dis+" IS WRONG");
				      }
				    }
		        		
		        }//end of post_cond[t].contains(">=")
		        else if(post_cond[t].contains(">"))
		        {
		        	flag=1;
		        	if(post_cond[t].contains("."))
			        {
		        		//System.out.println("The argument has object contracts");
				        String foo=post_cond[t];
					    int u=0;
					    int intflagindex=0;
		        		objflag=1;
			        	{
			        		Object[] num1 = thisJoinPoint.getArgs();
						    String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
							Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
							String[] result=foo.split("\\>"); 
						    String[] parts = foo.split(">");
						    String part1 = parts[0].trim(); 
					        String part2 = parts[1].trim();
						        
					        for (u = 0; u < num1.length; u++) 
					        {
					        	String part3 = names[u].trim();
							    if(part2.equals(part3))
							    {
							    	intflag = 1;	
							    	intflagindex = u;
							    }
							    else
							    {
							    	intflag = 0;
							    }
					        }
					        int i;	         
					        String classname=null;
						    int gh=0;
						    String className = null;
				  	          for(gh=0;gh<num1.length;gh++)
				  		       {
				  		        
				  		   	  className = types[gh].getName();
				  		   	  boolean objcompareint;
				  		    boolean objcomparestring;
				  		   	  objcompareint = Objects.equals(className, "int");
				  		   	objcomparestring = Objects.equals(className, "java.lang.String");
				  		   	
				  		    	 if(objcompareint == true && objcomparestring == false)
				  		    	 {
				  		    		  
				  		    	  }
				  		    	 else if(objcompareint == false && objcomparestring == true)
				  		    	 {
				  		    		 
				  		    	 }
				  		    	 else
				  		    	 {
				  		    		 classname = className;
				  		    	 }
				  		       }
						    String parsecondition = post_cond[t];
						    int condparsefrom=0;
						    int condparseto=0;
						    i=0;
						    for(int parseindex=0;parseindex<parsecondition.length();parseindex++)
						    {
						    	char ch = parsecondition.charAt(parseindex);
						    	if(ch == '.')
						    	{
						    		condparsefrom = parseindex+1;
						    	}
						    	if(ch == '>' || ch == '<' || ch =='!' || ch == '=')
						    	{
						    		condparseto = parseindex-1;
						    	}
						     }
						     char arrsd[] = new char[condparseto - condparsefrom +1];
						     int j=1;
						     arrsd[0] = Character.toUpperCase(parsecondition.charAt(condparsefrom));
						     for(int lk=condparsefrom+1;lk<condparseto+1;lk++)
						     {
						    	 arrsd[j] = parsecondition.charAt(lk);
						    	 j++;
						     }
						     String ab = new String(arrsd);
						     String s2 = classname + "." + "get"+ab+"()";
						     String s3 = "get" + ab;
						     Object cls = Class.forName(classname).newInstance(); 
						     Class c = cls.getClass();
						     Method[] meths = c.getDeclaredMethods();
						     if (meths.length != 0) 
						     {
						    	 for (Method m : meths)
						    	 {
						    		 int comparisonResult = s3.compareTo(m.getName());
						    		 if(comparisonResult == 0)
						    		 {
						    			 Object bbb = m.invoke(cls);
						    			 int numb = Integer.parseInt( bbb.toString() );
						    			 int dis = t+1;
						    			 if(intflag == 0 && (Integer)objret > Integer.parseInt(part2.trim()))
						    			 {
											System.out.println("The Postcondition : " +dis+ " is correct");
											
						    			 }
						    			 else if(intflag == 1 && (Integer)objret > (Integer)num1[intflagindex])
						    			 {
											System.out.println("The Postcondition : " +dis+ " is correct");
										 }
						    			 else
						    			 {
											System.out.println("CONTRACT VIOLATION");
											System.out.println("POSTCONDITION : " +dis+ " IS WRONG");
											throw new ContractViolation("POSTCONDITION "+dis+" IS WRONG");
																
						        	    }
						    		 }
						        }
						       }
						       else 
						       {
						    	   System.out.println("  -- no methods --%n");
						       } 	
			        	}
		        	}
		        	else
		        	{
		        		int i=0;
						String foo=post_cond[t];
				    			        
				    	//Split the string to get the variable and result[0] has var,result[1] has 0. 
				    	String[] result=foo.split(">"); 
				    		    		
				    	//Split the string to get the variable and result[0] has var,result[1] has 0. 
				    	Object[] num1 = thisJoinPoint.getArgs();
				    				
				    	String part1 = result[0].trim(); 
						String part2 = result[1].trim(); 
				    	int wl;
				    	int wr;
				    	int wl1=0;
				    	int wr1=0;
				    	int occurnceleft = 0;
				    	int occurncetypeleft = 0;
				    	int occurnceright = 0;
				    	int occurncetyperight = 0;
				    	int leftside=0;
				    	int rightside=0;
				    				
				    	String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
				    	Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
				    	for (wl = 0; wl < num1.length; wl++) 
				    	{
				    		if(part1.equals(names[wl]))
				    		{
				    			occurnceleft = 1;
				    			wl1=wl;
				    			if(types[wl].getName().equals("int"))
				    			{
				    				occurncetypeleft=1;
				    			}
				    		}
				    	}
				    	occurnceleft =2;
				    	for (wr = 0; wr < num1.length; wr++) 
				    	{	  
				    		if(part2.equals(names[wr]))
				    		{
				    			occurnceright = 1;
				    			if(types[wr].getName().equals("int"))
				    			{
				    				occurncetyperight = 1;
				    			}
				    		}
				    	} 
				    	if(occurnceleft == 2)
				    	{
				    		if(occurnceright == 1 && occurncetyperight == 1)
				    		{
				    			leftside=(Integer)objret;
				    			rightside = (Integer) (num1[wr1]);
				    		}
				    		else if(occurnceright == 0 && occurncetyperight == 0)
				    		{
				    			leftside=(Integer)objret;
				    			rightside = Integer.parseInt(result[1]);
				    		}
				    		else
				    		{
				    			    			  
				    		}
				    	}
				    	else 
				    	{
				    			    		  
				    	}
				    	int n=i;
				    	int count=n+1;
				    	int dis = t+1;
				    	if(leftside > rightside)
				    	{
				    		System.out.println("The Postcondition: " +dis+ "  is correct");
				    	}
				    	else
				    	{
				    		System.out.println("CONTRACT VIOLATION");
				    		System.out.println("POSTCONDITION : " +dis+ " IS WRONG");
				    		throw new ContractViolation("POSTCONDITION "+dis+" IS WRONG");
				    	}
				    			        	
				    }
		      }	//end of post_cond[t].contains(">")
		      else if(post_cond[t].contains("<="))
		      {
		    	  flag=4;
		    	  if(post_cond[t].contains("."))
			      {
		    		  objflag=1;
		    		 // System.out.println("The argument has object contracts");
					  String foo=post_cond[t];
					  int u=0;
					  int intflagindex=0;
					  objflag=1;
				      String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
					  Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
					  Object[] num1 = thisJoinPoint.getArgs();
					    
					  String[] result=foo.split("\\<="); 
				      String[] parts = foo.split("<=");
				      String part1 = parts[0].trim(); 
				      String part2 = parts[1].trim(); 
				        
				      for (u = 0; u < num1.length; u++) 
				      {
				    	  	String part3 = names[u].trim();
				    	  	if(part2.equals(part3))
				    	  	{
				    	  		intflag = 1;	
				    	  		intflagindex = u;
				    	  	}
				    	  	else
				    	  	{
				    	  		intflag = 0;
				    	  	}
			          }
				      int i;
				      String classname=null;
				      int gh=0;
				      String className = null;
		  	          for(gh=0;gh<num1.length;gh++)
		  		       {
		  		        
		  		   	  className = types[gh].getName();
		  		   	  boolean objcompareint;
		  		    boolean objcomparestring;
		  		   	  objcompareint = Objects.equals(className, "int");
		  		   	objcomparestring = Objects.equals(className, "java.lang.String");
		  		   	
		  		    	 if(objcompareint == true && objcomparestring == false)
		  		    	 {
		  		    		  
		  		    	  }
		  		    	 else if(objcompareint == false && objcomparestring == true)
		  		    	 {
		  		    		 
		  		    	 }
		  		    	 else
		  		    	 {
		  		    		 classname = className;
		  		    	 }
		  		       }
				    	String parsecondition = post_cond[t];
				       
				      
				        int condparsefrom=0;
				        int condparseto=0;
				         i=0;
				        for(int parseindex=0;parseindex<parsecondition.length();parseindex++)
				        {
				    	  char ch = parsecondition.charAt(parseindex);
				    	  if(ch == '.')
				    	  {
				    		  condparsefrom = parseindex+1;
				    	  }
				    	  if(ch == '>' || ch == '<' || ch =='!' || ch == '=')
				    	  {
				    		  condparseto = parseindex-1;
				    		  int hj = parseindex;
				    		  char ch1 = parsecondition.charAt(hj);
				    		  if(ch1 == '=')
				    		  {
				    			  condparseto = parseindex-2;
				    		  }
				    	  }
				        }
				      
				        char arrsd[] = new char[condparseto - condparsefrom +1];
				   
				        int j=1;
				        arrsd[0] = Character.toUpperCase(parsecondition.charAt(condparsefrom));
				        for(int lk=condparsefrom+1;lk<condparseto+1;lk++)
				        {
				      	   arrsd[j] = parsecondition.charAt(lk);
				    	   j++;
				        }
				      
			      
				        String ab = new String(arrsd);
				      
				        String s2 = classname + "." + "get"+ab+"()";
				     
				        String s3 = "get" + ab;
				      
				   
				        Object cls = Class.forName(classname).newInstance(); 
				        
				        
						Class c = cls.getClass();
				   
				
				        Method[] meths = c.getDeclaredMethods();
				       
				        if (meths.length != 0) 
				        {
				        for (Method m : meths)
				        {
				        	
				        	int comparisonResult = s3.compareTo(m.getName());
				        	if(comparisonResult == 0)
				        	{
				        
				        	Object bbb = m.invoke(cls);
				        	int numb = Integer.parseInt( bbb.toString() );
				        
				        	int dis = t+1;
				        	 if(intflag == 0 && (Integer)objret <= Integer.parseInt(part2.trim()))
								{
									System.out.println("The Postcondition : " +dis+ " is correct");
									
								}
				        	 else if(intflag == 1 && (Integer)objret <= (Integer)num1[intflagindex])
								{
									System.out.println("The Postcondition :  " +dis+ " is correct");
									
								}
								else
								{
									System.out.println("CONTRACT VIOLATION");
									System.out.println("POSTCONDITION : " +dis+ " IS WRONG");
									throw new ContractViolation("POSTCONDITION "+dis+" IS WRONG");
														
				        	    }
				        
				      
				        }
				        }
				        }
				       else {
				    	    System.out.println("  -- no methods --%n");
				            }  
				        }
		        		
		        		else
		        		{
		        			
						 int i=0;
						        
				         String foo=post_cond[t];
				   
				    //Split the string to get the variable and result[0] has var,result[1] has 0. 
				    String[] result=foo.split("<="); 
				    		    		
				    //Split the string to get the variable and result[0] has var,result[1] has 0. 
				    Object[] num1 = thisJoinPoint.getArgs();
				    				
				     String parsecondition = foo;
								     	       
								        int condparsefrom=0;
								        int condparseto=0;
								        int hj=0;
								         i=0;
								         int parseindex = 0;
								        for(parseindex=0;parseindex<parsecondition.length();parseindex++)
								        {
								        	char ch = parsecondition.charAt(parseindex);
				    				if(ch == '>' || ch == '<' || ch =='!' || ch == '=')
							    	  {
							    		  condparseto = parseindex-1;
							    		  hj = parseindex+1;
							    		  char ch1 = parsecondition.charAt(hj);
							    		  if(ch1 == '=')
							    		  {
							    		
							    			  condparseto = hj+1;
							    		  }
							    	  }
								        }
								        int condparsetoult = parseindex-1;
				    				int ju=0;
				    				char arrsd[] = new char[condparsetoult-condparseto];
				    				for(int lk=hj;lk<parsecondition.length();lk++)
							        {
							      	   arrsd[ju] = parsecondition.charAt(lk);
							    	   ju++;
							        }
							        String ab = new String(arrsd);
				    				String part1 = result[0].trim(); 
						        	String part2 = ab.trim();
							        result[1] = ab.trim();
				    				int wl;
				    				int wr;
				    				int wl1=0;
				    				int wr1=0;
				    				int occurnceleft = 0;
				    				int occurncetypeleft = 0;
				    				int occurnceright = 0;
				    				int occurncetyperight = 0;
				    				int leftside=0;
				    				int rightside=0;
				    				
				    				
				    				 String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
				    				 
				    			      Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
				    			    
				    			      for (wl = 0; wl < num1.length; wl++) {
					    		     	  
				    			    	  if(part1.equals(names[wl]))
				    			    	  {
				    			    		occurnceleft = 1;
				    			    		wl1=wl;
				    			    		  
				    			    		if(types[wl].getName().equals("int"))
				    			    		{
				    			    			occurncetypeleft=1;
				    			    		}
				    			    	  }
				    			      }
				    			      occurnceleft =2;
				    			    	  for (wr = 0; wr < num1.length; wr++) {	  
				    			    	
				    			    	
				    			    	  if(part2.equals(names[wr]))
				    			    	  {
				    			    		occurnceright = 1;
				    			    		if(types[wr].getName().equals("int"))
				    			    		{
				    			    			occurncetyperight = 1;
				    			    		}
				    			    	  }
				    			      } 
				    				  if(occurnceleft == 2)
				    			    	  {
				    			    		  if(occurnceright == 1 && occurncetyperight == 1)
				    			    		  {
				    			    			  leftside=(Integer)objret;
				    			    			  rightside = (Integer) (num1[wr1]);
				    			    			  
				    			    		  }
				    			    		  else if(occurnceright == 0 && occurncetyperight == 0)
				    				    		  {
				    			    			      leftside=(Integer)objret;
				    				    			  rightside = Integer.parseInt(result[1]);
				    				    			 
				    				    		  }

				    			    		  else
				    			    		  {
				    			    			  
				    			    		  }
				    			    	  }
				    			    	  
				    			    	  else {
				    			    		  
				    			    		  
				    			    	  }
				    		        int n=i;
				    			        int count=n+1;
				    			        int dis = t+1;
				    					if(leftside <= rightside)
				    					{
				    						System.out.println("The Postcondition: " +dis+ "  is correct");
				    						
				    					}
				    					else
				    					{
				    						System.out.println("CONTRACT VIOLATION");
				    						System.out.println("POSTCONDITION :  " +dis+ " IS WRONG");
				    						throw new ContractViolation("POSTCONDITION "+dis+" IS WRONG");
				    					}
				    			        			
	        		}
		        		
		        	}
		         
		          	else if(post_cond[t].contains("<"))
		        	{
		        		flag=2;
		        		
		        		if(post_cond[t].contains("."))
			        	{
			        		objflag=1;
			        		
			        		
                         // System.out.println("The argument has object contracts");
				        	
				        	
					        String foo=post_cond[t];
					          
					        int u=0;
					        
					        int intflagindex=0;
		        					
			        		objflag=1;
			        		
				        Object[] num1 = thisJoinPoint.getArgs();
				        String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
					    Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
					        
						String[] result=foo.split("\\<"); 
				        String[] parts = foo.split("<");
			        	String part1 = parts[0].trim(); 
			        	String part2 = parts[1].trim(); 
				        
			        	for (u = 0; u < num1.length; u++) 
			        	{
			        	String part3 = names[u].trim();
					    if(part2.equals(part3))
					    {
					    intflag = 1;	
					    intflagindex = u;
					 
					    }
					    else
					    {
					    intflag = 0;
					    }
			        	}
			     int i;
				     
				        String classname=null;
				     	int gh=0;
				     	String className = null;
			  	          for(gh=0;gh<num1.length;gh++)
			  		       {
			  		        
			  		   	  className = types[gh].getName();
			  		   	  boolean objcompareint;
			  		    boolean objcomparestring;
			  		   	  objcompareint = Objects.equals(className, "int");
			  		   	objcomparestring = Objects.equals(className, "java.lang.String");
			  		   	
			  		    	 if(objcompareint == true && objcomparestring == false)
			  		    	 {
			  		    		  
			  		    	  }
			  		    	 else if(objcompareint == false && objcomparestring == true)
			  		    	 {
			  		    		 
			  		    	 }
			  		    	 else
			  		    	 {
			  		    		 classname = className;
			  		    	 }
			  		       }
				 
				        String parsecondition = post_cond[t];
				    
				        int condparsefrom=0;
				        int condparseto=0;
				         i=0;
				        for(int parseindex=0;parseindex<parsecondition.length();parseindex++)
				        {
				    	  char ch = parsecondition.charAt(parseindex);
				    	  if(ch == '.')
				    	  {
				    		  condparsefrom = parseindex+1;
				    	  }
				    	  if(ch == '>' || ch == '<' || ch =='!' || ch == '=')
				    	  {
				    		  condparseto = parseindex-1;
				    	  }
				        }
				    
				        char arrsd[] = new char[condparseto - condparsefrom +1];
				   
				        int j=1;
				        arrsd[0] = Character.toUpperCase(parsecondition.charAt(condparsefrom));
				        for(int lk=condparsefrom+1;lk<condparseto+1;lk++)
				        {
				      	   arrsd[j] = parsecondition.charAt(lk);
				    	   j++;
				        }
				       
			      
				        String ab = new String(arrsd);
				       
				        String s2 = classname + "." + "get"+ab+"()";
				     
				        String s3 = "get" + ab;
				  
				        Object cls = Class.forName(classname).newInstance(); 
						Class c = cls.getClass();
				        Method[] meths = c.getDeclaredMethods();
				       
				        if (meths.length != 0) 
				        {
				        for (Method m : meths)
				        {
				        	int comparisonResult = s3.compareTo(m.getName());
				        	if(comparisonResult == 0)
				        	{
				        	
				        	Object bbb = m.invoke(cls);
				        	int numb = Integer.parseInt( bbb.toString() );
				        	int dis = t+1;
				        	 if(intflag == 0 && (Integer)objret < Integer.parseInt(part2.trim()))
								{
									System.out.println("The Postcondition : " +dis+ " is correct");
									
								}
				        	 else if(intflag == 1 && (Integer)objret < (Integer)num1[intflagindex])
								{
									System.out.println("The Postcondition : " +dis+ " is correct");
									
								}
				        	 else
								{
									System.out.println("CONTRACT VIOLATION");
									System.out.println("POSTCONDITION : " +dis+ " IS WRONG");
									throw new ContractViolation("POSTCONDITION "+dis+" IS WRONG");					
				        	    }
				        
				      
				        }
				        }
				        }
				       else {
				    	    System.out.println("  -- no methods --%n");
				            }  
				        }
		        			else
			        		{
			  			        int i=0;
							        
					    			        String foo=post_cond[t];
					    			        
					    			        
					    				
					    		
					    					//Split the string to get the variable and result[0] has var,result[1] has 0. 
					    					String[] result=foo.split("<"); 
					    		    		
					    					//Split the string to get the variable and result[0] has var,result[1] has 0. 
					    				Object[] num1 = thisJoinPoint.getArgs();
					    				
					    				
					    				
					    				String part1 = result[0].trim(); 
							        	String part2 = result[1].trim(); 
					    				
					    				int wl;
					    				int wr;
					    				int wl1=0;
					    				int wr1=0;
					    				int occurnceleft = 0;
					    				int occurncetypeleft = 0;
					    				int occurnceright = 0;
					    				int occurncetyperight = 0;
					    				int leftside=0;
					    				int rightside=0;
					    				
					    				
					    				 String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
					    				 
					    			      Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
					    			    
					    			      for (wl = 0; wl < num1.length; wl++) {
						    		     	  
					    			    	  if(part1.equals(names[wl]))
					    			    	  {
					    			    		occurnceleft = 1;
					    			    		wl1=wl;
					    			    		  
					    			    		if(types[wl].getName().equals("int"))
					    			    		{
					    			    			occurncetypeleft=1;
					    			    		}
					    			    	  }
					    			      }
					    			      occurnceleft =2;
					    			    	  for (wr = 0; wr < num1.length; wr++) {	  
					    			    	
					    			    	
					    			    	  if(part2.equals(names[wr]))
					    			    	  {
					    			    		occurnceright = 1;
					    			    		if(types[wr].getName().equals("int"))
					    			    		{
					    			    			occurncetyperight = 1;
					    			    		}
					    			    	  }
					    			      } 
					    			     
					    			      
					    			    	  if(occurnceleft == 2)
					    			    	  {
					    			    		  if(occurnceright == 1 && occurncetyperight == 1)
					    			    		  {
					    			    			  leftside=(Integer)objret;
					    			    			  rightside = (Integer) (num1[wr1]);
					    			    			  
					    			    		  }
					    			    		  else if(occurnceright == 0 && occurncetyperight == 0)
					    				    		  {
					    			    			      leftside=(Integer)objret;
					    				    			  rightside = Integer.parseInt(result[1]);
					    				    			 
					    				    		  }

					    			    		  else
					    			    		  {
					    			    			  
					    			    		  }
					    			    	  }
					    			    	 
					    			    	  else {
					    			    		  
					    			    		  
					    			    	  }
					    			    	
					    			        int n=i;
					    			        int count=n+1;
					    			 int dis = t+1;
					    					if(leftside < rightside)
					    					{
					    						
					    						System.out.println("The Postcondition: " +dis+ "  is correct");
					    						
					    					}
					    					else
					    					{
					    						System.out.println("CONTRACT VIOLATION");
					    						System.out.println("POSTCONDITION : " +dis+ " IS WRONG");
					    						throw new ContractViolation("POSTCONDITION "+dis+" IS WRONG");
					    					}
					    			        	
		       		}
		        			
		        		}
		          	else if(post_cond[t].contains("!="))
		        	{
		        		flag=5;
		        		
		        		
		        		if(post_cond[t].contains("."))
			        	{
			        		objflag=1;
			        		// System.out.println("The argument has object contracts");
						        String foo=post_cond[t];
						      
						        int u=0;
						        
						        int intflagindex=0;
			        			
			        			
				        		objflag=1;
				        		
				       Object[] num1 = thisJoinPoint.getArgs();
				        String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
					    Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
					        
						String[] result=foo.split("\\!="); 
				        String[] parts = foo.split("!=");
			        	String part1 = parts[0].trim(); 
			        	String part2 = parts[1].trim(); 
				        
			        	int gh=0;
			     	for (u = 0; u < num1.length; u++) 
			        	{
			        	String part3 = names[u].trim();
					    if(part2.equals(part3))
					    {
					    intflag = 1;	
					    intflagindex = u;
					 
					    }
					    else if(types[u].getName().equals("String"))
					    {
					    stringflag = 1;
					    stringflagindex=u;
					    }
					    else
					    {
					    intflag = 0;
					    }
			        	}
			         int i;
				      
				        
				        
				        String classname=null;
				      gh=0;
				      String className = null;
		  	          for(gh=0;gh<num1.length;gh++)
		  		       {
		  		        
		  		   	  className = types[gh].getName();
		  		   	  boolean objcompareint;
		  		    boolean objcomparestring;
		  		   	  objcompareint = Objects.equals(className, "int");
		  		   	objcomparestring = Objects.equals(className, "java.lang.String");
		  		   	
		  		    	 if(objcompareint == true && objcomparestring == false)
		  		    	 {
		  		    		  
		  		    	  }
		  		    	 else if(objcompareint == false && objcomparestring == true)
		  		    	 {
		  		    		 
		  		    	 }
		  		    	 else
		  		    	 {
		  		    		 classname = className;
		  		    	 }
		  		       }
				     String parsecondition = post_cond[t];
				      
				        int condparsefrom=0;
				        int condparseto=0;
				         i=0;
				        for(int parseindex=0;parseindex<parsecondition.length();parseindex++)
				        {
				    	  char ch = parsecondition.charAt(parseindex);
				    	  if(ch == '.')
				    	  {
				    		  condparsefrom = parseindex+1;
				    	  }
				    	  if(ch == '>' || ch == '<' || ch =='!' || ch == '=')
				    	  {
				    		  condparseto = parseindex-1;
				    		  int hj = parseindex;
				    		  char ch1 = parsecondition.charAt(hj);
				    		  if(ch1 == '=')
				    		  {
				    			  condparseto = parseindex-2;
				    		  }
				    	  }
				        }
				       char arrsd[] = new char[condparseto - condparsefrom +1];
				   
				        int j=1;
				        arrsd[0] = Character.toUpperCase(parsecondition.charAt(condparsefrom));
				        for(int lk=condparsefrom+1;lk<condparseto+1;lk++)
				        {
				      	   arrsd[j] = parsecondition.charAt(lk);
				    	   j++;
				        }
				       String ab = new String(arrsd);
				       String s2 = classname + "." + "get"+ab+"()";
				        String s3 = "get" + ab;
				       Object cls = Class.forName(classname).newInstance(); 
				    	Class c = cls.getClass();
				       Method[] meths = c.getDeclaredMethods();
				       
				        if (meths.length != 0) 
				        {
				        for (Method m : meths)
				        {
				        	
				        	int comparisonResult = s3.compareTo(m.getName());
				        	if(comparisonResult == 0)
				        	{
				        	Object bbb = m.invoke(cls);
				        	part2.trim().replace("'", "");
				 
				        	int dis = t+1;
				        	 if(stringflag == 0 && (bbb.toString().equals(part2.trim().replace("'", "").toString()))==false)
								{
				        		
									System.out.println("The Postcondition : " +dis+ " is correct");
				        		 
									
								}
				        	 else if(stringflag == 1 && bbb.toString().equals((String)num1[stringflagindex])==false)
								{
				        		
									System.out.println("The Postcondition : " +dis+ " is correct");
				        		 
								}
				  			else
								{
									System.out.println("CONTRACT VIOLATION");
									System.out.println("POSTCONDITION : " +dis+ " IS WRONG");
									throw new ContractViolation("POSTCONDITION "+dis+" IS WRONG");					
				        	    }
				        
				      
				        }
				        }
				        }
				       else {
				    	    System.out.println("  -- no methods --%n");
				            }  
				        }
		        		
		       	}
		     
		        	  
		        	
		        	
		        	
		        	
		  		  else if(post_cond[t].startsWith("FUNCTIONCHECK"))
		  		  {
		  		 
		  		  String parsecondition = post_cond[t];
		  		
		  		  int parseindex=0;
		  		  int condparsefrom=0;
		  	        int condparseto=0;
		  	         int i=0;
		  	        for(parseindex=0;parseindex<parsecondition.length();parseindex++)
		  	        {
		  	    	  char ch = parsecondition.charAt(parseindex);
		  	    	  if(ch == '.')
		  	    	  {
		  	    		  condparsefrom = parseindex+1;
		  	    	  }
		  	        }
		  	    	  
		  	    		  condparseto = parseindex-1;
		  	    	
		  	        char arrsd[] = new char[condparseto - condparsefrom+1];
		  	   
		  	        int j=0;
		  	        for(int lk=condparsefrom;lk<condparseto+1;lk++)
		  	        {
		  	      	   arrsd[j] = parsecondition.charAt(lk);
		  	    	   j++;
		  	        }
		  	       String ab = new String(arrsd);
		  	       Object[] num1 = thisJoinPoint.getArgs();
		          	String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
		  	        Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
		  	       
		  	        String classname=null;
		  	       
		  	      String className = null;
		  	      int gh;
	  	          for(gh=0;gh<num1.length;gh++)
	  		       {
	  		        
	  		   	  className = types[gh].getName();
	  		   	  boolean objcompareint;
	  		    boolean objcomparestring;
	  		   	  objcompareint = Objects.equals(className, "int");
	  		   	objcomparestring = Objects.equals(className, "java.lang.String");
	  		   	
	  		    	 if(objcompareint == true && objcomparestring == false)
	  		    	 {
	  		    		  
	  		    	  }
	  		    	 else if(objcompareint == false && objcomparestring == true)
	  		    	 {
	  		    		 
	  		    	 }
	  		    	 else
	  		    	 {
	  		    		 classname = className;
	  		    	 }
	  		       }
		  	    	
		  	          Object cls = Class.forName(classname).newInstance(); 
		  				Class c = cls.getClass();
		  		        Method[] meths = c.getDeclaredMethods();
		  		       
		  		        if (meths.length != 0) 
		  		        {
		  		        for (Method m : meths)
		  		        {
		  		        	
		  		        	int comparisonResult = ab.compareTo(m.getName());
		  		        	if(comparisonResult == 0)
		  		        	{
		  		        		if(num1.length == 1)
		  		        		{
		  		        			Object o = m.invoke(cls,num1[0]);
		  		        			boolean di = (Boolean)o;
		  		        			int dis = t+1;
						            if(String.valueOf(di) == "true")
										{
						        		System.out.println("The Postcondition : " +dis+ " is correct");	
										}
						        	else
										{
											System.out.println("CONTRACT VIOLATION");
											System.out.println("POSTCONDITION : " +dis+ " IS WRONG");
											throw new ContractViolation("POSTCONDITION "+dis+" IS WRONG");
						        	    } 
		  		        		}
		  		        		else if(num1.length == 2)
		  		        		{
		  		        			Object o = m.invoke(cls,num1[0],num1[1]);
		  		        			boolean di = (Boolean)o;
		  		        			int dis = t+1;
		  		        			 if(String.valueOf(di) == "true")
										{
						        		System.out.println("The Postcondition : " +dis+ " is correct");	
										}
						        	else
										{
											System.out.println("CONTRACT VIOLATION");
											System.out.println("POSTCONDITION : " +dis+ " IS WRONG");	
											throw new ContractViolation("POSTCONDITION "+dis+" IS WRONG");
						        	    } 
		  		        		}
		  		        		else if(num1.length == 3)
		  		        		{
		  		        			Object o = m.invoke(cls,num1[0],num1[1],num1[2]);
		  		        			boolean di = (Boolean)o;
		  		        			int dis = t+1;
		  		        			 if(String.valueOf(di) == "true")
										{
						        		System.out.println("The Postcondition : " +dis+ " is correct");	
										}
						        	else
										{
											System.out.println("CONTRACT VIOLATION");
											System.out.println("POSTCONDITION : " +dis+ " IS WRONG");	
											throw new ContractViolation("POSTCONDITION "+dis+" IS WRONG");
						        	    } 
		  		        		}
		  		        		else if(num1.length == 4)
		  		        		{
		  		        			Object o = m.invoke(cls,num1[0],num1[1],num1[2],num1[3]);
		  		        			boolean di = (Boolean)o;
		  		        			int dis = t+1;
		  		        			 if(String.valueOf(di) == "true")
										{
						        		System.out.println("The Postcondition : " +dis+ " is correct");	
										}
						        	else
										{
											System.out.println("CONTRACT VIOLATION");
											System.out.println("POSTCONDITION : " +dis+ " IS WRONG");	
											throw new ContractViolation("POSTCONDITION "+dis+" IS WRONG");
						        	    } 
		  		        		}
		  		        		else if(num1.length == 5)
		  		        		{
		  		        			Object o = m.invoke(cls,num1[0],num1[1],num1[2],num1[3],num1[4]);
		  		        			boolean di = (Boolean)o;
		  		        			int dis = t+1;
		  		        			 if(String.valueOf(di) == "true")
										{
						        		System.out.println("The Postcondition : " +dis+ " is correct");	
										}
						        	else
										{
											System.out.println("CONTRACT VIOLATION");
											System.out.println("POSTCONDITION : " +dis+ " IS WRONG");	
											throw new ContractViolation("POSTCONDITION "+dis+" IS WRONG");
						        	    } 
		  		        		}
		  		        		else if(num1.length == 6)
		  		        		{
		  		        			Object o = m.invoke(cls,num1[0],num1[1],num1[2],num1[3],num1[4],num1[5]);
		  		        			boolean di = (Boolean)o;
		  		        			int dis = t+1;
		  		        			 if(String.valueOf(di) == "true")
										{
						        		System.out.println("The Postcondition : " +dis+ " is correct");	
										}
						        	else
										{
											System.out.println("CONTRACT VIOLATION");
											System.out.println("POSTCONDITION : " +dis+ " IS WRONG");	
											throw new ContractViolation("POSTCONDITION "+dis+" IS WRONG");
						        	    } 
		  		        		}
		  		        		else if(num1.length == 7)
		  		        		{
		  		        			Object o = m.invoke(cls,num1[0],num1[1],num1[2],num1[3],num1[4],num1[5],num1[6]);
		  		        			boolean di = (Boolean)o;
		  		        			int dis = t+1;
		  		        			 if(String.valueOf(di) == "true")
										{
						        		System.out.println("The Postcondition : " +dis+ " is correct");	
										}
						        	else
										{
											System.out.println("CONTRACT VIOLATION");
											System.out.println("POSTCONDITION : " +dis+ " IS WRONG");	
											throw new ContractViolation("POSTCONDITION "+dis+" IS WRONG");
						        	    } 
		  		        		}
		  		        		else
		  		        		{
		  		        		Object o = m.invoke(cls,num1[0],num1[1],num1[2],num1[3],num1[4],num1[5],num1[6],num1[7]);
		  		        	
		  		        		boolean di = (Boolean)o;
		  		        		int dis = t+1;
		  		        		 if(String.valueOf(di) == "true")
									{
					        		System.out.println("The Postcondition : " +dis+ " is correct");	
									}
					        	else
									{
										System.out.println("CONTRACT VIOLATION");
										System.out.println("POSTCONDITION : " +dis+ " IS WRONG");
										throw new ContractViolation("POSTCONDITION "+dis+" IS WRONG");
					        	    } 
		  		        		}
		  			     
		  			      
		  			      
		  		        	}//close of comparisonResult == 0
		  		        
		  	        	
		  		        }//end of meth m:
		  		        }
		  		  
		  		  }
		  		
		  	  	
		        	else if(post_cond[t].contains("=="))
		        	{
		        		flag=6;
		        		
		        		if(post_cond[t].contains("."))
			        	{
			        		objflag=1;
			        		// System.out.println("The argument has object contracts");
						        String foo=post_cond[t];
						     
						        
						        int u=0;
						        
						        int intflagindex=0;
			
				        		objflag=1;
				        		
			        Object[] num1 = thisJoinPoint.getArgs();
				        String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
					    Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
					        
						String[] result=foo.split("\\=="); 
				        String[] parts = foo.split("==");
			        	String part1 = parts[0].trim(); 
			        	String part2 = parts[1].trim(); 
				        
			        	int gh=0;
			       	for (u = 0; u < num1.length; u++) 
			        	{
			        	String part3 = names[u].trim();
					    if(part2.equals(part3))
					    {
					    intflag = 1;	
					    intflagindex = u;
					 
					    }
					    else if(types[u].getName().equals("String"))
					    {
					    stringflag = 1;
					    stringflagindex=u;
					    }
					    else
					    {
					    intflag = 0;
					    }
			        	}
			        	
			       		int i;
				      String classname=null;
				         gh=0;
				         String className = null;
			  	          for(gh=0;gh<num1.length;gh++)
			  		       {
			  		        
			  		   	  className = types[gh].getName();
			  		   	  boolean objcompareint;
			  		    boolean objcomparestring;
			  		   	  objcompareint = Objects.equals(className, "int");
			  		   	objcomparestring = Objects.equals(className, "java.lang.String");
			  		   	
			  		    	 if(objcompareint == true && objcomparestring == false)
			  		    	 {
			  		    		  
			  		    	  }
			  		    	 else if(objcompareint == false && objcomparestring == true)
			  		    	 {
			  		    		 
			  		    	 }
			  		    	 else
			  		    	 {
			  		    		 classname = className;
			  		    	 }
			  		       }
				       String parsecondition = post_cond[t];
				        
				        int condparsefrom=0;
				        int condparseto=0;
				         i=0;
				        for(int parseindex=0;parseindex<parsecondition.length();parseindex++)
				        {
				    	  char ch = parsecondition.charAt(parseindex);
				    	  if(ch == '.')
				    	  {
				    		  condparsefrom = parseindex+1;
				    	  }
				    	  if(ch == '>' || ch == '<' || ch =='!' || ch == '=')
				    	  {
				    		  condparseto = parseindex-1;
				    		  int hj = parseindex;
				    		  char ch1 = parsecondition.charAt(hj);
				    		  if(ch1 == '=')
				    		  {
				    			  condparseto = parseindex-2;
				    		  }
				    	  }
				        }
				       char arrsd[] = new char[condparseto - condparsefrom +1];
				   
				        int j=1;
				        arrsd[0] = Character.toUpperCase(parsecondition.charAt(condparsefrom));
				        for(int lk=condparsefrom+1;lk<condparseto+1;lk++)
				        {
				      	   arrsd[j] = parsecondition.charAt(lk);
				    	   j++;
				        }
				     
				        String ab = new String(arrsd);
				      String s2 = classname + "." + "get"+ab+"()";
				       String s3 = "get" + ab;
				      
				    
				        Object cls = Class.forName(classname).newInstance(); 
						Class c = cls.getClass();
				        Method[] meths = c.getDeclaredMethods();
				       
				        if (meths.length != 0) 
				        {
				        for (Method m : meths)
				        {
				        	
				        	int comparisonResult = s3.compareTo(m.getName());
				        	if(comparisonResult == 0)
				        	{
				        	
				        	Object bbb = m.invoke(cls);
				        	part2.trim().replace("'", "");
				      
				        	int dis = t+1;
				        	 if(stringflag == 0 && (bbb.toString().equals(part2.trim().replace("'", "").toString()))==true)
								{
				        		
									System.out.println("The Postcondition : " +dis+ " is correct");
				        		 
									
								}
				        	 else if(stringflag == 1 && bbb.toString().equals((String)num1[stringflagindex])==true)
								{
				        		
									System.out.println("The Postcondition : " +dis+ " is correct");
								}
							else
								{
									System.out.println("CONTRACT VIOLATION");
									System.out.println("POSTCONDITION : " +dis+ " IS WRONG");
									throw new ContractViolation("POSTCONDITION "+dis+" IS WRONG");							
				        	    }
				        
				      
				        }
				        }
				        }
				       else {
				    	    System.out.println("  -- no methods --%n");
				            }  
				        } // close for . of ==
		        	} // close of main ==
		        	else
		        	{
		        		//post out of conditions
		        	}
		        } // end of main for
		   
		    	}//end of post==null	
			
			
			//beginning of else if Invariant
			
			if(invariant_cond.length>=1)
			{
				System.out.println("");
				System.out.println("Checking for Invariant conditions ");
				
		        System.out.println("After executing the function : ");
			   
			    
		        System.out.println( "The Invariant conditions are : " + Arrays.asList(invariant_cond));
		       
		        System.out.println("The Total num of Invariant conditions are:"+invariant_cond.length);
		        
			    
		        //To check if the condition has an object which is of the form Classname.object for bean property.
		        int t;
		        for(t=0;t<invariant_cond.length;t++)
		        {
		        	if(invariant_cond[t].contains("."))
		        	{
		        		objflag=1;
		        	}
		        }
		        
		        //for loop to locate the symbols in the condition
		        for(t=0;t<invariant_cond.length;t++)
		        {
		        	if(invariant_cond[t].contains(">="))
		        	{
		        		flag=3;
		        		if(invariant_cond[t].contains("."))
			        	{
		        			objflag=1;
			        		//System.out.println("The argument has object contracts");
					        String foo=invariant_cond[t];
						    int u=0;
						    int intflagindex=0;
			        	    objflag=1;
				        	String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
					        Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
					       
					        Object[] num1 = thisJoinPoint.getArgs();
					        
						    String[] result=foo.split("\\>="); 
						    String[] parts = foo.split(">=");
						    String part1 = parts[0].trim(); 
						    String part2 = parts[1].trim(); 
				        
						    for (u = 0; u < num1.length; u++) 
						    {
						    	String part3 = names[u].trim();
						    	if(part2.equals(part3))
						    	{
						    		intflag = 1;	
						    		intflagindex = u;
						    	}
						    	else
						    	{
						    		intflag = 0;
						    	}
						    }
			        	
			        
			            int i;
				        String classname=null;
				        int gh=0;
				        String className = null;
			  	          for(gh=0;gh<num1.length;gh++)
			  		       {
			  		        
			  		   	  className = types[gh].getName();
			  		   	  boolean objcompareint;
			  		    boolean objcomparestring;
			  		   	  objcompareint = Objects.equals(className, "int");
			  		   	objcomparestring = Objects.equals(className, "java.lang.String");
			  		   	
			  		    	 if(objcompareint == true && objcomparestring == false)
			  		    	 {
			  		    		  
			  		    	  }
			  		    	 else if(objcompareint == false && objcomparestring == true)
			  		    	 {
			  		    		 
			  		    	 }
			  		    	 else
			  		    	 {
			  		    		 classname = className;
			  		    	 }
			  		       }
				    	String parsecondition = invariant_cond[t];
				        int condparsefrom=0;
				        int condparseto=0;
				        i=0;
				        for(int parseindex=0;parseindex<parsecondition.length();parseindex++)
				        {
				        	char ch = parsecondition.charAt(parseindex);
				        	if(ch == '.')
				        	{
				        		condparsefrom = parseindex+1;
				        	}
				        	if(ch == '>' || ch == '<' || ch =='!' || ch == '=')
				        	{
				        		condparseto = parseindex-1;
				        		int hj = parseindex;
				        		char ch1 = parsecondition.charAt(hj);
				        		if(ch1 == '=')
				        		{
				        			condparseto = parseindex-2;
				        		}
				        	}
				        }
				       
				        char arrsd[] = new char[condparseto - condparsefrom +1];
				        int j=1;
				        arrsd[0] = Character.toUpperCase(parsecondition.charAt(condparsefrom));
				        for(int lk=condparsefrom+1;lk<condparseto+1;lk++)
				        {
				      	   arrsd[j] = parsecondition.charAt(lk);
				    	   j++;
				        }
				        String ab = new String(arrsd);
				        String s2 = classname + "." + "get"+ab+"()";
				        String s3 = "get" + ab;
				        Object cls = Class.forName(classname).newInstance(); 
				        Class c = cls.getClass();
				   
				        Method[] meths = c.getDeclaredMethods();
				       
				        if (meths.length != 0) 
				        {
				        for (Method m : meths)
				        {
				        	int comparisonResult = s3.compareTo(m.getName());
				        	if(comparisonResult == 0)
				        	{
				        		Object bbb = m.invoke(cls);
				        		int numb = Integer.parseInt( bbb.toString() );
				        		int dis = t+1;
				        		if(intflag == 0 && numb >= Integer.parseInt(part2.trim()))
				        		{
				        			System.out.println("The Invariant condition : " +dis+ "is correct");
								
				        		}
				        		else if(intflag == 1 && numb >= (Integer)num1[intflagindex])
				        		{
				        			System.out.println("The Invariant condition : " +dis+ " is correct");
								}
								else
								{
									System.out.println("INVARIANT VIOLATION");
									System.out.println("INVARIANT CONDITION : " +dis+ "IS WRONG");
									throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
														
				        	    }
				            }
				        }
				        }
				        else 
				        {
				        	System.out.println("  -- no methods --%n");
				        }  
				     }
		        	 else
		        	 {
		        	 int i=0;
					 String foo=invariant_cond[t];
				    			        
				     //Split the string to get the variable and result[0] has var,result[1] has 0. 
				     String[] result=foo.split(">="); 
				    		    		
				     //Split the string to get the variable and result[0] has var,result[1] has 0. 
				     Object[] num1 = thisJoinPoint.getArgs();
				     String parsecondition = foo;
					 int condparsefrom=0;
					 int condparseto=0;
					 int hj=0;
					 i=0;
					 int parseindex = 0;
					 for(parseindex=0;parseindex<parsecondition.length();parseindex++)
					 {
						 char ch = parsecondition.charAt(parseindex);
				    	 if(ch == '>' || ch == '<' || ch =='!' || ch == '=')
				    	 {
				    		 condparseto = parseindex-1;
							 hj = parseindex+1;
							 char ch1 = parsecondition.charAt(hj);
							 if(ch1 == '=')
							 {
								 condparseto = hj+1;
							 }
						 }
					  }
					  int condparsetoult = parseindex-1;
				      int ju=0;
				      char arrsd[] = new char[condparsetoult-condparseto];
				      for(int lk=hj;lk<parsecondition.length();lk++)
					  {
				    	  arrsd[ju] = parsecondition.charAt(lk);
				    	  ju++;
					  }
				      String ab = new String(arrsd);
				      String part1 = result[0].trim(); 
				      String part2 = ab.trim();
				      result[1] = ab.trim();
				      int wl;
				      int wr;
				      int wl1=0;
				      int wr1=0;
				      int occurnceleft = 0;
				      int occurncetypeleft = 0;
				      int occurnceright = 0;
				      int occurncetyperight = 0;
				      int leftside=0;
				      int rightside=0;
				    				
				      String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
				      Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
				    			    
				      for (wl = 0; wl < num1.length; wl++) 
				      {
				    	  if(part1.equals(names[wl]))
				    	  {
				    		  occurnceleft = 1;
				    		  wl1=wl;
				    		  if(types[wl].getName().equals("int"))
				    		  {
				    			  occurncetypeleft=1;
				    		  }
				    	  }
				      }
				      occurnceleft =2;
				      for (wr = 0; wr < num1.length; wr++) 
				      {	  
				    	  if(part2.equals(names[wr]))
				    	  {
				    		  occurnceright = 1;
				    		  if(types[wr].getName().equals("int"))
				    		  {
				    			  occurncetyperight = 1;
				    		  }
				    	  }
				      } 
				      if(occurnceleft == 2)
				      {
				    	  if(occurnceright == 1 && occurncetyperight == 1)
				    	  {
				    		  leftside=(Integer)num1[wl1];
				    		  rightside = (Integer) (num1[wr1]);
				    	  }
				    	  else if(occurnceright == 0 && occurncetyperight == 0)
				    	  {
				    		  leftside=(Integer)num1[wl1];
				    		  rightside = Integer.parseInt(result[1]);
				    	  }
				    	  else
				    	  {
				    	  }
				       }
				       else 
				       {
				    			    		  
				       }
				      int n=i;
				      int count=n+1;
				      int dis = t+1;
				      if(leftside >= rightside)
				      {
				    	  System.out.println("The Invariant condition: " +dis+ "  is correct");
				      }
				      else
				      {
				    	  System.out.println("INVARIANT VIOLATION");
				    	  System.out.println("INVARIANT CONDITION : " +dis+ " IS WRONG");
				    	  throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
				      }
				    }
		        		
		        }//end of invariant_cond[t].contains(">=")
		        else if(invariant_cond[t].contains(">"))
		        {
		        	flag=1;
		        	if(invariant_cond[t].contains("."))
			        {
		        		//System.out.println("The argument has object contracts");
				        String foo=invariant_cond[t];
					    int u=0;
					    int intflagindex=0;
		        		objflag=1;
			        	{
			        		Object[] num1 = thisJoinPoint.getArgs();
						    String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
							Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
							String[] result=foo.split("\\>"); 
						    String[] parts = foo.split(">");
						    String part1 = parts[0].trim(); 
					        String part2 = parts[1].trim();
						        
					        for (u = 0; u < num1.length; u++) 
					        {
					        	String part3 = names[u].trim();
							    if(part2.equals(part3))
							    {
							    	intflag = 1;	
							    	intflagindex = u;
							    }
							    else
							    {
							    	intflag = 0;
							    }
					        }
					        int i;	         
					        String classname=null;
						    int gh=0;
						    String className = null;
				  	          for(gh=0;gh<num1.length;gh++)
				  		       {
				  		        
				  		   	  className = types[gh].getName();
				  		   	  boolean objcompareint;
				  		    boolean objcomparestring;
				  		   	  objcompareint = Objects.equals(className, "int");
				  		   	objcomparestring = Objects.equals(className, "java.lang.String");
				  		   	
				  		    	 if(objcompareint == true && objcomparestring == false)
				  		    	 {
				  		    		  
				  		    	  }
				  		    	 else if(objcompareint == false && objcomparestring == true)
				  		    	 {
				  		    		 
				  		    	 }
				  		    	 else
				  		    	 {
				  		    		 classname = className;
				  		    	 }
				  		       }
						    String parsecondition = invariant_cond[t];
						    int condparsefrom=0;
						    int condparseto=0;
						    i=0;
						    for(int parseindex=0;parseindex<parsecondition.length();parseindex++)
						    {
						    	char ch = parsecondition.charAt(parseindex);
						    	if(ch == '.')
						    	{
						    		condparsefrom = parseindex+1;
						    	}
						    	if(ch == '>' || ch == '<' || ch =='!' || ch == '=')
						    	{
						    		condparseto = parseindex-1;
						    	}
						     }
						     char arrsd[] = new char[condparseto - condparsefrom +1];
						     int j=1;
						     arrsd[0] = Character.toUpperCase(parsecondition.charAt(condparsefrom));
						     for(int lk=condparsefrom+1;lk<condparseto+1;lk++)
						     {
						    	 arrsd[j] = parsecondition.charAt(lk);
						    	 j++;
						     }
						     String ab = new String(arrsd);
						     String s2 = classname + "." + "get"+ab+"()";
						     String s3 = "get" + ab;
						     Object cls = Class.forName(classname).newInstance(); 
						     Class c = cls.getClass();
						     Method[] meths = c.getDeclaredMethods();
						     if (meths.length != 0) 
						     {
						    	 for (Method m : meths)
						    	 {
						    		 int comparisonResult = s3.compareTo(m.getName());
						    		 if(comparisonResult == 0)
						    		 {
						    			 Object bbb = m.invoke(cls);
						    			 int numb = Integer.parseInt( bbb.toString() );
						    			 int dis = t+1;
						    			 if(intflag == 0 && numb > Integer.parseInt(part2.trim()))
						    			 {
											System.out.println("The Invariant condition : " +dis+ " is correct");
											
						    			 }
						    			 else if(intflag == 1 && numb > (Integer)num1[intflagindex])
						    			 {
											System.out.println("The Invariant condition : " +dis+ " is correct");
										 }
						    			 else
						    			 {
											System.out.println("INVARIANT VIOLATION");
											System.out.println("INVARIANT CONDITION : " +dis+ " IS WRONG");
											throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
																
						        	    }
						    		 }
						        }
						       }
						       else 
						       {
						    	   System.out.println("  -- no methods --%n");
						       } 	
			        	}
		        	}
		        	else
		        	{
		        		int i=0;
						String foo=invariant_cond[t];
				    			        
				    	//Split the string to get the variable and result[0] has var,result[1] has 0. 
				    	String[] result=foo.split(">"); 
				    		    		
				    	//Split the string to get the variable and result[0] has var,result[1] has 0. 
				    	Object[] num1 = thisJoinPoint.getArgs();
				    				
				    	String part1 = result[0].trim(); 
						String part2 = result[1].trim(); 
				    	int wl;
				    	int wr;
				    	int wl1=0;
				    	int wr1=0;
				    	int occurnceleft = 0;
				    	int occurncetypeleft = 0;
				    	int occurnceright = 0;
				    	int occurncetyperight = 0;
				    	int leftside=0;
				    	int rightside=0;
				    				
				    	String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
				    	Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
				    	for (wl = 0; wl < num1.length; wl++) 
				    	{
				    		if(part1.equals(names[wl]))
				    		{
				    			occurnceleft = 1;
				    			wl1=wl;
				    			if(types[wl].getName().equals("int"))
				    			{
				    				occurncetypeleft=1;
				    			}
				    		}
				    	}
				    	occurnceleft =2;
				    	for (wr = 0; wr < num1.length; wr++) 
				    	{	  
				    		if(part2.equals(names[wr]))
				    		{
				    			occurnceright = 1;
				    			if(types[wr].getName().equals("int"))
				    			{
				    				occurncetyperight = 1;
				    			}
				    		}
				    	} 
				    	if(occurnceleft == 2)
				    	{
				    		if(occurnceright == 1 && occurncetyperight == 1)
				    		{
				    			leftside=(Integer)num1[wl1];
				    			rightside = (Integer) (num1[wr1]);
				    		}
				    		else if(occurnceright == 0 && occurncetyperight == 0)
				    		{
				    			leftside=(Integer)num1[wl1];
				    			rightside = Integer.parseInt(result[1]);
				    		}
				    		else
				    		{
				    			    			  
				    		}
				    	}
				    	else 
				    	{
				    			    		  
				    	}
				    	int n=i;
				    	int count=n+1;
				    	int dis = t+1;
				    	if(leftside > rightside)
				    	{
				    		System.out.println("The Invariant condition: " +dis+ "  is correct");
				    	}
				    	else
				    	{
				    		System.out.println("INVARIANT VIOLATION");
				    		System.out.println("INVARIANT CONDITION : " +dis+ " IS WRONG");
				    		throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
				    	}
				    			        	
				    }
		      }	//end of invariant_cond[t].contains(">")
		      else if(invariant_cond[t].contains("<="))
		      {
		    	  flag=4;
		    	  if(invariant_cond[t].contains("."))
			      {
		    		  objflag=1;
		    		 // System.out.println("The argument has object contracts");
					  String foo=invariant_cond[t];
					  int u=0;
					  int intflagindex=0;
					  objflag=1;
				      String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
					  Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
					  Object[] num1 = thisJoinPoint.getArgs();
					    
					  String[] result=foo.split("\\<="); 
				      String[] parts = foo.split("<=");
				      String part1 = parts[0].trim(); 
				      String part2 = parts[1].trim(); 
				        
				      for (u = 0; u < num1.length; u++) 
				      {
				    	  	String part3 = names[u].trim();
				    	  	if(part2.equals(part3))
				    	  	{
				    	  		intflag = 1;	
				    	  		intflagindex = u;
				    	  	}
				    	  	else
				    	  	{
				    	  		intflag = 0;
				    	  	}
			          }
				      int i;
				      String classname=null;
				      int gh=0;
				      String className = null;
		  	          for(gh=0;gh<num1.length;gh++)
		  		       {
		  		        
		  		   	  className = types[gh].getName();
		  		   	  boolean objcompareint;
		  		    boolean objcomparestring;
		  		   	  objcompareint = Objects.equals(className, "int");
		  		   	objcomparestring = Objects.equals(className, "java.lang.String");
		  		   	
		  		    	 if(objcompareint == true && objcomparestring == false)
		  		    	 {
		  		    		  
		  		    	  }
		  		    	 else if(objcompareint == false && objcomparestring == true)
		  		    	 {
		  		    		 
		  		    	 }
		  		    	 else
		  		    	 {
		  		    		 classname = className;
		  		    	 }
		  		       }
				    	String parsecondition = invariant_cond[t];
				       
				      
				        int condparsefrom=0;
				        int condparseto=0;
				         i=0;
				        for(int parseindex=0;parseindex<parsecondition.length();parseindex++)
				        {
				    	  char ch = parsecondition.charAt(parseindex);
				    	  if(ch == '.')
				    	  {
				    		  condparsefrom = parseindex+1;
				    	  }
				    	  if(ch == '>' || ch == '<' || ch =='!' || ch == '=')
				    	  {
				    		  condparseto = parseindex-1;
				    		  int hj = parseindex;
				    		  char ch1 = parsecondition.charAt(hj);
				    		  if(ch1 == '=')
				    		  {
				    			  condparseto = parseindex-2;
				    		  }
				    	  }
				        }
				      
				        char arrsd[] = new char[condparseto - condparsefrom +1];
				   
				        int j=1;
				        arrsd[0] = Character.toUpperCase(parsecondition.charAt(condparsefrom));
				        for(int lk=condparsefrom+1;lk<condparseto+1;lk++)
				        {
				      	   arrsd[j] = parsecondition.charAt(lk);
				    	   j++;
				        }
				      
			      
				        String ab = new String(arrsd);
				      
				        String s2 = classname + "." + "get"+ab+"()";
				     
				        String s3 = "get" + ab;
				      
				   
				        Object cls = Class.forName(classname).newInstance(); 
				        
				        
						Class c = cls.getClass();
				   
				
				        Method[] meths = c.getDeclaredMethods();
				       
				        if (meths.length != 0) 
				        {
				        for (Method m : meths)
				        {
				        	
				        	int comparisonResult = s3.compareTo(m.getName());
				        	if(comparisonResult == 0)
				        	{
				        
				        	Object bbb = m.invoke(cls);
				        	int numb = Integer.parseInt( bbb.toString() );
				        
				        	int dis = t+1;
				        	 if(intflag == 0 && numb <= Integer.parseInt(part2.trim()))
								{
									System.out.println("The Invariant condition : " +dis+ " is correct");
									
								}
				        	 else if(intflag == 1 && numb <= (Integer)num1[intflagindex])
								{
									System.out.println("The Invariant condition :  " +dis+ " is correct");
									
								}
								else
								{
									System.out.println("INVARIANT VIOLATION");
									System.out.println("INVARIANT CONDITION : " +dis+ " IS WRONG");
									throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
														
				        	    }
				        
				      
				        }
				        }
				        }
				       else {
				    	    System.out.println("  -- no methods --%n");
				            }  
				        }
		        		
		        		else
		        		{
		        			
						 int i=0;
						        
				         String foo=invariant_cond[t];
				   
				    //Split the string to get the variable and result[0] has var,result[1] has 0. 
				    String[] result=foo.split("<="); 
				    		    		
				    //Split the string to get the variable and result[0] has var,result[1] has 0. 
				    Object[] num1 = thisJoinPoint.getArgs();
				    				
				     String parsecondition = foo;
								     	       
								        int condparsefrom=0;
								        int condparseto=0;
								        int hj=0;
								         i=0;
								         int parseindex = 0;
								        for(parseindex=0;parseindex<parsecondition.length();parseindex++)
								        {
								        	char ch = parsecondition.charAt(parseindex);
				    				if(ch == '>' || ch == '<' || ch =='!' || ch == '=')
							    	  {
							    		  condparseto = parseindex-1;
							    		  hj = parseindex+1;
							    		  char ch1 = parsecondition.charAt(hj);
							    		  if(ch1 == '=')
							    		  {
							    		
							    			  condparseto = hj+1;
							    		  }
							    	  }
								        }
								        int condparsetoult = parseindex-1;
				    				int ju=0;
				    				char arrsd[] = new char[condparsetoult-condparseto];
				    				for(int lk=hj;lk<parsecondition.length();lk++)
							        {
							      	   arrsd[ju] = parsecondition.charAt(lk);
							    	   ju++;
							        }
							        String ab = new String(arrsd);
				    				String part1 = result[0].trim(); 
						        	String part2 = ab.trim();
							        result[1] = ab.trim();
				    				int wl;
				    				int wr;
				    				int wl1=0;
				    				int wr1=0;
				    				int occurnceleft = 0;
				    				int occurncetypeleft = 0;
				    				int occurnceright = 0;
				    				int occurncetyperight = 0;
				    				int leftside=0;
				    				int rightside=0;
				    				
				    				
				    				 String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
				    				 
				    			      Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
				    			    
				    			      for (wl = 0; wl < num1.length; wl++) {
					    		     	  
				    			    	  if(part1.equals(names[wl]))
				    			    	  {
				    			    		occurnceleft = 1;
				    			    		wl1=wl;
				    			    		  
				    			    		if(types[wl].getName().equals("int"))
				    			    		{
				    			    			occurncetypeleft=1;
				    			    		}
				    			    	  }
				    			      }
				    			      occurnceleft =2;
				    			    	  for (wr = 0; wr < num1.length; wr++) {	  
				    			    	
				    			    	
				    			    	  if(part2.equals(names[wr]))
				    			    	  {
				    			    		occurnceright = 1;
				    			    		if(types[wr].getName().equals("int"))
				    			    		{
				    			    			occurncetyperight = 1;
				    			    		}
				    			    	  }
				    			      } 
				    				  if(occurnceleft == 2)
				    			    	  {
				    			    		  if(occurnceright == 1 && occurncetyperight == 1)
				    			    		  {
				    			    			  leftside=(Integer)num1[wl1];
				    			    			  rightside = (Integer) (num1[wr1]);
				    			    			  
				    			    		  }
				    			    		  else if(occurnceright == 0 && occurncetyperight == 0)
				    				    		  {
				    			    			  leftside=(Integer)num1[wl1];
				    				    			  rightside = Integer.parseInt(result[1]);
				    				    			 
				    				    		  }

				    			    		  else
				    			    		  {
				    			    			  
				    			    		  }
				    			    	  }
				    			    	  
				    			    	  else {
				    			    		  
				    			    		  
				    			    	  }
				    		        int n=i;
				    			        int count=n+1;
				    			        int dis = t+1;
				    					if(leftside <= rightside)
				    					{
				    						System.out.println("The Invariant condition: " +dis+ "  is correct");
				    						
				    					}
				    					else
				    					{
				    						System.out.println("INVARIANT VIOLATION");
				    						System.out.println("INVARIANT CONDITION :  " +dis+ " IS WRONG");
				    						throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
				    					}
				    			        			
	        		}
		        		
		        	}
		         
		          	else if(invariant_cond[t].contains("<"))
		        	{
		        		flag=2;
		        		
		        		if(invariant_cond[t].contains("."))
			        	{
			        		objflag=1;
			        		
			        		
                         // System.out.println("The argument has object contracts");
				        	
				        	
					        String foo=invariant_cond[t];
					          
					        int u=0;
					        
					        int intflagindex=0;
		        					
			        		objflag=1;
			        		
				        Object[] num1 = thisJoinPoint.getArgs();
				        String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
					    Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
					        
						String[] result=foo.split("\\<"); 
				        String[] parts = foo.split("<");
			        	String part1 = parts[0].trim(); 
			        	String part2 = parts[1].trim(); 
				        
			        	for (u = 0; u < num1.length; u++) 
			        	{
			        	String part3 = names[u].trim();
					    if(part2.equals(part3))
					    {
					    intflag = 1;	
					    intflagindex = u;
					 
					    }
					    else
					    {
					    intflag = 0;
					    }
			        	}
			     int i;
				     
				        String classname=null;
				     	int gh=0;
				     	String className = null;
			  	          for(gh=0;gh<num1.length;gh++)
			  		       {
			  		        
			  		   	  className = types[gh].getName();
			  		   	  boolean objcompareint;
			  		    boolean objcomparestring;
			  		   	  objcompareint = Objects.equals(className, "int");
			  		   	objcomparestring = Objects.equals(className, "java.lang.String");
			  		   	
			  		    	 if(objcompareint == true && objcomparestring == false)
			  		    	 {
			  		    		  
			  		    	  }
			  		    	 else if(objcompareint == false && objcomparestring == true)
			  		    	 {
			  		    		 
			  		    	 }
			  		    	 else
			  		    	 {
			  		    		 classname = className;
			  		    	 }
			  		       }
				 
				        String parsecondition = invariant_cond[t];
				    
				        int condparsefrom=0;
				        int condparseto=0;
				         i=0;
				        for(int parseindex=0;parseindex<parsecondition.length();parseindex++)
				        {
				    	  char ch = parsecondition.charAt(parseindex);
				    	  if(ch == '.')
				    	  {
				    		  condparsefrom = parseindex+1;
				    	  }
				    	  if(ch == '>' || ch == '<' || ch =='!' || ch == '=')
				    	  {
				    		  condparseto = parseindex-1;
				    	  }
				        }
				    
				        char arrsd[] = new char[condparseto - condparsefrom +1];
				   
				        int j=1;
				        arrsd[0] = Character.toUpperCase(parsecondition.charAt(condparsefrom));
				        for(int lk=condparsefrom+1;lk<condparseto+1;lk++)
				        {
				      	   arrsd[j] = parsecondition.charAt(lk);
				    	   j++;
				        }
				       
			      
				        String ab = new String(arrsd);
				       
				        String s2 = classname + "." + "get"+ab+"()";
				     
				        String s3 = "get" + ab;
				  
				        Object cls = Class.forName(classname).newInstance(); 
						Class c = cls.getClass();
				        Method[] meths = c.getDeclaredMethods();
				       
				        if (meths.length != 0) 
				        {
				        for (Method m : meths)
				        {
				        	int comparisonResult = s3.compareTo(m.getName());
				        	if(comparisonResult == 0)
				        	{
				        	
				        	Object bbb = m.invoke(cls);
				        	int numb = Integer.parseInt( bbb.toString() );
				        	int dis = t+1;
				        	 if(intflag == 0 && numb < Integer.parseInt(part2.trim()))
								{
									System.out.println("The Invariant condition : " +dis+ " is correct");
									
								}
				        	 else if(intflag == 1 && numb < (Integer)num1[intflagindex])
								{
									System.out.println("The Invariant condition : " +dis+ " is correct");
									
								}
				        	 else
								{
									System.out.println("INVARIANT VIOLATION");
									System.out.println("INVARIANT CONDITION : " +dis+ " IS WRONG");
									throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");					
				        	    }
				        
				      
				        }
				        }
				        }
				       else {
				    	    System.out.println("  -- no methods --%n");
				            }  
				        }
		        			else
			        		{
			  			        int i=0;
							        
					    			        String foo=invariant_cond[t];
					    			        
					    			        
					    				
					    		
					    					//Split the string to get the variable and result[0] has var,result[1] has 0. 
					    					String[] result=foo.split("<"); 
					    		    		
					    					//Split the string to get the variable and result[0] has var,result[1] has 0. 
					    				Object[] num1 = thisJoinPoint.getArgs();
					    				
					    				
					    				
					    				String part1 = result[0].trim(); 
							        	String part2 = result[1].trim(); 
					    				
					    				int wl;
					    				int wr;
					    				int wl1=0;
					    				int wr1=0;
					    				int occurnceleft = 0;
					    				int occurncetypeleft = 0;
					    				int occurnceright = 0;
					    				int occurncetyperight = 0;
					    				int leftside=0;
					    				int rightside=0;
					    				
					    				
					    				 String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
					    				 
					    			      Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
					    			    
					    			      for (wl = 0; wl < num1.length; wl++) {
						    		     	  
					    			    	  if(part1.equals(names[wl]))
					    			    	  {
					    			    		occurnceleft = 1;
					    			    		wl1=wl;
					    			    		  
					    			    		if(types[wl].getName().equals("int"))
					    			    		{
					    			    			occurncetypeleft=1;
					    			    		}
					    			    	  }
					    			      }
					    			      occurnceleft =2;
					    			    	  for (wr = 0; wr < num1.length; wr++) {	  
					    			    	
					    			    	
					    			    	  if(part2.equals(names[wr]))
					    			    	  {
					    			    		occurnceright = 1;
					    			    		if(types[wr].getName().equals("int"))
					    			    		{
					    			    			occurncetyperight = 1;
					    			    		}
					    			    	  }
					    			      } 
					    			     
					    			      
					    			    	  if(occurnceleft == 2)
					    			    	  {
					    			    		  if(occurnceright == 1 && occurncetyperight == 1)
					    			    		  {
					    			    			  leftside=(Integer)num1[wl1];
					    			    			  rightside = (Integer) (num1[wr1]);
					    			    			  
					    			    		  }
					    			    		  else if(occurnceright == 0 && occurncetyperight == 0)
					    				    		  {
					    			    			  leftside=(Integer)num1[wl1];
					    				    			  rightside = Integer.parseInt(result[1]);
					    				    			 
					    				    		  }

					    			    		  else
					    			    		  {
					    			    			  
					    			    		  }
					    			    	  }
					    			    	 
					    			    	  else {
					    			    		  
					    			    		  
					    			    	  }
					    			    	
					    			        int n=i;
					    			        int count=n+1;
					    			 int dis = t+1;
					    					if(leftside < rightside)
					    					{
					    						
					    						System.out.println("The Invariant condition: " +dis+ "  is correct");
					    						
					    					}
					    					else
					    					{
					    						System.out.println("INVARIANT VIOLATION");
					    						System.out.println("INVARIANT CONDITION : " +dis+ " IS WRONG");
					    						throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
					    					}
					    			        	
		       		}
		        			
		        		}
		          	else if(invariant_cond[t].contains("!="))
		        	{
		        		flag=5;
		        		
		        		
		        		if(invariant_cond[t].contains("."))
			        	{
			        		objflag=1;
			        		// System.out.println("The argument has object contracts");
						        String foo=invariant_cond[t];
						      
						        int u=0;
						        
						        int intflagindex=0;
			        			
			        			
				        		objflag=1;
				        		
				       Object[] num1 = thisJoinPoint.getArgs();
				        String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
					    Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
					        
						String[] result=foo.split("\\!="); 
				        String[] parts = foo.split("!=");
			        	String part1 = parts[0].trim(); 
			        	String part2 = parts[1].trim(); 
				        
			        	int gh=0;
			     	for (u = 0; u < num1.length; u++) 
			        	{
			        	String part3 = names[u].trim();
					    if(part2.equals(part3))
					    {
					    intflag = 1;	
					    intflagindex = u;
					 
					    }
					    else if(types[u].getName().equals("String"))
					    {
					    stringflag = 1;
					    stringflagindex=u;
					    }
					    else
					    {
					    intflag = 0;
					    }
			        	}
			         int i;
				      
				        
				        
				        String classname=null;
				      gh=0;
				      String className = null;
		  	          for(gh=0;gh<num1.length;gh++)
		  		       {
		  		        
		  		   	  className = types[gh].getName();
		  		   	  boolean objcompareint;
		  		    boolean objcomparestring;
		  		   	  objcompareint = Objects.equals(className, "int");
		  		   	objcomparestring = Objects.equals(className, "java.lang.String");
		  		   	
		  		    	 if(objcompareint == true && objcomparestring == false)
		  		    	 {
		  		    		  
		  		    	  }
		  		    	 else if(objcompareint == false && objcomparestring == true)
		  		    	 {
		  		    		 
		  		    	 }
		  		    	 else
		  		    	 {
		  		    		 classname = className;
		  		    	 }
		  		       }
				     String parsecondition = invariant_cond[t];
				      
				        int condparsefrom=0;
				        int condparseto=0;
				         i=0;
				        for(int parseindex=0;parseindex<parsecondition.length();parseindex++)
				        {
				    	  char ch = parsecondition.charAt(parseindex);
				    	  if(ch == '.')
				    	  {
				    		  condparsefrom = parseindex+1;
				    	  }
				    	  if(ch == '>' || ch == '<' || ch =='!' || ch == '=')
				    	  {
				    		  condparseto = parseindex-1;
				    		  int hj = parseindex;
				    		  char ch1 = parsecondition.charAt(hj);
				    		  if(ch1 == '=')
				    		  {
				    			  condparseto = parseindex-2;
				    		  }
				    	  }
				        }
				       char arrsd[] = new char[condparseto - condparsefrom +1];
				   
				        int j=1;
				        arrsd[0] = Character.toUpperCase(parsecondition.charAt(condparsefrom));
				        for(int lk=condparsefrom+1;lk<condparseto+1;lk++)
				        {
				      	   arrsd[j] = parsecondition.charAt(lk);
				    	   j++;
				        }
				       String ab = new String(arrsd);
				       String s2 = classname + "." + "get"+ab+"()";
				        String s3 = "get" + ab;
				       Object cls = Class.forName(classname).newInstance(); 
				    	Class c = cls.getClass();
				       Method[] meths = c.getDeclaredMethods();
				       
				        if (meths.length != 0) 
				        {
				        for (Method m : meths)
				        {
				        	
				        	int comparisonResult = s3.compareTo(m.getName());
				        	if(comparisonResult == 0)
				        	{
				        	Object bbb = m.invoke(cls);
				        	part2.trim().replace("'", "");
				 
				        	int dis = t+1;
				        	 if(stringflag == 0 && (bbb.toString().equals(part2.trim().replace("'", "").toString()))==false)
								{
				        		
									System.out.println("The Invariant condition : " +dis+ " is correct");
				        		 
									
								}
				        	 else if(stringflag == 1 && bbb.toString().equals((String)num1[stringflagindex])==false)
								{
				        		
									System.out.println("The Invariant condition : " +dis+ " is correct");
				        		 
								}
				  			else
								{
									System.out.println("INVARIANT VIOLATION");
									System.out.println("INVARIANT CONDITION : " +dis+ " IS WRONG");
									throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");					
				        	    }
				        
				      
				        }
				        }
				        }
				       else {
				    	    System.out.println("  -- no methods --%n");
				            }  
				        }
		        		
		       	}
		     
		        	  
		        	
		        	
		        	
		        	
		  		  else if(invariant_cond[t].startsWith("FUNCTIONCHECK"))
		  		  {
		  		 
		  		  String parsecondition = invariant_cond[t];
		  		
		  		  int parseindex=0;
		  		  int condparsefrom=0;
		  	        int condparseto=0;
		  	         int i=0;
		  	        for(parseindex=0;parseindex<parsecondition.length();parseindex++)
		  	        {
		  	    	  char ch = parsecondition.charAt(parseindex);
		  	    	  if(ch == '.')
		  	    	  {
		  	    		  condparsefrom = parseindex+1;
		  	    	  }
		  	        }
		  	    	  
		  	    		  condparseto = parseindex-1;
		  	    	
		  	        char arrsd[] = new char[condparseto - condparsefrom+1];
		  	   
		  	        int j=0;
		  	        for(int lk=condparsefrom;lk<condparseto+1;lk++)
		  	        {
		  	      	   arrsd[j] = parsecondition.charAt(lk);
		  	    	   j++;
		  	        }
		  	       String ab = new String(arrsd);
		  	       Object[] num1 = thisJoinPoint.getArgs();
		          	String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
		  	        Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
		  	       
		  	        String classname=null;
		  	       
		  	      String className = null;
		  	      int gh;
	  	          for(gh=0;gh<num1.length;gh++)
	  		       {
	  		        
	  		   	  className = types[gh].getName();
	  		   	  boolean objcompareint;
	  		    boolean objcomparestring;
	  		   	  objcompareint = Objects.equals(className, "int");
	  		   	objcomparestring = Objects.equals(className, "java.lang.String");
	  		   	
	  		    	 if(objcompareint == true && objcomparestring == false)
	  		    	 {
	  		    		  
	  		    	  }
	  		    	 else if(objcompareint == false && objcomparestring == true)
	  		    	 {
	  		    		 
	  		    	 }
	  		    	 else
	  		    	 {
	  		    		 classname = className;
	  		    	 }
	  		       }
		  	    	
		  	          Object cls = Class.forName(classname).newInstance(); 
		  				Class c = cls.getClass();
		  		        Method[] meths = c.getDeclaredMethods();
		  		       
		  		        if (meths.length != 0) 
		  		        {
		  		        for (Method m : meths)
		  		        {
		  		        	
		  		        	int comparisonResult = ab.compareTo(m.getName());
		  		        	if(comparisonResult == 0)
		  		        	{
		  		        		if(num1.length == 1)
		  		        		{
		  		        			Object o = m.invoke(cls,num1[0]);
		  		        			boolean di = (Boolean)o;
		  		        			int dis = t+1;
						            if(String.valueOf(di) == "true")
										{
						        		System.out.println("The Invariant condition : " +dis+ " is correct");	
										}
						        	else
										{
											System.out.println("INVARIANT VIOLATION");
											System.out.println("INVARIANT CONDITION : " +dis+ " IS WRONG");
											throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
						        	    } 
		  		        		}
		  		        		else if(num1.length == 2)
		  		        		{
		  		        			Object o = m.invoke(cls,num1[0],num1[1]);
		  		        			boolean di = (Boolean)o;
		  		        			int dis = t+1;
		  		        			 if(String.valueOf(di) == "true")
										{
						        		System.out.println("The Invariant condition : " +dis+ " is correct");	
										}
						        	else
										{
											System.out.println("INVARIANT VIOLATION");
											System.out.println("INVARIANT CONDITION : " +dis+ " IS WRONG");	
											throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
						        	    } 
		  		        		}
		  		        		else if(num1.length == 3)
		  		        		{
		  		        			Object o = m.invoke(cls,num1[0],num1[1],num1[2]);
		  		        			boolean di = (Boolean)o;
		  		        			int dis = t+1;
		  		        			 if(String.valueOf(di) == "true")
										{
						        		System.out.println("The Invariant condition : " +dis+ " is correct");	
										}
						        	else
										{
											System.out.println("INVARIANT VIOLATION");
											System.out.println("INVARIANT CONDITION : " +dis+ " IS WRONG");	
											throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
						        	    } 
		  		        		}
		  		        		else if(num1.length == 4)
		  		        		{
		  		        			Object o = m.invoke(cls,num1[0],num1[1],num1[2],num1[3]);
		  		        			boolean di = (Boolean)o;
		  		        			int dis = t+1;
		  		        			 if(String.valueOf(di) == "true")
										{
						        		System.out.println("The Invariant condition : " +dis+ " is correct");	
										}
						        	else
										{
											System.out.println("INVARIANT VIOLATION");
											System.out.println("INVARIANT CONDITION : " +dis+ " IS WRONG");	
											throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
						        	    } 
		  		        		}
		  		        		else if(num1.length == 5)
		  		        		{
		  		        			Object o = m.invoke(cls,num1[0],num1[1],num1[2],num1[3],num1[4]);
		  		        			boolean di = (Boolean)o;
		  		        			int dis = t+1;
		  		        			 if(String.valueOf(di) == "true")
										{
						        		System.out.println("The Invariant condition : " +dis+ " is correct");	
										}
						        	else
										{
											System.out.println("INVARIANT VIOLATION");
											System.out.println("INVARIANT CONDITION : " +dis+ " IS WRONG");	
											throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
						        	    } 
		  		        		}
		  		        		else if(num1.length == 6)
		  		        		{
		  		        			Object o = m.invoke(cls,num1[0],num1[1],num1[2],num1[3],num1[4],num1[5]);
		  		        			boolean di = (Boolean)o;
		  		        			int dis = t+1;
		  		        			 if(String.valueOf(di) == "true")
										{
						        		System.out.println("The Invariant condition : " +dis+ " is correct");	
										}
						        	else
										{
											System.out.println("INVARIANT VIOLATION");
											System.out.println("INVARIANT CONDITION : " +dis+ " IS WRONG");	
											throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
						        	    } 
		  		        		}
		  		        		else if(num1.length == 7)
		  		        		{
		  		        			Object o = m.invoke(cls,num1[0],num1[1],num1[2],num1[3],num1[4],num1[5],num1[6]);
		  		        			boolean di = (Boolean)o;
		  		        			int dis = t+1;
		  		        			 if(String.valueOf(di) == "true")
										{
						        		System.out.println("The Invariant condition : " +dis+ " is correct");	
										}
						        	else
										{
											System.out.println("INVARIANT VIOLATION");
											System.out.println("INVARIANT CONDITION : " +dis+ " IS WRONG");	
											throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
						        	    } 
		  		        		}
		  		        		else
		  		        		{
		  		        		Object o = m.invoke(cls,num1[0],num1[1],num1[2],num1[3],num1[4],num1[5],num1[6],num1[7]);
		  		        	
		  		        		boolean di = (Boolean)o;
		  		        		int dis = t+1;
		  		        		 if(String.valueOf(di) == "true")
									{
					        		System.out.println("The Invariant condition : " +dis+ " is correct");	
									}
					        	else
									{
										System.out.println("INVARIANT VIOLATION");
										System.out.println("INVARIANT CONDITION : " +dis+ " IS WRONG");
										throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");
					        	    } 
		  		        		}
		  			     
		  			      
		  			      
		  		        	}//close of comparisonResult == 0
		  		        
		  	        	
		  		        }//end of meth m:
		  		        }
		  		  
		  		  }
		  		
		  	  	
		        	else if(invariant_cond[t].contains("=="))
		        	{
		        		flag=6;
		        		
		        		if(invariant_cond[t].contains("."))
			        	{
			        		objflag=1;
			        		// System.out.println("The argument has object contracts");
						        String foo=invariant_cond[t];
						     
						        
						        int u=0;
						        
						        int intflagindex=0;
			
				        		objflag=1;
				        		
			        Object[] num1 = thisJoinPoint.getArgs();
				        String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
					    Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
					        
						String[] result=foo.split("\\=="); 
				        String[] parts = foo.split("==");
			        	String part1 = parts[0].trim(); 
			        	String part2 = parts[1].trim(); 
				        
			        	int gh=0;
			       	for (u = 0; u < num1.length; u++) 
			        	{
			        	String part3 = names[u].trim();
					    if(part2.equals(part3))
					    {
					    intflag = 1;	
					    intflagindex = u;
					 
					    }
					    else if(types[u].getName().equals("String"))
					    {
					    stringflag = 1;
					    stringflagindex=u;
					    }
					    else
					    {
					    intflag = 0;
					    }
			        	}
			        	
			       		int i;
				      String classname=null;
				         gh=0;
				         String className = null;
			  	          for(gh=0;gh<num1.length;gh++)
			  		       {
			  		        
			  		   	  className = types[gh].getName();
			  		   	  boolean objcompareint;
			  		    boolean objcomparestring;
			  		   	  objcompareint = Objects.equals(className, "int");
			  		   	objcomparestring = Objects.equals(className, "java.lang.String");
			  		   	
			  		    	 if(objcompareint == true && objcomparestring == false)
			  		    	 {
			  		    		  
			  		    	  }
			  		    	 else if(objcompareint == false && objcomparestring == true)
			  		    	 {
			  		    		 
			  		    	 }
			  		    	 else
			  		    	 {
			  		    		 classname = className;
			  		    	 }
			  		       }
				       String parsecondition = invariant_cond[t];
				        
				        int condparsefrom=0;
				        int condparseto=0;
				         i=0;
				        for(int parseindex=0;parseindex<parsecondition.length();parseindex++)
				        {
				    	  char ch = parsecondition.charAt(parseindex);
				    	  if(ch == '.')
				    	  {
				    		  condparsefrom = parseindex+1;
				    	  }
				    	  if(ch == '>' || ch == '<' || ch =='!' || ch == '=')
				    	  {
				    		  condparseto = parseindex-1;
				    		  int hj = parseindex;
				    		  char ch1 = parsecondition.charAt(hj);
				    		  if(ch1 == '=')
				    		  {
				    			  condparseto = parseindex-2;
				    		  }
				    	  }
				        }
				       char arrsd[] = new char[condparseto - condparsefrom +1];
				   
				        int j=1;
				        arrsd[0] = Character.toUpperCase(parsecondition.charAt(condparsefrom));
				        for(int lk=condparsefrom+1;lk<condparseto+1;lk++)
				        {
				      	   arrsd[j] = parsecondition.charAt(lk);
				    	   j++;
				        }
				     
				        String ab = new String(arrsd);
				      String s2 = classname + "." + "get"+ab+"()";
				       String s3 = "get" + ab;
				      
				    
				        Object cls = Class.forName(classname).newInstance(); 
						Class c = cls.getClass();
				        Method[] meths = c.getDeclaredMethods();
				       
				        if (meths.length != 0) 
				        {
				        for (Method m : meths)
				        {
				        	
				        	int comparisonResult = s3.compareTo(m.getName());
				        	if(comparisonResult == 0)
				        	{
				        	
				        	Object bbb = m.invoke(cls);
				        	part2.trim().replace("'", "");
				      
				        	int dis = t+1;
				        	 if(stringflag == 0 && (bbb.toString().equals(part2.trim().replace("'", "").toString()))==true)
								{
				        		
									System.out.println("The Invariant condition : " +dis+ " is correct");
				        		 
									
								}
				        	 else if(stringflag == 1 && bbb.toString().equals((String)num1[stringflagindex])==true)
								{
				        		
									System.out.println("The Invariant condition : " +dis+ " is correct");
								}
							else
								{
									System.out.println("INVARIANT VIOLATION");
									System.out.println("INVARIANT CONDITION : " +dis+ " IS WRONG");
									throw new ContractViolation("INVARIANT CONDITION " +dis+ " IS WRONG");							
				        	    }
				        
				      
				        }
				        }
				        }
				       else {
				    	    System.out.println("  -- no methods --%n");
				            }  
				        } // close for . of ==
		        	} // close of main ==
		        	else
		        	{
		        		//Invariant out of conditions
		        	}
		        } // end of main for
		   
    			
			}//end of main else if 
			
		    	}//end of main else if
			
			//Beginning of Lambda Expressions PostConditions :
			
			if(annotation instanceof ContractLambda)
		    {
		    	System.out.println("");
		    	//System.out.println("Checking for Contracts for the method : " +sig.getName());
		    	
		    	ContractLambda annos = (ContractLambda) annotation;
		    	String[] invariant_cond_lambda = annos.invariant_cond_lambda();
		    	String[] pre_cond_lambda = annos.pre_cond_lambda();
		    	String[] post_cond_lambda = annos.post_cond_lambda();
		    	String methodname = sig.getName();
		    	
		    	if(post_cond_lambda.length>=1)
		    	{
		    	System.out.println("");
				System.out.println("Checking for Postconditions for Lambda Expressions  ");
				
				String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
	        	Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
	        	Object[] num1 = thisJoinPoint.getArgs();
	        	//Object[] methodtypes = thisJoinPoint.getGenericReturnType();
	        	
			    System.out.println( "The Postconditions for Lambda Expressions are : " + Arrays.asList(post_cond_lambda));
			  
			    System.out.println("The Total num of Postconditions for Lambda Expressions are:"+post_cond_lambda.length);
			    int t=0;
			   
			    for(t=0;t<post_cond_lambda.length;t++)
			    {
			    	String foo=post_cond_lambda[t];
			    	String[] parts = foo.split("->");
			    	String part1 = parts[0].trim();
			    	
			    	int value_lambda_int=0;
			    	String value_lambda_string=null;
			    	float value_lambda_float=0;
			    	double value_lambda_double=0;
			    	boolean value_lambda_boolean=false;
			    	long value_lambda_long=0;
			    	char value_lambda_char=0;
			    	
			        String str2 = invariant_cond_lambda[0];
			        
			        int lambdaint=0;
			        int lambdastring=0;
			        int lambdafloat=0;
			        int lambdadouble=0;
			        int lambdaboolean=0;
			        int lambdalong=0;
			        int lambdachar=0;
			        for(int argsk=0;argsk<num1.length;argsk++)
		        	{
		        		
		        		if(part1.equals(names[argsk]))
		        		{
		        			
		        			if(objret.getClass().equals(Integer.class))
		        			{
		        				value_lambda_int = (Integer)objret;
		        				lambdaint=1;
		        			}
		        			if(objret.getClass().equals(String.class))
		        			{
		        				value_lambda_string = (String)objret;
		        				lambdastring=1;
		        			}
		        			if(objret.getClass().equals(Float.class))
		        			{
		        				value_lambda_float = (Float)objret;
		        				lambdafloat=1;
		        			}
		        			if(objret.getClass().equals(Double.class))
		        			{
		        				value_lambda_double = (Double)objret;
		        				lambdadouble=1;
		        			}
		        			if(objret.getClass().equals(Boolean.class))
		        			{
		        				value_lambda_boolean = (Boolean)objret;
		        				lambdaboolean=1;
		        			}
		        			if(objret.getClass().equals(Long.class))
		        			{
		        				value_lambda_long = (Long)objret;
		        				lambdalong=1;
		        			}
		        			if(objret.getClass().equals(Character.class))
		        			{
		        				value_lambda_char = (Character)objret;
		        				lambdachar=1;
		        			}
		        		}
		        	}
			       
			        if(lambdaint == 1)
			        {
			        Function<Integer, Boolean> lambda = factory.createLambdaUnchecked(
			        		foo, new TypeReference<Function<Integer, Boolean>>() {});
			     
			        boolean n = lambda.apply(value_lambda_int);
			        int dis = t+1;
			        if(n == true)
			        {
			        	System.out.println("The Postconditions for Lambda Expression : " +dis+ " is correct");			
			        }
			        else
					{
			        	System.out.println("POSTCONDITION FOR LAMBDA EXPRESSION VIOLATION");
						System.out.println("POSTCONDITION FOR LAMBDA EXPRESSION VIOLATION : " +dis+ " IS WRONG");	
						throw new ContractViolation("POSTCONDITION FOR LAMBDA EXPRESSION VIOLATION " +dis+ " IS WRONG");
	        	    } 
			      
			        }//close of  if(lambdaint == 1)
			        if(lambdastring == 1)
			        {
			        Function<String, Boolean> lambda = factory.createLambdaUnchecked(
			        		foo, new TypeReference<Function<String, Boolean>>() {});
			     
			        boolean n = lambda.apply(value_lambda_string);
			        int dis = t+1;
			        if(n == true)
			        {
			        	System.out.println("The Postconditions for Lambda Expression : " +dis+ " is correct");			
			        }
			        else
					{
			        	System.out.println("POSTCONDITION FOR LAMBDA EXPRESSION VIOLATION");
						System.out.println("POSTCONDITION FOR LAMBDA EXPRESSION VIOLATION : " +dis+ " IS WRONG");	
						throw new ContractViolation("POSTCONDITION FOR LAMBDA EXPRESSION VIOLATION " +dis+ " IS WRONG");
	        	    } 
			      
			        }//close of  if(lambdastring == 1)
			        
			        if(lambdafloat == 1)
			        {
			        Function<Float, Boolean> lambda = factory.createLambdaUnchecked(
			        		foo, new TypeReference<Function<Float, Boolean>>() {});
			     
			        boolean n = lambda.apply(value_lambda_float);
			        int dis = t+1;
			        if(n == true)
			        {
			        	System.out.println("The Postconditions for Lambda Expression : " +dis+ " is correct");				
			        }
			        else
					{
			        	System.out.println("POSTCONDITION FOR LAMBDA EXPRESSION VIOLATION");
						System.out.println("POSTCONDITION FOR LAMBDA EXPRESSION VIOLATION : " +dis+ " IS WRONG");	
						throw new ContractViolation("POSTCONDITION FOR LAMBDA EXPRESSION VIOLATION " +dis+ " IS WRONG");
	        	    } 
			      
			        }//close of  if(lambdafloat == 1)
			        
			        if(lambdadouble == 1)
			        {
			        Function<Double, Boolean> lambda = factory.createLambdaUnchecked(
			        		foo, new TypeReference<Function<Double, Boolean>>() {});
			     
			        boolean n = lambda.apply(value_lambda_double);
			        int dis = t+1;
			        if(n == true)
			        {
			        	System.out.println("The Postconditions for Lambda Expression : " +dis+ " is correct");				
			        }
			        else
					{
			        	System.out.println("POSTCONDITION FOR LAMBDA EXPRESSION VIOLATION");
						System.out.println("POSTCONDITION FOR LAMBDA EXPRESSION VIOLATION : " +dis+ " IS WRONG");	
						throw new ContractViolation("POSTCONDITION FOR LAMBDA EXPRESSION VIOLATION " +dis+ " IS WRONG");
	        	    } 
			      
			        }//close of  if(lambdadouble == 1)
			        
			        if(lambdaboolean == 1)
			        {
			        Function<Boolean, Boolean> lambda = factory.createLambdaUnchecked(
			        		foo, new TypeReference<Function<Boolean, Boolean>>() {});
			     
			        boolean n = lambda.apply(value_lambda_boolean);
			        int dis = t+1;
			        if(n == true)
			        {
			        	System.out.println("The Postconditions for Lambda Expression : " +dis+ " is correct");				
			        }
			        else
					{
			        	System.out.println("POSTCONDITION FOR LAMBDA EXPRESSION VIOLATION");
						System.out.println("POSTCONDITION FOR LAMBDA EXPRESSION VIOLATION : " +dis+ " IS WRONG");	
						throw new ContractViolation("POSTCONDITION FOR LAMBDA EXPRESSION VIOLATION " +dis+ " IS WRONG");
	        	    } 
			      
			        }//close of  if(lambdaboolean == 1)
			        
			        if(lambdalong == 1)
			        {
			        Function<Long, Boolean> lambda = factory.createLambdaUnchecked(
			        		foo, new TypeReference<Function<Long, Boolean>>() {});
			     
			        boolean n = lambda.apply(value_lambda_long);
			        int dis = t+1;
			        if(n == true)
			        {
			        	System.out.println("The Postconditions for Lambda Expression : " +dis+ " is correct");				
			        }
			        else
					{
			        	System.out.println("POSTCONDITION FOR LAMBDA EXPRESSION VIOLATION");
						System.out.println("POSTCONDITION FOR LAMBDA EXPRESSION VIOLATION : " +dis+ " IS WRONG");	
						throw new ContractViolation("POSTCONDITION FOR LAMBDA EXPRESSION VIOLATION " +dis+ " IS WRONG");
	        	    } 
			      
			        }//close of  if(lambdalong == 1)
			        
			        if(lambdachar == 1)
			        {
			        Function<Character, Boolean> lambda = factory.createLambdaUnchecked(
			        		foo, new TypeReference<Function<Character, Boolean>>() {});
			     
			        boolean n = lambda.apply(value_lambda_char);
			        int dis = t+1;
			        if(n == true)
			        {
			        	System.out.println("The Postconditions for Lambda Expression : " +dis+ " is correct");				
			        }
			        else
					{
			        	System.out.println("POSTCONDITION FOR LAMBDA EXPRESSION VIOLATION");
						System.out.println("POSTCONDITION FOR LAMBDA EXPRESSION VIOLATION : " +dis+ " IS WRONG");	
						throw new ContractViolation("POSTCONDITION FOR LAMBDA EXPRESSION VIOLATION " +dis+ " IS WRONG");
	        	    } 
			      
			        }//close of  if(lambdachar == 1)
			      
			    }//close of for loop for all invariant condition lambdas
		    	
		    	}//close of post_cond_lambda>=1
		    	
		     	//Beginning of invariant for Lambda expressions:
		    	
		    	if(invariant_cond_lambda.length>=1)
		    	{
		    	System.out.println("");
				//System.out.println("Checking for Invariants for Lambda Expressions ");
				
				String[] names = ((CodeSignature)thisJoinPoint.getSignature()).getParameterNames();
	        	Class[] types = ((CodeSignature)thisJoinPoint.getSignature()).getParameterTypes();
	        	Object[] num1 = thisJoinPoint.getArgs();
	        	
			    System.out.println( "The Invariants for Lambda Expressions are : " + Arrays.asList(invariant_cond_lambda));
			  
			    System.out.println("The Total num of Invariants for Lambda Expressions are:"+invariant_cond_lambda.length);
			    int t=0;
			   
			    
			    for(t=0;t<invariant_cond_lambda.length;t++)
			    {
			    	String foo=invariant_cond_lambda[t];
			    	String[] parts = foo.split("->");
			    	String part1 = parts[0].trim();
			    	
			    	int value_lambda_int=0;
			    	String value_lambda_string=null;
			    	float value_lambda_float=0;
			    	double value_lambda_double=0;
			    	boolean value_lambda_boolean=false;
			    	long value_lambda_long=0;
			    	char value_lambda_char=0;
			    	
			    	
			        String str2 = invariant_cond_lambda[0];
			        
			        int lambdaint=0;
			        int lambdastring=0;
			        int lambdafloat=0;
			        int lambdadouble=0;
			        int lambdaboolean=0;
			        int lambdalong=0;
			        int lambdachar=0;
			        
			        for(int argsk=0;argsk<num1.length;argsk++)
		        	{

		        		if(part1.equals(names[argsk]))
		        		{
		        			
		        			if(types[argsk].getName().equals("int"))
		        			{
		        				value_lambda_int = (Integer)num1[argsk];
		        				lambdaint=1;
		        			}
		        			if(types[argsk].getName().equals("java.lang.String"))
		        			{
		        				value_lambda_string = (String)num1[argsk];
		        				lambdastring=1;
		        			}
		        		  
		        		}
		        	}
			       
			        if(lambdaint == 1)
			        {
			        Function<Integer, Boolean> lambda = factory.createLambdaUnchecked(
			        		foo, new TypeReference<Function<Integer, Boolean>>() {});
			     
			        boolean n = lambda.apply(value_lambda_int);
			        int dis = t+1;
			        if(n == true)
			        {
			        	System.out.println("The Invariants for Lambda Expression : " +dis+ " is correct");			
			        }
			        else
					{
						System.out.println("INVARIANT FOR LAMBDA EXPRESSION VIOLATION");
						System.out.println("INVARIANT FOR LAMBDA EXPRESSION VIOLATION : " +dis+ " IS WRONG");	
						throw new ContractViolation("INVARIANT FOR LAMBDA EXPRESSION VIOLATION " +dis+ " IS WRONG");
	        	    } 
			      
			        }//close of  if(lambdaint == 1)
			        if(lambdastring == 1)
			        {
			        Function<String, Boolean> lambda = factory.createLambdaUnchecked(
			        		foo, new TypeReference<Function<String, Boolean>>() {});
			     
			        boolean n = lambda.apply(value_lambda_string);
			        int dis = t+1;
			        if(n == true)
			        {
			        	System.out.println("The Invariants for Lambda Expression : " +dis+ " is correct");			
			        }
			        else
					{
						System.out.println("INVARIANT FOR LAMBDA EXPRESSION VIOLATION");
						System.out.println("INVARIANT FOR LAMBDA EXPRESSION VIOLATION : " +dis+ " IS WRONG");	
						throw new ContractViolation("INVARIANT FOR LAMBDA EXPRESSION VIOLATION " +dis+ " IS WRONG");
	        	    } 
			      
			        }//close of  if(lambdastring == 1)
			        
			        if(lambdafloat == 1)
			        {
			        Function<Float, Boolean> lambda = factory.createLambdaUnchecked(
			        		foo, new TypeReference<Function<Float, Boolean>>() {});
			     
			        boolean n = lambda.apply(value_lambda_float);
			        int dis = t+1;
			        if(n == true)
			        {
			        	System.out.println("The Invariants for Lambda Expression : " +dis+ " is correct");			
			        }
			        else
					{
						System.out.println("INVARIANT FOR LAMBDA EXPRESSION VIOLATION");
						System.out.println("INVARIANT FOR LAMBDA EXPRESSION VIOLATION : " +dis+ " IS WRONG");	
						throw new ContractViolation("INVARIANT FOR LAMBDA EXPRESSION VIOLATION " +dis+ " IS WRONG");
	        	    } 
			      
			        }//close of  if(lambdafloat == 1)
			        
			        if(lambdadouble == 1)
			        {
			        Function<Double, Boolean> lambda = factory.createLambdaUnchecked(
			        		foo, new TypeReference<Function<Double, Boolean>>() {});
			     
			        boolean n = lambda.apply(value_lambda_double);
			        int dis = t+1;
			        if(n == true)
			        {
			        	System.out.println("The Invariants for Lambda Expression : " +dis+ " is correct");			
			        }
			        else
					{
						System.out.println("INVARIANT FOR LAMBDA EXPRESSION VIOLATION");
						System.out.println("INVARIANT FOR LAMBDA EXPRESSION VIOLATION : " +dis+ " IS WRONG");	
						throw new ContractViolation("INVARIANT FOR LAMBDA EXPRESSION VIOLATION " +dis+ " IS WRONG");
	        	    }  
			      
			        }//close of  if(lambdadouble == 1)
			        
			        if(lambdaboolean == 1)
			        {
			        Function<Boolean, Boolean> lambda = factory.createLambdaUnchecked(
			        		foo, new TypeReference<Function<Boolean, Boolean>>() {});
			     
			        boolean n = lambda.apply(value_lambda_boolean);
			        int dis = t+1;
			        if(n == true)
			        {
			        	System.out.println("The Invariants for Lambda Expression : " +dis+ " is correct");			
			        }
			        else
					{
						System.out.println("INVARIANT FOR LAMBDA EXPRESSION VIOLATION");
						System.out.println("INVARIANT FOR LAMBDA EXPRESSION VIOLATION : " +dis+ " IS WRONG");	
						throw new ContractViolation("INVARIANT FOR LAMBDA EXPRESSION VIOLATION " +dis+ " IS WRONG");
	        	    }  
			      
			        }//close of  if(lambdaboolean == 1)
			        
			        if(lambdalong == 1)
			        {
			        Function<Long, Boolean> lambda = factory.createLambdaUnchecked(
			        		foo, new TypeReference<Function<Long, Boolean>>() {});
			     
			        boolean n = lambda.apply(value_lambda_long);
			        int dis = t+1;
			        if(n == true)
			        {
			        	System.out.println("The Invariants for Lambda Expression : " +dis+ " is correct");			
			        }
			        else
					{
						System.out.println("INVARIANT FOR LAMBDA EXPRESSION VIOLATION");
						System.out.println("INVARIANT FOR LAMBDA EXPRESSION VIOLATION : " +dis+ " IS WRONG");	
						throw new ContractViolation("INVARIANT FOR LAMBDA EXPRESSION VIOLATION " +dis+ " IS WRONG");
	        	    }  
			      
			        }//close of  if(lambdalong == 1)
			        
			        if(lambdachar == 1)
			        {
			        Function<Character, Boolean> lambda = factory.createLambdaUnchecked(
			        		foo, new TypeReference<Function<Character, Boolean>>() {});
			     
			        boolean n = lambda.apply(value_lambda_char);
			        int dis = t+1;
			        if(n == true)
			        {
			        	System.out.println("The Invariants for Lambda Expression : " +dis+ " is correct");			
			        }
			        else
					{
						System.out.println("INVARIANT FOR LAMBDA EXPRESSION VIOLATION");
						System.out.println("INVARIANT FOR LAMBDA EXPRESSION VIOLATION : " +dis+ " IS WRONG");	
						throw new ContractViolation("INVARIANT FOR LAMBDA EXPRESSION VIOLATION " +dis+ " IS WRONG");
	        	    } 
			      
			        }//close of  if(lambdachar == 1)
			      
			    }//close of for loop for all invariant condition lambdas
		    	
		    	}//close of pre_cond_lambda>=1
		    	
		    }//close of if(annotation instanceof ContractLambda)
			
		}//end of one more for Annotation annotation : annost for
	}//end of try
	
			catch(Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				}
	
	} // closing braces for after advice
	


}//end of aspect