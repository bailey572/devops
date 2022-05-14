package Page;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class cartPage {
	
	private By qty = By.xpath("//td[3]/input");
	private By checkoutbtn = By.xpath("//input[2]");
	
	
	
	private WebDriver driver;
	
	public cartPage(WebDriver driver)
	{
		this.driver = driver;
		if ( !driver.getTitle().trim().equals("Your Cart"))
		{
			throw new IllegalStateException("This is not sign in page, current page is: "
                    +driver.getCurrentUrl());
		}
	}
	
	public shippingDetailsPage proceedToCheckout()
	{
		driver.findElement(qty).sendKeys("1");;
		driver.findElement(checkoutbtn).click();
		return new shippingDetailsPage(driver);
		
		
	}

}
