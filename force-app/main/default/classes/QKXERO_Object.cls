public interface QKXERO_Object {

	// This works fundamentally differently to `query` - this gives you way more info
	QKXERO_Object getById(String xeroId);

	// Get all invoices that match a given where condition and/or modified since. This also has pagination
	List<QKXERO_Object> query(String whereCondition, Datetime modifiedSince, Integer page);

	// Get all invoices that match a given where condition and/or modified since. This does not have pagination
	List<QKXERO_Object> query(String whereCondition, Datetime modifiedSince);

	// Get all invoices that match a given where condition 
	List<QKXERO_Object> query(String whereCondition);

	// Get all invoices
	List<QKXERO_Object> query();

	String serialise(QKXERO_Object xObject);

	List<QKXERO_Object> deserialise(String jsonResult);

	List<QKXERO_Object> saveXero(List<QKXERO_Object> xObjects);

	QKXERO_Object saveXero(QKXERO_Object xObject);

/*	
	// Sadly this isn't going to work in Apex OOP accross different kinds of objects, will need to give different parameters based on different types
	SObject convertToSobject(QKXERO_Object xObject);

	QKXERO_Object convertToXero(SObject sfObject);*/
	
	
}