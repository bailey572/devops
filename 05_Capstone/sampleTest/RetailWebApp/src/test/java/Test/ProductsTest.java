package Test;

import static org.junit.Assert.assertEquals;

import java.util.ArrayList;

import org.testng.annotations.AfterTest;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.Test;

import Model.Products;

public class ProductsTest {
	
	ArrayList<String> cam = new ArrayList<String>();
	ArrayList<String> mobile = new ArrayList<String>();
	ArrayList<String> laptop = new ArrayList<String>();
	
	@BeforeTest
public void setUp() throws Exception {	
		
		cam.add("Sony Cybershot");
		cam.add("Nikon");
		cam.add("Canon");
		cam.add("Kodak");
		
		mobile.add("Google Nexus One");
		mobile.add("Sony Ericcson");
		mobile.add("Apple iPhone");
		mobile.add("Micromax");
		mobile.add("Samsung");
		
		laptop.add("Dell");		
		laptop.add("Sony Vaio");
		laptop.add("HP Compaq");
		laptop.add("Samsung");
		
	}
	
	@AfterTest
	public void tearDown() throws Exception {
		cam.clear();
	}

	
	
	@Test
	public void testresultsForCamera() {
		ArrayList<String> camera = new ArrayList<String>();
		Products objProdcusts = new Products();
		camera = objProdcusts.results("camera");		
		assertEquals(cam, camera);		
	}
	
	@Test
	public void testresultsForMobile() {
		ArrayList<String> actMobile = new ArrayList<String>();
		Products objProdcusts = new Products();
		actMobile = objProdcusts.results("mobile");		
		assertEquals(mobile, actMobile);		
	}
	
	@Test
	public void testresultsForLaptop() {
		ArrayList<String> actLaptop = new ArrayList<String>();
		Products objProdcusts = new Products();
		actLaptop = objProdcusts.results("laptop");		
		assertEquals(laptop, actLaptop);		
	}
}
