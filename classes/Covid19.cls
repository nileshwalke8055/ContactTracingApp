public class Covid19 {
    Public Integer recoveredInArea =0;
    public Static  Integer recoveredInCountry =0;
    
     public Covid19(Integer recoveredInArea){
         this.recoveredInArea =recoveredInArea;
         recoveredInCountry += recoveredInArea;
     }
   
     public void treatPatient (){
        recoveredInArea++;
        recoveredInCountry++;
        
    }
     public integer getTreated(){
         return recoveredInArea;
     }

}