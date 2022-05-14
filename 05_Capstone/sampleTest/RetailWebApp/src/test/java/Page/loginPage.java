package Page;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class loginPage {
	
	private By uname = By.name("username");
	private By password = By.name("password");
	private By signinbtn = By.xpath("//tr[4]/td[2]/input");
	
	private WebDriver driver;
	
	public loginPage(WebDriver driver)
	{
		this.driver = driver;
		System.out.println("**Inside loginPage"+driver.getCurrentUrl()+driver.getTitle());
		if ( !driver.getTitle().equals("Retail Application Demo"))
		{
			throw new IllegalStateException("This is not sign in page, current page is: "
                    +driver.getCurrentUrl());
		}
	}
	
	public homePage validLogin()
	{
		driver.findElement(uname).sendKeys("Demo");
		driver.findElement(password).sendKeys("password=1");
		driver.findElement(signinbtn).click();
		return new homePage(driver);
		
		
	}

}
