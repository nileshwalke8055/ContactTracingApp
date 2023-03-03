public class SortingPositiveandNegativeVlaues {
    
    public  List<Integer> generateStringArray()
    {
        Integer[] arrayname =new Integer[] {1,-1,3,2,-7,-5,11,6};
        for(Integer num :arrayname){
            if(num > 0){
                system.debug('num:'+num);
            }
        }
        for(Integer num :arrayname){
            if(num < 0){
                system.debug('num:'+num);
            }
        }
     return arrayname;        
    }
}