public with sharing class XeroKeepConnectionScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        System.enqueueJob(new XeroKeepConnection());
    }
}