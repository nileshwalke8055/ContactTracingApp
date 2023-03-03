public class Company {
    public String companyName;
    public String ceo;
    public Integer employeecount;
    public Long revenue;
    
    
    private List<Client> Customers = new List<Client>();
    
    public void addNewCustomer(String clinetName,String website,String email,Long phone){
        Client customer =new Client(clinetName,website,email,phone);
      Customers.add(customer);
    }
    
    public void getAllCustomers(){
        for(Client customer :Customers){
            System.debug('Customer Name:'+customer.clinetName+'website:'+customer.website+'email:'+customer.email+'phone:'+customer.phone);
                
        }
        
    }
    private class Client{
        public String clinetName;
        public String website;
        public string email;
        public long phone;
        
        Client(String clinetName,String website,String email,Long phone){
            this.clinetName =clinetName;
            this.website=website;
            this.email=email;
            this.phone=phone;
            
        }
    }

}