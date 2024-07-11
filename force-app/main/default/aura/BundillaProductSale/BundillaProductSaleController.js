({
init : function (component) {
// Find the component whose aura:id is “flowData”
var flow = component.find("Create_new_Product_Sale_for_FS_App");
// In that component, start your flow. Reference the flow’s Unique Name.
flow.startFlow("Create_new_Product_Sale_for_FS_App");
},
})