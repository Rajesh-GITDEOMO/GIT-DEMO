@istest

public class Test_SVPDashboardQuickLinkController {

private static TestMethod void test2(){
SVPDashboardQuickLinkController sVp = new SVPDashboardQuickLinkController();

SVP_Dashboard_Quicklink__c quickLink1  = new SVP_Dashboard_Quicklink__c ();
quickLink1.Name = 'testData';
quickLink1.Dashboard_ID__c ='test1id';

List<SVPDashboardQuickLinkController.DashboardLink> dashLinkList = new List<SVPDashboardQuickLinkController.DashboardLink>();
SVPDashboardQuickLinkController.DashboardLink ab = new SVPDashboardQuickLinkController.DashboardLink(quickLink1.Name,quickLink1.Dashboard_ID__c);
dashLinkList.add(ab);

sVp.dashboardLinks = dashLinkList;
System.assertNotEquals(null,sVp.dashboardLinks);
 }
 
private static TestMethod void test1(){
SVPDashboardQuickLinkController sVp = new SVPDashboardQuickLinkController();
SVP_Dashboard_Quicklink__c quickLink1  = new SVP_Dashboard_Quicklink__c ();
quickLink1.Name = 'testData';
quickLink1.Dashboard_ID__c ='test1id';
insert quickLink1;
sVp.dashboardLinks = null;
System.assertNotEquals(null,sVp.dashboardLinks);
 }
}