package com.ibm.dev;

import java.net.InetAddress;
import java.net.UnknownHostException;

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