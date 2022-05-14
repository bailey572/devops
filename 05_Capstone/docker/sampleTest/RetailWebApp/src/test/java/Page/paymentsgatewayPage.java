package Page;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class paymentsgatewayPage {
	
	private By card = By.xpath("/html/body/form/font/table[2]/tbody/tr[2]/td[2]/input");
	private By pay = By.xpath("/html/body/form/font/table[2]/tbody/tr[4]/td/input");
	
	
	
	private WebDriver driver;
	
	public paymentsgatewayPage(WebDriver driver)
	{
		this.driver = driver;
		if ( !driver.getTitle().equals("Payment Mode"))
		{
			throw new IllegalStateException("This is not sign in page, current page is: "
                    +driver.getCurrentUrl());
		}
	}
	
	public orderReportPage makePayments()
	{
		driver.findElement(card).sendKeys("1111");;
		driver.findElement(pay).click();
		return new orderReportPage(driver);
		
		
	}

}
