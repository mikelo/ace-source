package com.ibm.dev;

import java.net.InetAddress;
import java.net.UnknownHostException;

//import com.ibm.broker.plugin.MbException;
//import com.ibm.broker.plugin.MbJavaException;
//import com.ibm.broker.plugin.MbUserException;

class MyClass {

public static String myHostnameMethod() { 
	String hostname = "";
	try {
		hostname = InetAddress.getLocalHost().getHostName();

	} catch (UnknownHostException e) {
		e.printStackTrace();
	}
	return hostname;
	}

public static String myAddressMethod() { 
	InetAddress address;

	try {
		// Intentionally using an invalid hostname
		
		address = InetAddress.getByName("this.will.never.resolve.invalid");
		if (address.getHostAddress().matches("127.0.0.1"))
			throw new RuntimeException (MyClass.class.getName(), new UnknownHostException());
//		throw new MbJavaException(new Throwable("test"));
//		throw new UnknownHostException();
		
	} catch (UnknownHostException e) {
		System.err.println("Exception caught: " + e.getMessage());
		throw new RuntimeException (MyClass.class.getName(), new Throwable("test"));

		 // Wrap and throw as MbUserException
//		 throw new Exception (MyClass.class.getName(), e);

	}
	return address.getHostAddress();
	}

public static String systemProperties() { 

    String osName = System.getProperty("os.name");
    String osVersion = System.getProperty("os.version");
    String osArch = System.getProperty("os.arch");
    String javaVersion = System.getProperty("java.version");

    // Handle null values
    osName = (osName != null) ? osName : "Not Available";
    osVersion = (osVersion != null) ? osVersion : "Not Available";
    osArch = (osArch != null) ? osArch : "Not Available";
    javaVersion = (javaVersion != null) ? javaVersion : "Not Available";

    // Print all four properties in one line
    return        String.format(
            "Operating System: %s, Version: %s, Architecture: %s, Java Version: %s",
            osName, osVersion, osArch, javaVersion
        );
    
}
}