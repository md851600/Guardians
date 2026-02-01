package tek.capstone.guardians.steps;

import java.util.List;
import java.util.Map;

import org.junit.Assert;

import io.cucumber.java.en.*;
import tek.capstone.guardians.pages.POMFactory;
import tek.capstone.guardians.utilities.CommonUtility;
import tek.capstone.guardians.utilities.DataGenerator;

public class RetailAccountSteps extends CommonUtility{
	
	POMFactory pomFactory = new POMFactory();

	//update name and phone
	
	@When("User click on Account option")
	public void userClickOnAccountOption() {
	    click(pomFactory.retailAccount().accountBttn);
	    logger.info("user click on account button successfully");
	}
	@When("User update Name {string} and Phone {string}")
	public void userUpdateNameAndPhone(String Name, String Phone) {
		clearTextUsingSendKeys(pomFactory.retailAccount().nameInputField);
	    sendText(pomFactory.retailAccount().nameInputField,DataGenerator.addressGenerator(Name));
	    clearTextUsingSendKeys(pomFactory.retailAccount().phoneInputField);
	    sendText(pomFactory.retailAccount().phoneInputField, DataGenerator.addressGenerator(Phone));
	    logger.info("user enter name and phone successfully");
	}
	@When("User click on Update button")
	public void userClickOnUpdateButton() {
	   click(pomFactory.retailAccount().updateBttn);
	   logger.info("user clicked update button successfully");
	}
	@Then("user profile information should be updated")
	public void userProfileInformationShouldBeUpdated() {
		waitTillPresence(pomFactory.retailAccount().updateConfirmMsg);
		String expectedMsg ="Personal Information Updated Successfully";
		String actualMsg = pomFactory.retailAccount().updateConfirmMsg.getText();
	    Assert.assertEquals(expectedMsg, actualMsg);
	    logger.info("Name and phone number updated successfully msg displayed");
	}
	
	
	//Add payment
	@When("User click on Add a payment method link")
	public void userClickOnAddAPaymentMethodLink() {
		click(pomFactory.retailAccount().addPaymentBttn);
		logger.info("user clicked on add payment button successfully");
	}
	@When("User fill Debit or credit card information")
	public void userFillDebitOrCreditCardInformation(io.cucumber.datatable.DataTable dataTable) {
	   List<Map <String , String>> cardInfo = dataTable.asMaps(String.class, String.class);
	   clearTextUsingSendKeys(pomFactory.retailAccount().cardNumber);
	   sendText(pomFactory.retailAccount().cardNumber, DataGenerator.addressGenerator(cardInfo.get(0).get("cardNumber")));
	   
	   clearTextUsingSendKeys(pomFactory.retailAccount().nameOnCard);
	   sendText(pomFactory.retailAccount().nameOnCard, DataGenerator.addressGenerator(cardInfo.get(0).get("nameOnCard")));
	   
	   clearTextUsingSendKeys(pomFactory.retailAccount().expirationMonth);
	   sendText(pomFactory.retailAccount().expirationMonth,cardInfo.get(0).get("expirationMonth"));
	   
	   clearTextUsingSendKeys(pomFactory.retailAccount().expirationYear);
	   sendText(pomFactory.retailAccount().expirationYear,cardInfo.get(0).get("expirationYear"));
	   
	   clearTextUsingSendKeys(pomFactory.retailAccount().securityCode);
	   sendText(pomFactory.retailAccount().securityCode, cardInfo.get(0).get("securityCode"));
	   
	   logger.info("Card info "+cardInfo + " is present");
		
	}
	@When("User click on Add your card button")
	public void userClickOnAddYourCardButton() {
		click(pomFactory.retailAccount().addCardBttn);
		logger.info("user clciked on add card button successfully");
		
	}
	@Then("a message should be displayed ‘Payment Method added successfully’")
	public void aMessageShouldBeDisplayedPaymentMethodAddedSuccessfully() {
	  waitTillPresence(pomFactory.retailAccount().cardVerifyUpdateMsg);
	  String expected = "Payment Method added sucessfully";
	  String actual = pomFactory.retailAccount().cardVerifyUpdateMsg.getText();
	  Assert.assertEquals(actual, expected);
	  logger.info("payment method added and suuccess msg displayed");
	}
	
	
	//Update payment
	
	
	
	
	@And ("User select payment card")
	public void userSelectPaymentCard() {
		click(pomFactory.retailAccount().selectMasterCard);
		logger.info("user select payment card successfuly");
	}
	
	@When("User click on Edit option of card section")
	public void userClickOnEditOptionOfCardSection() {
	   click(pomFactory.retailAccount().editCardBttn);
	   logger.info("user clicked on edit button successfully");
	}
	@When("user edit information with below data")
	public void userEditInformationWithBelowData(io.cucumber.datatable.DataTable dataTable) {
		List<Map<String, String>> updateInfo = dataTable.asMaps(String.class, String.class);
		clearTextUsingSendKeys(pomFactory.retailAccount().cardNumber);
		sendText(pomFactory.retailAccount().cardNumber, DataGenerator.addressGenerator(updateInfo.get(0).get("cardNumber")));
		
		clearTextUsingSendKeys(pomFactory.retailAccount().nameOnCard);
		sendText(pomFactory.retailAccount().nameOnCard,DataGenerator.addressGenerator(updateInfo.get(0).get("nameOnCard")));
		
		clearTextUsingSendKeys(pomFactory.retailAccount().expirationMonth);
		sendText(pomFactory.retailAccount().expirationMonth, updateInfo.get(0).get("expirationMonth"));
		
		clearTextUsingSendKeys(pomFactory.retailAccount().expirationYear);
		sendText(pomFactory.retailAccount().expirationYear, updateInfo.get(0).get("expirationYear"));
		
		clearTextUsingSendKeys(pomFactory.retailAccount().securityCode);
		sendText(pomFactory.retailAccount().securityCode, updateInfo.get(0).get("securityCode"));
	
		logger.info("User updated the payment info successfully");
		
		
	}
	@When("user click on Update Your Card button")
	public void userClickOnUpdateYourCardButton() {
	    click(pomFactory.retailAccount().addCardBttn);
	    logger.info("user clicked on update button successfully");
	}
	@Then("a message should be displayed ‘Payment Method updated Successfully’")
	public void aMessageShouldBeDisplayedPaymentMethodUpdatedSuccessfully() {
	    waitTillPresence(pomFactory.retailAccount().paymentInfoUpdate);
	    String actual = pomFactory.retailAccount().paymentInfoUpdate.getText();
	    String expected = "Payment Method updated Successfully";
	    Assert.assertEquals(actual, expected);
	    logger.info("payment update msg displayed successfully");
	}
	
	
	//Remove payment Card
	
	@When("User click on remove option of card section")
	public void userClickOnRemoveOptionOfCardSection() {
	    click(pomFactory.retailAccount().removePCard);
	    logger.info("user clicked on remove card button successfully");
	}
	@Then("payment details should be removed")
	public void paymentDetailsShouldBeRemoved() {
		if(!isElementDisplayed(pomFactory.retailAccount().selectMasterCard)) {
			logger.info("Card removed successfully");
		}else {
			logger.info("Card is not removed");
		}
	}
	
	//Add Address field
	
	@When("User click on Add address option")
	public void userClickOnAddAddressOption() {
	    click(pomFactory.retailAccount().addAddressBttn);
	    logger.info("user clicked on add address button successfully");
	}
	@When("user fill new address form with below information")
	public void userFillNewAddressFormWithBelowInformation(io.cucumber.datatable.DataTable dataTable) {
	   List <Map<String, String>> addressInfo = dataTable.asMaps(String.class, String.class);
	   clearTextUsingSendKeys(pomFactory.retailAccount().countrySelect);
	   selectByVisibleText(pomFactory.retailAccount().countrySelect, DataGenerator.addressGenerator(addressInfo.get(0).get("country")));
	   
	   clearTextUsingSendKeys(pomFactory.retailAccount().addressFieldName);
	   sendText(pomFactory.retailAccount().addressFieldName,DataGenerator.addressGenerator(addressInfo.get(0).get("fullName")));
	   
	   clearTextUsingSendKeys(pomFactory.retailAccount().addressPhoneField);
	   sendText(pomFactory.retailAccount().addressPhoneField, DataGenerator.addressGenerator(addressInfo.get(0).get("phoneNumber")));
	   
	   clearTextUsingSendKeys(pomFactory.retailAccount().streetField);
	   sendText(pomFactory.retailAccount().streetField, DataGenerator.addressGenerator(addressInfo.get(0).get("streetAddress")));
	   
	   clearTextUsingSendKeys(pomFactory.retailAccount().apartmentField);
	   sendText(pomFactory.retailAccount().apartmentField,DataGenerator.addressGenerator(addressInfo.get(0).get("apt")));
	   
	   clearTextUsingSendKeys(pomFactory.retailAccount().cityField);
	   sendText(pomFactory.retailAccount().cityField,DataGenerator.addressGenerator(addressInfo.get(0).get("city")));
	   
	   clearTextUsingSendKeys(pomFactory.retailAccount().stateField);
	   selectByVisibleText(pomFactory.retailAccount().stateField,DataGenerator.addressGenerator(addressInfo.get(0).get("state")));
	   
	   clearTextUsingSendKeys(pomFactory.retailAccount().zipCodeField);
	   sendText(pomFactory.retailAccount().zipCodeField, DataGenerator.addressGenerator(addressInfo.get(0).get("zipCode")));
	   
	   logger.info("user entered address info successfully");
	   
		
	}
	@When("User click Add Your Address button")
	public void userClickAddYourAddressButton() {
	    click(pomFactory.retailAccount().addYourAddressBttn);
	    logger.info("user clicked on add your address button successfully");
	}
	@Then("a message should be displayed ‘Address Added Successfully’")
	public void aMessageShouldBeDisplayedAddressAddedSuccessfully() {
	    waitTillPresence(pomFactory.retailAccount().addressAddMsg);
	    String actual = pomFactory.retailAccount().addressAddMsg.getText();
	    String expected = "Address Added Successfully";
	    Assert.assertEquals(expected, actual);
	    logger.info("add address message displayed successfully");
	}
	
	//Update address info
	@When("User click on Account options")
	public void userClickOnAccountOptions() {
	    click(pomFactory.retailAccount().accountBttn);
	    logger.info("user click on account option successfully");
	}
	@When("User click on edit address option")
	public void userClickOnEditAddressOption() {
	   click(pomFactory.retailAccount().editAddressBttn);
	   logger.info("user click on edit address button successfully");
	}
	
	
	@When("User click update Your Address button")
	public void userClickUpdateYourAddressButton() {
	    click(pomFactory.retailAccount().updateYourAddressBttn);
	    logger.info("user click on update address button successfully");
	}
	@Then("a message should be displayed ‘Address Updated Successfully’")
	public void aMessageShouldBeDisplayedAddressUpdatedSuccessfully() {
	   waitTillPresence(pomFactory.retailAccount().updateYourAddressMsg);
	   String actual = pomFactory.retailAccount().updateYourAddressMsg.getText();
	   String expected = "Address Updated Successfully";
	   Assert.assertEquals(actual, expected);
	   logger.info("Update address msg displayed successfully");
	}

	
	//Remove Address
	
	@When("User click on remove option of Address section")
	public void userClickOnRemoveOptionOfAddressSection() {
		click(pomFactory.retailAccount().removeAddressBttn);
		logger.info("user clicked on remove button successfully");

	}
	@Then("Address details should be removed")
	public void addressDetailsShouldBeRemoved() {
	   if (!isElementDisplayed(pomFactory.retailAccount().addressremovedIcon)) {
		   logger.info("Address removed successfully");
		   
	   }
	}



}
