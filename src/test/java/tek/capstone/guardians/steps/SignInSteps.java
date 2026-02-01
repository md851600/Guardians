package tek.capstone.guardians.steps;

import java.util.List;
import java.util.Map;

import org.junit.Assert;

import io.cucumber.java.en.*;
import tek.capstone.guardians.pages.POMFactory;
import tek.capstone.guardians.utilities.CommonUtility;
import tek.capstone.guardians.utilities.DataGenerator;

public class SignInSteps extends CommonUtility {

	private POMFactory pomFactory = new POMFactory();

	//Login to retail 
	
	@Given("User is on retail website")
	public void userIsOnRetailWebsite() {
		Assert.assertTrue(pomFactory.signInPage().retailLogo.isDisplayed());
		logger.info("user is on tek retail website successfully");

	}

	@When("User click on Sign in option")
	public void userClickOnSignInOption() {
		click(pomFactory.signInPage().signInOption);

	}

	@When("User enter email {string} and password {string}")
	public void userEnterEmailAndPassword(String email, String password) {
		sendText(pomFactory.signInPage().emailField, email);
		sendText(pomFactory.signInPage().passwordField, password);
		logger.info("user enter email and password successfully");
	}

	@When("User click on login button")
	public void userClickOnLoginButton() {
		click(pomFactory.signInPage().loginBttn);
	}

	@Then("User should be logged in into Account")
	public void userShouldBeLoggedInIntoAccount() {
		Assert.assertTrue(pomFactory.signInPage().logOutBttnVeiw.isDisplayed());
		logger.info("user is logged in successfully");
	}

	// Register

	@When("User click on Create New Account button")
	public void userClickOnCreateNewAccountButton() {
		click(pomFactory.signInPage().createNewAccountBttn);
		logger.info("user clicked on sign up button successfully");

	}

	@When("User fill the signUp information with below data")
	public void userFillTheSignUpInformationWithBelowData(io.cucumber.datatable.DataTable dataTable) {

		List<Map<String, String>> info = dataTable.asMaps(String.class, String.class);
		sendText(pomFactory.signInPage().nameInputField, DataGenerator.addressGenerator(info.get(0).get("name")));
		sendText(pomFactory.signInPage().emailInputField, DataGenerator.addressGenerator(info.get(0).get("email")));
		sendText(pomFactory.signInPage().passwordInputField, info.get(0).get("password"));
		sendText(pomFactory.signInPage().confirmPasswordField, info.get(0).get("confirmPassword"));
		logger.info("User information entered successfully");

	}

	@When("User click on SignUp button")
	public void userClickOnSignUpButton() {
		click(pomFactory.signInPage().signUpBttn);
		logger.info("user clicked on sign up button successfully");
	}

	@Then("User should be logged into account page")
	public void userShouldBeLoggedIntoAccountPage() {
		Assert.assertTrue(pomFactory.signInPage().logOutBttnVeiw.isDisplayed());
		logger.info("user is logget in successfully");
	}

}
