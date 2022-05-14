package Page;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class shippingDetailsPage {
	
	private By name = By.name("fname");
	private By zip = By.name("zip");
	private By same = By.name("same");
	private By continuebtn = By.xpath("//input[2]");
	
	
	
	private WebDriver driver;
	
	public shippingDetailsPage(WebDriver driver)
	{
		this.driver = driver;
		if ( !driver.getTitle().equals("Secure Payment Gateway"))
		{
			throw new IllegalStateException("This is not sign in page, current page is: "
                    +driver.getCurrentUrl());
		}
	}
	
	public confirmPage fillAddress()
	{
		driver.findElement(name).sendKeys("Karthik");
		driver.findElement(zip).sendKeys("600062");
		driver.findElement(same).click();
		driver.findElement(continuebtn).click();
		return new confirmPage(driver);
		
		
	}

}
