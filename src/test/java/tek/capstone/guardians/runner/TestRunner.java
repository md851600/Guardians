package tek.capstone.guardians.runner;


import org.junit.runner.RunWith;
import static io.cucumber.junit.CucumberOptions.SnippetType.CAMELCASE;
import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;

@RunWith(Cucumber.class)
@CucumberOptions(
		tags = "@Regression",
		features = ("classpath:features"),
		glue = "tek.capstone.guardians",
		dryRun = false,
		plugin = {
				"pretty",
                "html:target/htmlReports/cucumber-pretty.html",
                "json:target/jsonReports/cucumber.json"
		},
		snippets = CAMELCASE,
		monochrome = true
		
		)

public class TestRunner {

}
