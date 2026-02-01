package tek.capstone.guardians.pages;

import java.util.List;

import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import tek.capstone.guardians.base.BaseSetup;

public class RetailHomePage extends BaseSetup {

	public RetailHomePage() {
		PageFactory.initElements(getDriver(), this);
	}

	@FindBy(xpath = "//button[@id='hamburgerBtn']")
	public WebElement clickAllOption;

	@FindBy(xpath = "//div[@class='sidebar__content']//span")
	public List<WebElement> shopByDepartment;
	
	@FindBy(xpath = "//div[@class='sidebar_content-item']//span")
	public List<WebElement> sideBarOptoins;

}
