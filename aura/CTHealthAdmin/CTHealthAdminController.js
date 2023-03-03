({
    tabSelectHandler : function(component, event, helper) {
        const selectedTabId = event.getParam("id");
        if(selectedTabId ==='Person'){
            component.set("v.headerTitle", "person View");
        }else{
            component.set("v.headerTitle", "Location view");
        }
            component.set("v.scope", selectedTabId);

        const healthHeaderComp = component.find("heath-header");
        healthHeaderComp.fetchCount();    
    }
});
