# Simple Java Web application

This is a sample application that was taken from Venkatasamy's [RetailWebApp](https://github.com/Venkatasamy/RetailWebApp.git) that had a functional front end and existing tests with a mostly operational pom file for maven.

It was trimmed down to just the basics in support our needs for build, test, and install.

To run this locally for test and evaluation you must already have the installed dependencies

* Maven: version 5.4+
* JDK: version 11+
  
Once the dependencies are installed, you can leverage the Tomcat server by issuing

```bash
mvn tomcat7:run
```

from the root directory containing this ReadMe file.

This will download the required dependencies, compile the source code, and host the web application [retailone](http://localhost:8026/retailone) on your local machine.

This will display the login page in your local browser.  Please note, as this uses jsp, you may need to trust the scripts on the page if you are running an Ad blocker or Noscript plugin.

Default login credentials are:

* Username - Demo
* Password - password=1

Once you log in, you will see a search window.  Type Camera in the text field and click search to see the results.  There is a some additional items to play with if you are interested in but that is about it.
