package tek.capstone.guardians.pages;

import tek.capstone.guardians.base.BaseSetup;

public class POMFactory extends BaseSetup {
	private RetailHomePage homePage;
	private RetailSignInPage signInPage;
	private RetailAccountPage retailAccount;
	private RetailOrderPage orderPage;

	public POMFactory() {
		this.homePage = new RetailHomePage();
		this.signInPage = new RetailSignInPage();
		this.retailAccount= new RetailAccountPage();
		this.orderPage= new RetailOrderPage();
	}

	public RetailHomePage homePage() {
		return this.homePage;
	}
	
	public RetailSignInPage signInPage() {
		return this.signInPage;
	}
	
	public RetailAccountPage retailAccount() {
		return this.retailAccount;
	}
	
	public RetailOrderPage orderPage() {
		return this.orderPage;
	}

}
