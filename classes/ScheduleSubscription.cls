global class ScheduleSubscription implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String Query =
        'SELECT '+ 'Id,'+'Name,'+'SBQQ__Account__c,'+'SBQQ__BillingFrequency__c,'+'SBQQ__BillingType__c,'+
		'SBQQ__ChargeType__c,'+'SBQQ__ContractNumber__c,'+'SBQQ__Contract__c,'+'SBQQ__CustomerPrice__c,'+
		'SBQQ__EndDate__c,'+'SBQQ__ListPrice__c,'+'SBQQ__NetPrice__c,'+'SBQQ__Number__c,'+'SBQQ__OrderProduct__c,'+
		'SBQQ__OriginalQuoteLine__c,'+'SBQQ__OriginalUnitCost__c,'+'SBQQ__ProductId__c,'+'SBQQ__ProductName__c,'+
		'SBQQ__ProductOption__c,'+'SBQQ__Product__c,'+'SBQQ__ProrateMultiplier__c,'+'SBQQ__Quantity__c,'+'SBQQ__QuoteLine__c,'+
	    'SBQQ__RegularPrice__c,'+'SBQQ__RenewalPrice__c,'+'SBQQ__RenewalProductId__c,'+'SBQQ__RenewalQuantity__c,'+
		'SBQQ__RenewedDate__c,'+'SBQQ__RequiredById__c,'+'SBQQ__RequiredByProduct__c,'+'SBQQ__RevisedSubscription__c,'+
		'SBQQ__RootId__c,'+'SBQQ__SpecialPrice__c,'+'SBQQ__StartDate__c,'+'SBQQ__SubscriptionEndDate__c,'+
		'SBQQ__SubscriptionStartDate__c,'+'SBQQ__TerminatedDate__c,'+'SBQQ__UnitCost__c,'+'SBQQ__ProductSubscriptionType__c,'+
		'SBQQ__SubscriptionType__c,'+'SBQQ__SubscriptionPricing__c'+		
        ' FROM '+' SBQQ__Subscription__c '+
		' WHERE '+
        'Include_Subscription__c = true'
			//' SBQQ__TerminatedDate__c <= NEXT_N_DAYS:10'
        ;
        System.debug('Final Query>>'+Query);
        return Database.getQueryLocator(Query);
    }
    global void execute(Database.BatchableContext bc, List<SBQQ__Subscription__c> records){
		//Set<String> setConId = New Set<String>();
		list<SBQQ__Contract__c> con = new list<SBQQ__Contract__c>();
        Set<ID> setSubs = New Set<ID>();
		Map<String, String> mapConAccID = new map<String, String>();
        Map<Id, ID> mapConOppID = new map<Id, ID>();
        Map<Id, ID> mapConRenQuoID = new map<ID,ID>();
        Map<Id, SBQQ__Subscription__c> mapConSubs = new map<Id, SBQQ__Subscription__c>();
       //MODIDYED: OMKAR || SBQQ__Contract__c && SBQQ__Product__c  MAP
        Map<ID, SET<ID>> mapConProdID = new map<ID,SET<ID>>();

        Map<ID, SET<ID>> mapProdSubSet = new map<ID,SET<ID>>();
		List<Opportunity> listRenOpp = new List<Opportunity>();
		List<SBQQ__Quote__c> listRenQuote = new List<SBQQ__Quote__c>();
        List<SBQQ__Quote__c> listRenQuoUpdate = new List<SBQQ__Quote__c>();
        List<SBQQ__QuoteLine__c> listRenQLines = new List<SBQQ__QuoteLine__c>();
        //For Test
        String qID;
		 
		//Id renewalOppRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(‘Renewal’).getRecordTypeId();
        //System.debug('renewalOppRecordTypeID----'+renewalOppRecordTypeID);
        //Iterarte through subscriptions to get Contract and Account Id's 
        for( SBQQ__Subscription__c objSub : records ){
            System.debug('objSub----'+objSub);
            setConId.add(objSub.SBQQ__Contract__c);
            setProdID.add(objSub.SBQQ__Product__c);
            setSubs.add(objSub.Id);
			mapConAccID.put(objSub.SBQQ__Contract__c, objSub.SBQQ__Account__c);
            }

        // MODIDYED: OMKAR || get SBQQ__Contract__c and SBQQ__Product__c IDS 
		  for( SBQQ__Subscription__c objSub0 : records ){
            setConId.add(objSub0.SBQQ__Contract__c);
            setProdID.add(objSub0.SBQQ__Product__c);
            setSubs.add(objSub0.Id);
			mapConProdID.put(objSub0.SBQQ__Product__c, objSub0.SBQQ__Contract__c);
            }    
        
		for(String conID:setConId){
            //Create Renewal Opportunity
			Opportunity renOpp = new Opportunity();
			renOpp.Name = date.today()+'Test Renewal'+conID;
			renOpp.SBQQ__RenewedContract__c = conID;
			renOpp.AccountId = mapConAccID.get(conID);
			renOpp.StageName = 'Prospecting';
			renOpp.SBQQ__Renewal__c = true;
            renOpp.CloseDate = date.today();
			listRenOpp.add(renOpp);
            //Create renewal Quote
            SBQQ__Quote__c renQuote = new SBQQ__Quote__c();
            renQuote.SBQQ__Primary__c = true;
            renQuote.SBQQ__Account__c = mapConAccID.get(conID);
            renQuote.SBQQ__Type__c = 'Renewal';
            renQuote.SBQQ__StartDate__c = Date.Today();
            renQuote.Renewal_Contract_Id__c = conID;
            renQuote.SBQQ__ContractingMethod__c = 'Single Contract';
            listRenQuote.add(renQuote);
		}
		if(listRenOpp.size()!= 0){
            System.debug('Great we have some Opportunity');
			insert listRenOpp;
		}
        for(Opportunity createdOpportunities: listRenOpp){
            mapConOppID.put(createdOpportunities.SBQQ__RenewedContract__c, createdOpportunities.Id);
        }
        if(listRenQuote.size()!=0){
            System.debug('Great we have some Renewal Quote');
            insert listRenQuote;
        }
         for(SBQQ__Quote__c createdRenQuote : listRenQuote){
            System.debug('Inside for Loop to update Opportunity on Quote');
            createdRenQuote.SBQQ__Opportunity2__c = mapConOppID.get(createdRenQuote.Renewal_Contract_Id__c);
            mapConRenQuoID.put(createdRenQuote.Renewal_Contract_Id__c, createdRenQuote.ID);
            listRenQuoUpdate.add(createdRenQuote);
        }
        if(listRenQuoUpdate.size()!=0){
            System.debug('Great we have list of Renewal Quote for Update');
            update listRenQuoUpdate;
        }
        /*for( SBQQ__Subscription__c subQL : records ){
            SBQQ__QuoteLine__c renQL = new SBQQ__QuoteLine__c();
            renQL.SBQQ__Quote__c = mapConRenQuoID.get(subQL.SBQQ__Contract__c);
            System.debug('mapConRenQuoID.get(subQL.SBQQ__Contract__c):'+renQL.SBQQ__Quote__c);
            qID = renQL.SBQQ__Quote__c;
            renQL.SBQQ__Product__c = subQL.SBQQ__Product__c;
            renQL.SBQQ__BillingFrequency__c = subQL.SBQQ__BillingFrequency__c;
            renQL.SBQQ__BillingType__c = subQL.SBQQ__BillingType__c;
            renQL.SBQQ__ChargeType__c = subQL.SBQQ__ChargeType__c;
            renQL.SBQQ__ListPrice__c = subQL.SBQQ__ListPrice__c;
            renQL.SBQQ__ProrateMultiplier__c = subQL.SBQQ__ProrateMultiplier__c;
            renQL.SBQQ__RegularPrice__c = subQL.SBQQ__RegularPrice__c;
            renQL.SBQQ__SpecialPrice__c = subQL.SBQQ__SpecialPrice__c;
            renQL.SBQQ__CustomerPrice__c = subQL.SBQQ__CustomerPrice__c;
            renQL.SBQQ__UnitCost__c = subQL.SBQQ__UnitCost__c;
            renQL.SBQQ__StartDate__c = Date.today();
            System.debug('Date.today().addMonths(12): '+Date.today().addMonths(12));
            renQL.SBQQ__EndDate__c = Date.today().addMonths(12);
            listRenQLines.add(renQL);
        }*/
        for(String listCon: setConId){
            
            for(String listProd: mapConProdID.get(listCon)){
                
            }    
        }
        
         if(listRenQLines.size()!=0){
            System.debug('Great we have some Renewal Quote Lines');
            insert listRenQLines;
        }
        /*We are here */
        /*QuoteReader reader = new QuoteReader();
        QuoteModel quoteModel = reader.read(qID);
        System.debug('quoteModel>>'+quoteModel);
        QuoteCalculator calculator = new QuoteCalculator();
        System.debug('Before Quote Calculate');
		calculator.calculate(quoteModel, 'MyCallback');*/
	}
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    } 
}