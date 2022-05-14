package Page;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class orderReportPage {
	
	private By logout = By.linkText("LogOut");
	private By orderno = By.xpath("/html/body/form/font[2]/table/tbody/tr[1]/td[2]/label");
	
	private WebDriver driver;
	
	public orderReportPage(WebDriver driver)
	{
		this.driver = driver;
		if ( !driver.getTitle().equals("Order Confirmation"))
		{
			throw new IllegalStateException("This is not sign in page, current page is: "
                    +driver.getCurrentUrl());
		}
	}
	
	public String orderConfirmation()
	{
		return driver.findElement(orderno).getText();
		
		
	}
	public loginPage logout()
	{
		driver.findElement(logout).click();
		return new loginPage(driver);
		
		
	}

}
