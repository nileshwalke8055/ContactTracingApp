public class BillSpliter {
    
    //conc veriabes
final integer Only_One_Slice = 8;
final integer Upto_Three_Slice =7;
final integer More_Than_Three_Slices =6;
    
    //Billing methods logic
    public  integer getBill(Integer NumberOFSlices){
        integer TotalBillToPay = numberofSlices == 1 ? Only_One_Slice * numberofSlices :
	   		(numberofSlices <=3 ? Upto_Three_Slice *numberofSlices :
				More_Than_Three_Slices*numberofSlices);
        return  TotalBillToPay;
    }
}