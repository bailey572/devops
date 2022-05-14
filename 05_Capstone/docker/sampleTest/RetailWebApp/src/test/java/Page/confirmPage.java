package Page;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class confirmPage {
	
	
	private By confirmbtn = By.xpath("//input[3]");
			
	
	
	private WebDriver driver;
	
	public confirmPage(WebDriver driver)
	{
		this.driver = driver;
		if ( !driver.getTitle().equals("Check Out Page 2"))
		{
			throw new IllegalStateException("This is not sign in page, current page is: "
                    +driver.getCurrentUrl());
		}
	}
	
	public paymentsgatewayPage confirmOrder()
	{
		driver.findElement(confirmbtn).click();
		return new paymentsgatewayPage(driver);
		
		
	}

}
