@istest
public class Covid19Test {
    
    @istest
    public static void treatPatientTest(){
        //creating the instance 
        Covid19 cov = new Covid19(10);
        //check if the count is 10 oe\r not
        Integer treated =cov.getTreated();
        System.assertEquals(10,treated,'trated count doesnt match');
        cov.treatPatient();
    }
    
}