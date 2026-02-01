package tek.capstone.guardians.pages;

import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import tek.capstone.guardians.base.BaseSetup;

public class RetailSignInPage extends BaseSetup{
	
	public RetailSignInPage() {
		
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
	
	@FindBy (xpath = "//a[text()='TEKSCHOOL']")
	public WebElement retailLogo;
	
	@FindBy(id = "logoutBtn")
	public WebElement logOutBttnVeiw;
	
	@FindBy(id ="newAccountBtn")
	public WebElement createNewAccountBttn;
	
	@FindBy(id = "nameInput")
	public WebElement nameInputField;
	
	@FindBy(id = "emailInput")
	public WebElement emailInputField;
	
	@FindBy(id = "passwordInput")
	public WebElement passwordInputField;
	
	@FindBy(id= "confirmPasswordInput")
	public WebElement confirmPasswordField;
	
	@FindBy(id ="signupBtn")
	public WebElement signUpBttn;
	
}