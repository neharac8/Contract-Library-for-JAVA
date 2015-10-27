
package aspectesting;


import java.util.Arrays;
import java.util.Hashtable;
import java.util.Scanner;
import java.lang.annotation.*;
import java.lang.reflect.AnnotatedElement;

import annotations.Contract;





import java.util.Scanner;

import annotations.FUNCTIONCHECK;

@SuppressWarnings("unused")
public class Sort_Quicksort 
{
	static Sort_Quicksort obj = new Sort_Quicksort();
    public static void sort(int[] arr)
    {
        quickSort(0, arr.length - 1,arr,obj);
    }
 
    @Contract(invariant_cond={"low>=0"},
    		  pre_cond={"low>-1","high>low"},
    		  post_cond={"FUNCTIONCHECK:obj.isSort"},
			  Description="Check Contracts")
    
    public static void quickSort(int low, int high,int arr[],Sort_Quicksort obj) 
    {
        int i = low, j = high;
        int temp;
        int pivot = arr[(low + high) / 2];
 
        // partition 
        while (i <= j) 
        {
            while (arr[i] < pivot)
                i++;
            while (arr[j] > pivot)
                j--;
            if (i <= j) 
            {
                /** swap **/
                temp = arr[i];
                arr[i] = arr[j];
                arr[j] = temp;
 
                i++;
                j--;
            }
        }
 
       //recursively sort lower half
        if (low < j)
            quickSort(low, j,arr,obj);
        //recursively sort upper half
        if (i < high)
            quickSort(i, high,arr,obj);
    }
   
    @FUNCTIONCHECK(Description="Include functions in conditions")
	public static boolean isSort(int low, int high,int arr[],Sort_Quicksort obj)
	{
		
		for(int i=1;i<arr.length;i++)
		{
			if(!(arr[i-1] <= arr[i]))
			{
				return false;
			}
		}
		
		return true;
				
	}
    
    
    
    
    @SuppressWarnings("resource")
	public static void main(String args[])
    {
        Scanner scan = new Scanner( System.in );        
        System.out.println("Quick Sort Test\n");
        int n, i;
        long nano,nano1;
        nano=System.nanoTime();
        
        System.out.println("Enter number of integer elements");
        n = scan.nextInt();
        
        int arr[] = new int[ n ];
        
        System.out.println("\nEnter "+ n +" integer elements");
        for (i = 0; i < n; i++)
            arr[i] = scan.nextInt();
        
        sort(arr);
     
        System.out.println("\nElements after sorting ");        
        for (i = 0; i < n; i++)
            System.out.print(arr[i]+" ");            
        System.out.println();
        
       // nano1=System.nanoTime();
       // long nano2=nano1-nano;
       // System.out.println("the time for 2 elements is: "+nano2);
    }    
}


	


