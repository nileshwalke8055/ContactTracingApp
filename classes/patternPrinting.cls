public class patternPrinting {
    public  void print_rectangle() {
        integer n=4;
        integer m=4;
        for(integer i=1; i<=4; i++){
            String s=' ';
            boolean k;
            
            for(integer j=1; j<=4; j++){ 
                if(i==1 || i==4 || j==1 || j==4){
                    s =s+'*';
                    k=false;
                }
                else if(j==1||n==1 ||j==4 ||m==4){ 
                    s =s+ '  ';
                k=true;
            }
            }
            system.debug(s);      
    }
}
}