package tek.capstone.guardians.pages;

import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import tek.capstone.guardians.base.BaseSetup;

public class RetailAccountPage extends BaseSetup{
	
	public RetailAccountPage () {
		PageFactory.initElements(getDriver(), this);
	}

	
	@FindBy(id = "signinLink")
	public WebElement signInOption;
	
	@FindBy(id = "email")
	public WebElement emailField;
	
	@FindBy (id = "password")
	public WebElement passwordField;
	
	@FindBy (xpath = "//button[text()='Login']")
	public WebElement loginBttn;
	
	@FindBy(id = "logoutBtn")
	public WebElement logOutBttnVeiw;
	
	@FindBy(id = "accountLink")
	public WebElement accountBttn;
	
	@FindBy(id = "nameInput")
	public WebElement nameInputField;
	
	@FindBy(id ="personalPhoneInput")
	public WebElement phoneInputField;
	
	@FindBy(id ="personalUpdateBtn")
	public WebElement updateBttn;
	
	@FindBy(xpath = "//div[text()='Personal Information Updated Successfully']")
	public WebElement updateConfirmMsg; 
	
	@FindBy(xpath = "//p[text()='Add a payment method']")
	public WebElement addPaymentBttn;
	
	@FindBy(id = "cardNumberInput")
	public WebElement cardNumber;
	
	@FindBy(id ="nameOnCardInput")
	public WebElement nameOnCard;
	
	@FindBy(id = "expirationMonthInput")
	public WebElement expirationMonth;
	
	@FindBy(id = "expirationYearInput")
	public WebElement expirationYear;
	
	@FindBy (id ="securityCodeInput")
	public WebElement securityCode;
	
	@FindBy(id ="paymentSubmitBtn")
	public WebElement addCardBttn;
	
	@FindBy(xpath ="//div[text()='Payment Method added sucessfully']")
	public WebElement cardVerifyUpdateMsg;
	
	@FindBy(xpath = "//div[@class='account__payment-sub']")
	public WebElement selectMasterCard;
	
	@FindBy(xpath ="//button[text()='Edit']")
	public WebElement editCardBttn;
	
	@FindBy(xpath ="//div[text()='Payment Method updated Successfully']")
	public WebElement paymentInfoUpdate;
	
	@FindBy(xpath = "//button[text()='remove']")
	public WebElement removePCard;
	
	@FindBy(xpath ="//p[text()='Add Address']")
	public WebElement addAddressBttn;
	
	@FindBy (id = "countryDropdown")
	public WebElement countrySelect;
	
	@FindBy (id = "fullNameInput")
	public WebElement addressFieldName;
	
	@FindBy (id = "phoneNumberInput")
	public WebElement addressPhoneField;
	
	@FindBy (id = "streetInput")
	public WebElement streetField;
	
	@FindBy (id = "apartmentInput")
	public WebElement apartmentField;
	
	@FindBy (id = "cityInput")
	public WebElement cityField;
	
	@FindBy (xpath = "//select[@name='state']")
	public WebElement stateField;
	
	@FindBy (id = "zipCodeInput")
	public WebElement zipCodeField;
	
	@FindBy (id = "addressBtn")
	public WebElement addYourAddressBttn;
	
	@FindBy(xpath = "//div[text()='Address Added Successfully']")
	public WebElement addressAddMsg;
	
	@FindBy(xpath ="(//button[text()='Edit'])[1]")
	public WebElement editAddressBttn;
	
	@FindBy(xpath = "//button[text()='Update Your Address']")
	public WebElement updateYourAddressBttn;
	
	@FindBy(xpath ="//div[text()='Address Updated Successfully']")
	public WebElement updateYourAddressMsg;
	
	@FindBy(xpath = "(//button[text()='Remove'])[2]")
	public WebElement removeAddressBttn;
	
	@FindBy(xpath ="(//div[@class='account__address-single'])[1]")
	public WebElement addressremovedIcon;
	
	
}
