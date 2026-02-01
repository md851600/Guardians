package tek.capstone.guardians.steps;

import java.util.List;

import org.junit.Assert;
import org.openqa.selenium.WebElement;

import io.cucumber.java.en.*;
import tek.capstone.guardians.pages.POMFactory;
import tek.capstone.guardians.utilities.CommonUtility;

public class RetailOrderSteps extends CommonUtility{

	POMFactory pomFactory = new POMFactory();
	
	//Add order to cart
	
	@When("User change the category to {string}")
	public void userChangeTheCategoryTo(String category) {
	    selectByVisibleText(pomFactory.orderPage().AllDepartment, category);
	    logger.info("user changed category successfully");
	}
	@When("User search for an item {string}")
	public void userSearchForAnItem(String item) {
	    sendText(pomFactory.orderPage().searchInput, item);
	    logger.info("user searched for item and successfully ");
	}
	@When("User click on Search icon")
	public void userClickOnSearchIcon() {
	    click(pomFactory.orderPage().searchBttn);
	    logger.info("user clicked on search button successfully");
	}
	@When("User click on item")
	public void userClickOnItem() {
	    click(pomFactory.orderPage().KasaOutdoorSmartPlug);
	    logger.info("user clicked on selected item successfully");
	}
	@When("User select quantity {string}")
	public void userSelectQuantity(String quantity) {
	    selectByValue(pomFactory.orderPage().quantitySelect, quantity);
	    logger.info("user clicked on quantity successfully");
	}
	@When("User click add to Cart button")
	public void userClickAddToCartButton() {
	    click(pomFactory.orderPage().addToCartBttn);
	    logger.info("user added the item to card successfully");
	}
	@Then("the cart icon quantity should change to {string}")
	public void theCartIconQuantityShouldChangeTo(String quantity) {
		if(pomFactory.orderPage().quantitySelect.getText().equals("2")) {
			logger.info("icon quantity changed to 2 successfully");
		}
	    
	}
	
	
	//Add item to cart and Place order 
	
	@Given("User change the category to {string} Apex Legends")
	public void userChangeTheCategoryToApexLegends(String category) {
	    selectByVisibleText(pomFactory.orderPage().AllDepartment, category);
	    logger.info("user select Electronice from category successffully");
	}
	@Given("User search for an item {string} Apex Legends")
	public void userSearchForAnItemApexLegends(String item) {
	   sendText(pomFactory.orderPage().searchInput, item);
	   logger.info("user searched for item successfully");
	}
	@Given("User click on item Apex Legends")
	public void userClickOnItemApexLegends() {
	    click(pomFactory.orderPage().apexLegends);
	    logger.info("user clicked on item successfully");
	}
	@Given("User select quantity {string} for Apex Legends")
	public void userSelectQuantityForApexLegends(String quantity) {
	   selectByValue(pomFactory.orderPage().quantitySelect, quantity);
	   logger.info("user select quantity to 5 successfully");
	}
	@Then("the cart icon quantity should change to {string} Apex Legends")
	public void theCartIconQuantityShouldChangeToApexLegends(String quantity) {
	    Assert.assertTrue(pomFactory.orderPage().quantitySelect.isDisplayed());
	    logger.info("quantity displayed successfully");
	}
	@Then("User click on Cart option")
	public void userClickOnCartOption() {
	    click(pomFactory.orderPage().cartButton);
	    logger.info("user clicked on cart option successfully");
	}
	@Then("User click on Proceed to Checkout button")
	public void userClickOnProceedToCheckoutButton() {
	    click(pomFactory.orderPage().proceedToCheckout);
	    logger.info("user clicked on proceed to checkout button successfully");
	}
	@Then("User click on Place Your Order")
	public void userClickOnPlaceYourOrder() {
	    click(pomFactory.orderPage().placeOrderBttn);
	    logger.info("user clicked on place order button successfull");
	}
	@Then("a message should be displayed ‘Order Placed, Thanks’")
	public void aMessageShouldBeDisplayedOrderPlacedThanks() {
	    Assert.assertTrue(pomFactory.orderPage().orderPlacedMsg.isDisplayed());
	    logger.info("order placed and msg displayed sucessfully");
	}
	
	
	//Cancel order from order list
	
	@When("User click on Orders section")
	public void userClickOnOrdersSection() {
	  click(pomFactory.orderPage().ordersBttn);
	  logger.info("user clicked on orders buttn successfully");
	}
	@When("User click on first order in list")
	public void userClickOnFirstOrderInList() {
	   List <WebElement> orderListing = pomFactory.orderPage().ordersList;
	   for(int i =0; i<orderListing.size();i++) {
		   if (orderListing.get(i).getText().equalsIgnoreCase("Hide Details")) {
			   
		   }else if (orderListing.get(i).getText().equalsIgnoreCase("Show Details")) {
			  click(pomFactory.orderPage().ordersList.get(i));
		   }
	   }
	   logger.info("user select the first order on list successfully ");
	}
	@When("User click on Cancel The Order button")
	public void userClickOnCancelTheOrderButton() {
	 List<WebElement> cancelOrdersBttn= pomFactory.orderPage().cancelBttn;
	 for(int i=0 ; i< cancelOrdersBttn.size();i++) {
		 click(pomFactory.orderPage().cancelBttn.get(0));
	 }
	   
	    logger.info("user clicked cancel on select item successfully");
	}
	@When("User select the cancelation Reason {string}")
	public void userSelectTheCancelationReason(String CancelR) {
	    selectByVisibleText(pomFactory.orderPage().cancelReason, CancelR);
	    logger.info("cancel reason was selected successfully");
	}
	@When("User click on Cancel Order button")
	public void userClickOnCancelOrderButton() {
	    click(pomFactory.orderPage().cancelOrderbttn);
	    logger.info("user clicked on cancel button successfully");
	}
	@Then("a cancelation message should be displayed {string}")
	public void aCancelationMessageShouldBeDisplayed(String message) {
		waitTillPresence(pomFactory.orderPage().orderCancelMsg);
	    Assert.assertTrue(pomFactory.orderPage().orderCancelMsg.isDisplayed());
	    logger.info("order canceled and msg displayed successfully");
	}


	//Return Item from order list
	
	@When("User click on Orders sections")
	public void userClickOnOrdersSections() {
	    click(pomFactory.orderPage().ordersBttn);
	    logger.info("user clicked on orders page successfullt");
	}
	
	@When("User click on first order in list returning")
	public void userClickOnFirstOrderInListReturning() {
	    List <WebElement> orderLists = pomFactory.orderPage().ordersList;
	    for(int i=0; i<orderLists.size();i++) {
	    	if(orderLists.get(i).getText().equalsIgnoreCase("Hide Details")) {
	    		
	    }else if(orderLists.get(i).getText().equalsIgnoreCase("Show Details")) {
	    	click(pomFactory.orderPage().ordersList.get(i));
	    }
	    }
	    logger.info("user select the first item on orders successfully");
	}
	@When("User click on Return Items button")
	public void userClickOnReturnItemsButton() {
		
		
	   List<WebElement> returnItemL = pomFactory.orderPage().returnItemsList;
	   for(int i =0; i<returnItemL.size();i++) {
		   click(returnItemL.get(0));
	   }
	   logger.info("user clicked return button on selected item list successfully");
	}
	@When("User select the Return Reason {string}")
	public void userSelectTheReturnReason(String Reason) {
		selectByVisibleText(pomFactory.orderPage().cancelReason, Reason);
		logger.info("user select the return reason successfully");

	}
	@When("User select the drop off service {string}")
	public void userSelectTheDropOffService(String service) {
	    selectByVisibleText(pomFactory.orderPage().returnShipOption, service);
	    logger.info("user select the shipping option successfully");
	}
	@When("User click on Return Order button")
	public void userClickOnReturnOrderButton() {
	    click(pomFactory.orderPage().returnOrderBttn);
	    logger.info("user clicked on return button successfully");
	}
	
	@Then("a returning message should be displayed {string}")
	public void aReturningMessageShouldBeDisplayed(String message) {
		waitTillPresence(pomFactory.orderPage().returnSuccessMsg);
		String actual = pomFactory.orderPage().returnSuccessMsg.getText();
		String expected = message;
		Assert.assertEquals(actual, expected);
		logger.info("return msg displayed successfully ");
	}

	
	//Add review
	
	@When("User click on Review button")
	public void userClickOnReviewButton() {
	    List<WebElement> selectReview = pomFactory.orderPage().reviewButtonList;
	    click(selectReview.get(0));
	    logger.info("user clicked on first item on oder to reveiw successfully");
	}
	@When("User write Review headline {string} and review text {string}")
	public void userWriteReviewHeadlineAndReviewText(String headline, String text) {
	    sendText(pomFactory.orderPage().reviewHeadline, headline);
	    sendText(pomFactory.orderPage().reviewText, text);
	    logger.info("user entered headline and text in review section successfully");
	}
	@When("User click Add your Review button")
	public void userClickAddYourReviewButton() {
	    click(pomFactory.orderPage().addReviewBttn);
	    logger.info("user clicked on add review button successfully");
	}
	
	
	@Then("a review message {string} should be displayed")
	public void aReviewMessageShouldBeDisplayed(String message) {
	   waitTillPresence(pomFactory.orderPage().reviewSuccessMSg);
	   String actual = pomFactory.orderPage().reviewSuccessMSg.getText();
	   String expected = message;
	   Assert.assertEquals(actual, expected);
	   logger.info("added review msg success displayed");
	}
	

}
