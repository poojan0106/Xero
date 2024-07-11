public class XeroValidationError {

    public String Message;

    /**
    *   @author Ben Edwards (ben@edwards.nz)
    *   @description Convert Xero Validation Errors into a single string
    *   @return Single error string
    **/
    public static String processValidationErrors(List<XeroValidationError> validationErrors) {

        String errors = '';

        for (XeroValidationError error :validationErrors) {

            errors += ('\n- ' + error.Message);
        }

        //XeroErrorLog_ByRes.createErrorLogForXeroCalloutXeroAPi(222, 'rest', errors);
                
        return errors;
    }
}