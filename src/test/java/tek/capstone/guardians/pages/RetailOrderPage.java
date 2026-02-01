package tek.capstone.guardians.pages;

import java.util.List;

import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import tek.capstone.guardians.base.BaseSetup;

public class RetailOrderPage extends BaseSetup {

	public RetailOrderPage() {

		PageFactory.initElements(getDriver(), this);

	}
	
	@FindBy(xpath = "//select[@id='search']")
	public WebElement AllDepartment;
	
	@FindBy(id ="searchInput")
	public WebElement searchInput;
	
	@FindBy(id ="searchBtn")
	public WebElement searchBttn;
	
	@FindBy(xpath = "//p[text()='Kasa Outdoor Smart Plug']")
	public WebElement KasaOutdoorSmartPlug;
	
	@FindBy(xpath ="//select[@class='product__select']")
	public WebElement quantitySelect;
	
	@FindBy(id ="addToCartBtn")
	public WebElement addToCartBttn;
	
	@FindBy(xpath = "//p[text()='Apex Legends - 1,000 Apex Coins']")
	public WebElement apexLegends;
	
	@FindBy(xpath ="//p[text()='Cart ']")
	public WebElement cartButton;
	
	@FindBy(id ="proceedBtn")
	public WebElement proceedToCheckout;
	
	@FindBy(id = "placeOrderBtn")
	public WebElement placeOrderBttn;
	
	@FindBy(xpath = "//p[text()='Order Placed, Thanks']")
	public WebElement orderPlacedMsg;
	
	@FindBy(linkText = "Orders")
	public WebElement ordersBttn;
	
	@FindBy(xpath ="//div[@class='order']//descendant::p[7]")
	public List <WebElement> ordersList;
	
	@FindBy(xpath = "//button[text()='Cancel The Order']")
	public List <WebElement> cancelBttn;
	
	@FindBy(id ="reasonInput")
	public WebElement cancelReason;
	
	@FindBy(xpath ="//button[text()='Cancel']")
	public WebElement cancelOrderbttn;
	
	@FindBy(xpath ="//p[text()='Your Order Has Been Cancelled']")
	public WebElement orderCancelMsg;
	
	@FindBy(xpath ="//button[text()='Return Items']")
	public List<WebElement> returnItemsList;
	
	@FindBy (xpath= "(//input[@type='checkbox'])[1]")
	public WebElement selectReturnItem;
	
	@FindBy(id ="dropOffInput")
	public WebElement returnShipOption;
	
	@FindBy(id ="orderSubmitBtn")
	public WebElement returnOrderBttn;
	
	@FindBy(xpath = "//p[text()='Return was successfull']")
	public WebElement returnSuccessMsg;
	
	@FindBy(xpath ="//button[text()='Review']")
	public List <WebElement> reviewButtonList;
	
	@FindBy(id ="headlineInput")
	public WebElement reviewHeadline;
	
	@FindBy(id ="descriptionInput")
	public WebElement reviewText;
	
	@FindBy(id ="reviewSubmitBtn")
	public WebElement addReviewBttn;

	@FindBy(xpath = "//div[text()='Your review was added successfully']")
	public WebElement reviewSuccessMSg;
	
	
	
	
	
	
	
}
