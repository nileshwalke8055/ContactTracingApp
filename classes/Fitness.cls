public class Fitness { 
    
    public static decimal calculateBMI(decimal weight,decimal height){ 
        if(height ==0 || weight ==0 || height <0 || weight <0){
         return -1;
        }else{
        decimal BMI = weight/height;
        return BMI; 
    }
    }
    public static Decimal calculatePace(decimal Distance_in_KM,decimal Time_In_Min ){
        if(Distance_in_KM ==0 || Time_In_Min ==0){
         return -1;
        }else{
        Decimal hr =Time_In_Min/60;
        Decimal Pace =Distance_in_KM/hr;        
        return Pace;
    }
}
}