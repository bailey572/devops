package Controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.InetSocketAddress;
import java.net.MalformedURLException;
import java.net.Proxy;
import java.net.URL;

import org.apache.log4j.Logger;

public class ApacheHttpClient {
	
	private static Logger logger = Logger.getLogger("retailone");
	
	public void getHotels(String requestid)
	{
		try {
			logger.info("Getting into getHotels()");
			//Proxy proxy = new Proxy(Proxy.Type.HTTP, new InetSocketAddress("10.237.69.156", 6050));
			URL url = new URL("http://retailrestapi.cogpcfdevops.com/example/v1/hotels?");
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			conn.setRequestProperty("Accept", "application/json");
			conn.setRequestProperty("Content-Type", "application/json");
			conn.setRequestProperty("retailapprequestid", requestid);

			if (conn.getResponseCode() != 200) {
				throw new RuntimeException("Failed : HTTP error code : "
						+ conn.getResponseCode());
			}

			BufferedReader br = new BufferedReader(new InputStreamReader(
				(conn.getInputStream())));

			String output;
			System.out.println("Output from Server .... \n");
			while ((output = br.readLine()) != null) {
				System.out.println(output);
				logger.info("List of hotels returned" + output.toString());
			}
			logger.info("Exiting getHotels()");
			conn.disconnect();

		  } catch (MalformedURLException e) {

			e.printStackTrace();

		  } catch (IOException e) {

			e.printStackTrace();

		  }
	}
	
	public void createHotels()
	{
		try {
			//Proxy proxy = new Proxy(Proxy.Type.HTTP, new InetSocketAddress("10.237.69.156", 6050));
			URL url = new URL("http://retailrestapi.cogpcfdevops.com/example/v1/hotels");
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setDoOutput(true);
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Content-Type", "application/json");
			conn.setRequestProperty("Content-Type", "application/json");

			String input = "{\"name\" : \"La Palace\",\"description\" : \"Very basic, small rooms but clean\",\"city\" : \"NY\",\"rating\" : 2}";

			OutputStream os = conn.getOutputStream();
			os.write(input.getBytes());
			os.flush();

			if (conn.getResponseCode() != HttpURLConnection.HTTP_CREATED) {
				throw new RuntimeException("Failed : HTTP error code : "
					+ conn.getResponseCode());
			}

			BufferedReader br = new BufferedReader(new InputStreamReader(
					(conn.getInputStream())));

			String output;
			System.out.println("Output from Server .... \n");
			while ((output = br.readLine()) != null) {
				System.out.println(output);
			}

			conn.disconnect();

		  } catch (MalformedURLException e) {

			e.printStackTrace();

		  } catch (IOException e) {

			e.printStackTrace();

		 }		

	}
	
//	public static void main(String[] args) {
//		
//		ApacheHttpClient obj = new ApacheHttpClient();
//		obj.createHotels();
//		obj.getHotels();
//
//		  
//
//		}

	}
