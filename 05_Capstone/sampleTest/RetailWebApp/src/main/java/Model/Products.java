package Model;

import java.util.*;

public class Products {
	ArrayList<String> cam = new ArrayList<String>();
	ArrayList<String> mob = new ArrayList<String>();
	ArrayList<String> lap = new ArrayList<String>();
	
	public Products()
	{
		cam.add("Sony Cybershot");		
		cam.add("Nikon");
		cam.add("Canon");
		cam.add("Kodak");
		
		mob.add("Google Nexus One");
		mob.add("Sony Ericcson");
		mob.add("Apple iPhone");
		mob.add("Micromax");
		mob.add("Samsung");
		
		lap.add("Dell");
		
		
		lap.add("Sony Vaio");
		lap.add("HP Compaq");
		lap.add("Samsung");
	}
	public ArrayList<String> results(String str)
	{
		if(str.equals("camera") || str.equals("Camera"))
			return cam;
		if(str.equals("mobile") || str.equals("Mobile"))
			return mob;
		if(str.equals("laptop") || str.equals("Laptop"))
			return lap;
		return null;
		
	}
}
