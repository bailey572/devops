package test;
import org.testng.annotations.Test;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.testng.Assert;
import org.testng.annotations.AfterTest;
import org.testng.annotations.BeforeTest;

public class TestNg {
	public String baseUrl = "https://www.google.com/";
	String driverPath = "//home//ericbailey//Downloads//Selenium//chromedriver96";
	public WebDriver driver ;
	@BeforeTest
	public void launchBrowser() {
	System.out.println("launching Chrome browser");
	System.setProperty("webdriver.chrome.driver", driverPath);
	driver = new ChromeDriver();
	driver.get(baseUrl);
	}
	@Test
	public void verifyHomepageTitle() {
	String expectedTitle = "Google";
	String actualTitle = driver.getTitle();
	Assert.assertEquals(actualTitle, expectedTitle);
	}
	@AfterTest
	public void terminateBrowser(){
	driver.close();
	}
}

