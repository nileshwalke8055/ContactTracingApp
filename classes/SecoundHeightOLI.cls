public class SecoundHeightOLI {
    public SecoundHeightOLI(){   
      List<Opportunity> secondHighestAmount = [SELECT Id, Name, Amount FROM Opportunity ORDER BY Amount DESC NULLS LAST LIMIT 1 OFFSET 1];
if(secondHighestAmount.size() == 1) {
     Opportunity secondHighestOpp = secondHighestAmount.get(0);
     //Do something with secondHighestOpp
     //System.de
     System.debug('SecoundHeightOLI'+secondHighestOpp);
}
}
}