public class XeroKeepConnection implements Schedulable {

    public void execute(SchedulableContext sc) {
        XeroCalloutService.refreshToken();
    }
}