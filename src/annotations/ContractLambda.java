
package annotations;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target(value = ElementType.METHOD)
@Retention(value = RetentionPolicy.RUNTIME)
public @interface ContractLambda {

	 String Description();
	 String[] pre_cond_lambda() default " ";
	 String[] post_cond_lambda() default " ";
	 String[] invariant_cond_lambda() default " ";
	
	 
}
