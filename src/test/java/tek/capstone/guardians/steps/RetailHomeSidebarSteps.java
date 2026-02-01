package tek.capstone.guardians.steps;

import java.util.List;

import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import tek.capstone.guardians.pages.POMFactory;
import tek.capstone.guardians.utilities.CommonUtility;

public class RetailHomeSidebarSteps extends CommonUtility {

	private POMFactory pomFactory = new POMFactory();

	@When("User click on All section")
	public void userClickOnAllSection() {
		click(pomFactory.homePage().clickAllOption);
	}

	@Then("below options are present in Shop by Department sidebar")
	public void belowOptionsArePresentInShopByDepartmentSidebar(io.cucumber.datatable.DataTable dataTable) {

		List<List<String>> shopByDepartments = dataTable.asLists(String.class);
		for (int i = 0; i < shopByDepartments.get(0).size(); i++) {
			Assert.assertTrue(isElementDisplayed(
					getDriver().findElement(By.xpath("//div[@class='sidebar_content-item']//span"))));
			logger.info("Option" + shopByDepartments.get(0).get(i) + " is Displayed");
		}

	}
	
	@When("user on {string}")
	public void userOn(String department) {
	   List<WebElement> allDepartment = pomFactory.homePage().shopByDepartment;
	   for(int i =0; i< allDepartment.size(); i++) {
		   if(allDepartment.get(i).getText().equalsIgnoreCase(department)) {
			   allDepartment.get(i).click();
			   break;
		   }
	   }
	}
	@Then("below options are present in department")
	public void belowOptionsArePresentInDepartment(io.cucumber.datatable.DataTable dataTable) {
		List <List<String>> departmentOptions = dataTable.asLists(String.class);
		List<WebElement> options = pomFactory.homePage().sideBarOptoins; 
		for(int i =0; i< departmentOptions.get(0).size(); i++) {
			for(WebElement element : options) {
				if(element.getText().equalsIgnoreCase(departmentOptions.get(0).get(i))) {
					
					Assert.assertTrue(element.isDisplayed());
					logger.info("The option " + element.getText()+ " is present");
				}
			}
		}
		
		
	}


}
