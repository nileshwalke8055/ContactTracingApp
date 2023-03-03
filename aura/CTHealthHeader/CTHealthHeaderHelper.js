({
    fetchStatusCount: function (component) {
        const scope = component.get("v.scope");

        let action = scope === "Person" ? component.get("c.getPersonHealthStatusCount") 
                                        : component.get("c.getLocationHealthStatucCount");

        action.setCallback(this, function (response) {
            const state = response.getState();

            if (state === "SUCCESS") {
                component.set("v.count", response.getReturnValue());
            }
        });

        $A.enqueueAction(action);
    }
});
