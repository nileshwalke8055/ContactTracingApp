@istest
public class FitnessTest {
@istest
     public Static  void  method(){ 
    	 Decimal weight =70;
         Decimal height =6.5;
         
         Decimal BMI =Fitness.calculateBMI(weight, height);
         BMI =BMI.setScale(1);
         system.assertEquals(10.8,BMI,'wrong value');
      
     }
    @istest
    public Static  void  method1(){ 
    	 Decimal weight =0;
         Decimal height =6.5;
         
         Decimal BMI =Fitness.calculateBMI(weight, height);
         system.assertEquals(-1,BMI,'wrong value');
        
    }
    @istest
    public Static  void  method2(){ 
    	 Decimal weight =-90;
         Decimal height =6.5;
         
         Decimal BMI =Fitness.calculateBMI(weight, height);
         
         system.assertEquals(-1,BMI,'wrong value');
        
    }   
    @istest
    public Static  void  method3(){ 
    	 Decimal weight =0;
         Decimal height =6.5;
         
         Decimal BMI =Fitness.calculateBMI(weight, height);
         system.assertEquals(-1,BMI,'wrong value');
        
    } 
@istest    
    public Static  void  method4(){ 
    	 Decimal weight =-10;
         Decimal height =0;
         
         Decimal BMI =Fitness.calculateBMI(weight, height);
         system.assertEquals(-1,BMI,'wrong value');
        
    }    
    @istest
    public static void solution(){
        decimal Distance_in_KM =10;
        decimal Time_In_Min    =15;
        
        Decimal Pace =Fitness.calculatePace(Distance_in_KM, Time_In_Min);
        System.assertEquals(150, pace, 'wrong value');
    }
     @istest
    public static void solution1(){
        decimal Distance_in_KM =0;
        decimal Time_In_Min    =15;
        
        Decimal Pace =Fitness.calculatePace(Distance_in_KM, Time_In_Min);
        System.assertEquals(-1, pace, 'wrong value');
    }
     @istest
    public static void solution2(){
        decimal Distance_in_KM =-60;
        decimal Time_In_Min    =15;
        
        Decimal Pace =Fitness.calculatePace(Distance_in_KM, Time_In_Min);
        System.assertEquals(-2.4, pace, 'wrong value');
    }
     @istest
    public static void solution3(){
        decimal Distance_in_KM =0;
        decimal Time_In_Min    =0;
        
        Decimal Pace =Fitness.calculatePace(Distance_in_KM, Time_In_Min);
        System.assertEquals(-1, pace, 'wrong value');
    }

}