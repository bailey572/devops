package Page;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class resultsPage {
	
	private By sonycamera = By.name("sony");
	private By checkoutbtn = By.xpath("//form/input");
	
	
	
	private WebDriver driver;
	
	public resultsPage(WebDriver driver)
	{
		this.driver = driver;
		System.out.println("**Inside resultsPage"+driver.getCurrentUrl()+driver.getTitle());
		if ( !driver.getTitle().equals("Fill your cart"))
		{
			throw new IllegalStateException("This is not sign in page, current page is: "
                    +driver.getCurrentUrl());
		}
	}
	
	public cartPage validCheckout()
	{
		driver.findElement(sonycamera).click();
		driver.findElement(checkoutbtn).click();
		return new cartPage(driver);
		
		
	}

}
