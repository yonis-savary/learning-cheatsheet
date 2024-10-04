<p align="center">
<img src="https://brandslogos.com/wp-content/uploads/thumbs/java-logo-vector-1.svg" width="200">
</p>

# Java / Java Webdev Cheatsheet

## Resources

- [Main Resource: CodeAcademy](https://www.codecademy.com/resources/docs/java)


## Index
- [Java / Java Webdev Cheatsheet](#java---java-webdev-cheatsheet)
  - [Resources](#resources)
  - [Index](#index)
  - [IDE And tools](#ide-and-tools)
  - [Structure](#structure)
    - [Projet structure](#projet-structure)
    - [Naming conventions](#naming-conventions)
    - [Namespaces](#namespaces)
    - [Include files](#include-files)
    - [Download a library](#download-a-library)
  - [Basics](#basics)
    - [Basic data types](#basic-data-types)
    - [Usefull string methods](#usefull-string-methods)
  - [I/O](#i-o)
    - [Display in console](#display-in-console)
    - [Read line in console](#read-line-in-console)
    - [Parse CLI Arguments/Options](#parse-cli-arguments-options)
  - [Control structures](#control-structures)
    - [Conditions](#conditions)
    - [Loops](#loops)
    - [Error Handling](#error-handling)
  - [Data manipulation](#data-manipulation)
    - [File write / read](#file-write---read)
    - [JSON](#json)
    - [Working with paths](#working-with-paths)
    - [Working with dates](#working-with-dates)
    - [Conversion & Utilities](#conversion---utilities)
    - [Capture regex matches](#capture-regex-matches)
  - [Functions](#functions)
    - [Lambda Expression](#lambda-expression)
    - [Array List](#array-list)
  - [OOP](#oop)
    - [Classes](#classes)
    - [Inheritance](#inheritance)
    - [Interface](#interface)
  - [Async programming](#async-programming)
    - [Threading](#threading)
  - [Database](#database)
    - [Connect to MySQL Database](#connect-to-mysql-database)
  - [Testing](#testing)
    - [Unit Testing](#unit-testing)
      - [JUnit Platform](#junit-platform)
      - [JUnit Jupiter](#junit-jupiter)
      - [JUnit Vintage](#junit-vintage)
      - [Launch Tests](#launch-tests)
  - [Web](#web)
    - [Web framework Frameworks](#web-framework-frameworks)

## IDE And tools

IDEs
- IntelliJ IDEA
- Eclipse
- NetBeans
- Visual Studio Code

Build Systems:
- Maven (Preferred)
- Gradle

Apparently, Maven is more simple and more structured, although Gradle can be used with some technologies like Android

## Structure
### Projet structure

From [digma.ai](https://digma.ai/clean-code-java/) : Although Java doesn’t enforce a specific project structure, build tools such as Maven suggests a project structure you can follow.

```text
src
    ├── main
    │   ├── java                   Application/Library sources
    │   ├── resources              Application/Library resources
    │   ├── filters                Resource filter files
    │   └── webapp                 Web application sources
    │
    └── test
        ├── java                   Test sources
        ├── resources              Test resources
        └── filters                Test resource filter files
```

<center>
<img src="https://lh6.googleusercontent.com/proxy/LGdshpR3OMki6F1ixTw5Zewx3y3MOz7TkIYzjl45jlVgSKLipIncmwce0ZQbRTOmY190YRIqLYXDPqXkINqOZ9eXjrV02zqCdzYMQ6xXoDeWOWi58AzH" width="200">
</center>

### Naming conventions

- CamelCase for Class and interface names
- Method names should be verbs.
- Variable names should be short and meaningful.
- Package names should be lowercase.
- Constant names should be CAPITALIZED.


### Namespaces

[Source](https://bito.ai/resources/java-namespace-example-java-explained/)


In Java, namespaces are declared using the package keyword. For example, if you wanted to create a namespace called “example”, you would use the following code:

```java
package com.mycompany.myproject;
```

Using a class is done through the `import` keyword
```java
import com.mycompany.myproject.MainClass;
```

### Include files

[Source](https://stackoverflow.com/a/7737841)

You don't `#include` in Java; you `import package.Class`. Since Java 6 (or was it 5?), you can also `import static package.Class.staticMethodOfClass`, which would achieve some forms of what you're trying to do.

Also, as @duffymo noted, `import` only saves you from systematically prefixing the imported class names with the package name, or the imported static method names with the package and class name. The actual `#include` semantics doesn't exist in Java - at all.

That said, having a "funcs.java" file seems to me like you are starting to dip your toes into some anti-patterns... And you should stay away from these.


### Download a library

[Source](https://www.quora.com/How-do-you-find-and-install-a-Java-library)

They are two ways to achieve that goal in Java

1. Use it in a build system like Maven or Gradle :
> To find and install a Java library, you can search for it on websites like Maven Central or JCenter. Once you find the library you need, add its details to your project's build file, like the "pom.xml" in Maven or "build.gradle" in Gradle. Then, when you build your project, the build tool will download and include the library in your project automatically. This way, you can easily access and use the functions provided by the Java library in your code.

2. Manually download it and import it in the project:
> To find and install a Java library follow these steps:
> - Search for the library you want using an online search engine.
> - Download the Java library from the website you find it on.
> - Unzip the downloaded library into a folder.
> - Include the library in your project's classpath.
> - Import the library into your project. 6. Initialize and use the library in your code.


3. Install a Library through Maven ([Source](https://stackoverflow.com/a/4955695))

Install the JAR into your local Maven repository (typically .m2 in your home folder) as follows:

```bash
mvn install:install-file \
   -Dfile=<path-to-file> \
   -DgroupId=<group-id> \
   -DartifactId=<artifact-id> \
   -Dversion=<version> \
   -Dpackaging=<packaging> \
   -DgeneratePom=true
```
Where each refers to:

- `<path-to-file>`: the path to the file to load e.g → c:\kaptcha-2.3.jar
- `<group-id>`: the group that the file should be registered under e.g → com.google.code
- `<artifact-id>`: the artifact name for the file e.g → kaptcha
- `<version>`: the version of the file e.g → 2.3
- `<packaging>`: the packaging of the file e.g. → jar

Reference
    - Maven FAQ: [I have a jar that I want to put into my local repository. How can I copy it in?](http://maven.apache.org/general.html#importing-jars)
    - Maven Install Plugin Usage: [The `install:install-file` goal](https://maven.apache.org/plugins/maven-install-plugin/usage.html#The_install:install-file_goal)



## Basics

### Basic data types

[Source](https://docs.oracle.com/javase/tutorial/java/nutsandbolts/datatypes.html)

Declaring a variable
```java
Type variableName = initialValue;
Type anotherVariable;

byte heightBits = 255;
bool skyIsBlue = true;

short = 1000;
char myChar = 0xFA;
int myBin = 0b1011_0111; // or 0b10110111

long myLong = 123456789123456789L; // L at the end
float myFloat = 123.4f; // f at the end
double myDouble = 123.4;

char myLetter = 'C'; // Single quote
String myWord = "Hello World !"; // Double quotes

String nullValue = null; // Null cannot be assigned to primitive data types

// Arrays !
int[] array = {1,2,3};
```

### Usefull string methods

[Source](https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/lang/String.html)

```java
// Equivalent to valueOf(char[], int, int).
static String copyValueOf​(char[] data, int offset, int count);
// Returns a formatted string using the specified format string and arguments.
static String format​(String format, Object... args);
// Returns a formatted string using the specified locale, format string, and arguments.
static String format​(Locale l, String format, Object... args);

static String join​(CharSequence delimiter, CharSequence... elements);
static String join​(CharSequence delimiter, Iterable<? extends CharSequence> elements);



// Compares two strings lexicographically, ignoring case differences.
int	compareToIgnoreCase​(String str);
// Compares this String to another String, ignoring case considerations.
boolean	equalsIgnoreCase​(String anotherString);

// Concatenates the specified string to the end of this string.
String concat​(String str);

boolean	contains​(CharSequence s);
boolean	contentEquals​(CharSequence cs);
boolean	contentEquals​(StringBuffer sb);
boolean	equals​(Object anObject);

boolean	startsWith​(String prefix);
boolean	startsWith​(String prefix, int toffset);
boolean	endsWith​(String suffix);
boolean	isBlank(); // Returns true if empty or contains only white space
boolean	isEmpty(); // Returns true if, and only if, length() is 0.


byte[] getBytes();
byte[] getBytes​(String charsetName);
byte[] getBytes​(Charset charset);
void getChars​(int srcBegin, int srcEnd, char[] dst, int dstBegin);
Stream<String> lines();

int	hashCode();
int	indexOf​(int ch);
int	indexOf​(int ch, int fromIndex);
int	indexOf​(String str);
int	indexOf​(String str, int fromIndex);

// Returns a canonical representation for the string object.
String intern();

int	lastIndexOf​(String str);
int	lastIndexOf​(String str, int fromIndex);

String repeat​(int count);
int	length();


boolean	matches​(String regex);

// Tests if two string regions are equal.
boolean	regionMatches​(boolean ignoreCase, int toffset, String other, int ooffset, int len);
boolean	regionMatches​(int toffset, String other, int ooffset, int len);

String replace​(char oldChar, char newChar); // Replace all occurences
String replace​(CharSequence target, CharSequence replacement);
String replaceAll​(String regex, String replacement);
String replaceFirst​(String regex, String replacement);

String[] split​(String regex);
String[] split​(String regex, int limit);

String	strip(); // alias of trim(), but "unicode aware"
String	stripLeading();
String	stripTrailing();
String	trim();

CharSequence subSequence​(int beginIndex, int endIndex);
String	substring​(int beginIndex);
String	substring​(int beginIndex, int endIndex);

char[] toCharArray();

String toLowerCase(?Locale locale);
String toUpperCase(?Locale locale);
```

## I/O
### Display in console

```java
System.out.print("Hello");
System.out.println("Hello");
System.out.println(123);
System.out.printf(formatstring, arg1, arg2, ... argN);
```

### Read line in console


```java
import java.util.Scanner;

Scanner myObj = new Scanner(System.in);       // 2. Create a Scanner object
System.out.println("Enter your user name");
String userName = myObj.nextLine();           // 3. Read the user input with .nextLine()
System.out.println("The username is: " + userName);
```


### Parse CLI Arguments/Options

[Source](https://stackoverflow.com/questions/367706/how-do-i-parse-command-line-arguments-in-java)

Check these out:
  - [http://commons.apache.org/cli/](http://commons.apache.org/cli/)
  - [http://www.martiansoftware.com/jsap/](http://www.martiansoftware.com/jsap/)

Or roll your own:
  - [http://docs.oracle.com/javase/7/docs/api/java/util/Scanner.html](http://docs.oracle.com/javase/7/docs/api/java/util/Scanner.html)

```java
import org.apache.commons.cli.*;

public class Main {


    public static void main(String[] args) throws Exception {

        Options options = new Options();

        Option input = new Option("i", "input", true, "input file path");
        input.setRequired(true);
        options.addOption(input);

        Option output = new Option("o", "output", true, "output file");
        output.setRequired(true);
        options.addOption(output);

        CommandLineParser parser = new DefaultParser();
        HelpFormatter formatter = new HelpFormatter();
        CommandLine cmd = null;//not a good practice, it serves it purpose

        try {
            cmd = parser.parse(options, args);
        } catch (ParseException e) {
            System.out.println(e.getMessage());
            formatter.printHelp("utility-name", options);

            System.exit(1);
        }

        String inputFilePath = cmd.getOptionValue("input");
        String outputFilePath = cmd.getOptionValue("output");

        System.out.println(inputFilePath);
        System.out.println(outputFilePath);

    }

}
```


## Control structures

[Source](https://www.codecademy.com/resources/docs/java)

### Conditions

```java
if (condition)
{}
else if (condition)
{}
else
{}

switch(expression)
{
    case A:
        break;
    case B:
    case C:
        break;
    default:
        break;
}
```

Also, variables can be assigned but not declared inside the conditional statement:

```java
int value;
if(value = someMethod())
    return true;
```


### Loops

```java
while (condition)
{}

do {}
while (condition)

for (initial; condition; increment)
{}

// Foreach !
int[] values = {1,2,3,4,5,6};
for (int value : values)
{}
```

### Error Handling
```java
try
{}
catch (SomeBadException exception)
{}
catch (SomeReallyBadException exception)
{}
catch (AnotherException | NonImportantException exception)
{}

throw new Exception("Something exploded !");

void myMethod() throws SomeException, OtherException
{}
```

## Data manipulation
### File write / read

```java
File tempFile = new File(itsPath);

tempFile.canRead(); // Is the file is readable ?
tempFile.canWrite(); // Is the file is writable ?
tempFile.createNewFile(); // Creates an empty file. Returns true if successful.
tempFile.delete(); // Deletes a file. Can delete a directory if it is empty.
tempFile.exists(); // Returns true if the file/directory exists.
tempFile.getName(); // Returns the name of the file/directory.
tempFile.getAbsolutePath(); // Returns the full pathname of the file/directory.
tempFile.isDirectory(); // Returns true if instance points to a directory.
tempFile.isFile(); // Returns true if instance points to a file.
tempFile.length(); // Returns the size of the file in bytes.
tempFile.list(); // Returns a String[] array of the files in the directory.
tempFile.mkdir(); // Creates a directory.

// Write a file
import java.io.FileWriter;
FileWriter writer = new FileWriter(filePath, boolean append);
writer.write("Hello\n");
writer.close();


import java.io.PrintWriter;
PrintWriter writer = new PrintWriter(new File(path));
writer.println("some text");
writer.printf("some text and then a number %f", 3.14);
writer.close();



// Read a file
import java.io.FileReader;
FileReader reader = new FileReader(filePath);
char nextChar = reader.read();
reader.close();


// Read a file line by line
reader = new BufferedReader(new FileReader("sample.txt"));
String line;
while (line = reader.readLine()) // String or null
    System.out.println(line);

```

### JSON

- [Source - baeldung.com](https://www.baeldung.com/java-org-json)
- [Source - innoq.com](https://www.innoq.com/en/articles/2022/02/java-json/)

The library `[org.json](https://github.com/stleary/JSON-java)` exists already since the end of 2010 and was initially implemented by Douglas Crockford, the creator of JSON. One can therefore consider it the reference implementation for JSON in Java.

1. Add dependency in `pom.xml`
```xml
<dependency>
    <groupId>org.json</groupId>
    <artifactId>json</artifactId>
    <version>20240303</version>
</dependency>
```

2. Classes and utilities

- `JSONObject`: similar to Java’s native Map-like object, which stores unordered key-value pairs
- `JSONArray`: an ordered sequence of values similar to Java’s native Vector implementation
- `JSONTokener`: a tool that breaks a piece of text into a series of tokens that can be used by JSONObject or JSONArray to parse JSON strings
- `CDL`: a tool that provides methods to convert comma delimited text into a JSONArray and vice versa
- `Cookie`: converts from JSON String to cookies and vice versa
- `HTTP`: used to convert from JSON String to HTTP headers and vice versa
- `JSONException`: a standard exception thrown by this library

3. Enconding JSON

```java
JSONObject json =
    new JSONObject()
    .put("number", 1)
    .put("object",
        new JSONObject()
        .put("string", "Hello")
    )
    .put("boolean", true)
    .put("array",
        new JSONArray()
        .put(47.11)
        .put("Hello again")
    );


json.toString(4) // tabulation
```

4. Decoding JSON

```java

JSONArray array = new JSONArray("[1,2,3]");
JSONObject json = new JSONObject(new JSONTokener("""
    {
        "number": 1,
        "object": {
            "string":"Hello"
        },
        "boolean": true,
        "array": [
            47.11,
            "Hello again"
        ]
    }
"""));

json.isEmpty();           // -> false
json.has("not-there");    // -> false
json.isNull("not-there"); // -> true
json.has("null");         // -> true
json.isNull("null");      // -> true

json.optInt("string");    // -> 5
json.getInt("string");    // -> 5
json.getString("number"); // throws Exception
json.optString("number"); // -> "1"

json.increment("number");     // -> "number": 2
json.append("array", false);  // -> "array" [2, false]
json.accumulate("string", 2); // -> "string": ["1", 2]

System.out.println(json.query("/object/string"));
```

### Working with paths

```java

import java.nio.file.Path;
import java.nio.file.Paths;

Path path = Paths.get("Foo", "Bar", "Zoo"); // Get Foo/Bar/Zoo

// To Test !
File newFile = new File(Paths.get("/home", "foo", ".bashrc"));
```

### Working with dates

```java
import java.utils.Date;

Date now = new Date();
Date anotherDate = new Date();
long timestampInMillis = now.getTime();

now.after(anotherDate) // Checks if a date occurs after a specified date.
now.before(anotherDate) // Checks if one date occurs before another.
now.clone() // Clones the specified date.
now.compareTo(anotherDate) // Compares two date objects.
// Return -1 if now is before anotherDate
// 0 if equals
// 1 if now is greater
now.equals() // Returns a boolean based on a comparison of equivalency between two dates.
now.from() // Returns an instant object of a given Date.

Calendar calendar = new Calendar();
calendar.set(Calendar.YEAR, 2017);
calendar.set(Calendar.MONTH, 0);
calendar.set(Calendar.DAY_OF_MONTH, 25);
calendar.set(Calendar.HOUR_OF_DAY, 19);
calendar.set(Calendar.MINUTE, 42);
calendar.set(Calendar.SECOND, 12);

calendar.add(); // Adds or subtracts a specified amount of time to/from the given Calendar field.
calendar.after(); // Compares whether the current instance of Calendar occurs after the time represented by the specified object.
calendar.before(); // Returns a boolean based on the whether one Calendar instance is before the other given instance.
calendar.clear(); // A method designed to reset or clear specific fields of a Calendar instance.
calendar.clone(); // Returns a copy of a Calendar object.
calendar.compareTo(); // Compares a passed Calendar object with an existing Calendar object.
calendar.complete(); // A method to fill in any empty fields of a Calendar instance.
calendar.computeFields(); // Synchronizes the time of a Calendar object with the set field values.
calendar.equals(); // Used to determine if two Calendar objects are equal.
calendar.get(); // Returns the value of the given calendar field.
calendar.getActualMaximum(); // Returns the actual maximum value for a specific calendar field, conditional on the time value of the calendar.
calendar.getActualMinimum(); // Returns the minimum value allowed for a given calendar field.
calendar.getAvailableCalendarTypes(); // A method that is used to get list of all available calendar types in Java.
calendar.getAvailableLocales(); // Returns an array of locales, which represent specific geographical or cultural regions.
calendar.getCalendarType(); // Retrieves the type or format of the calendar represented by the Calendar object, returns a string representing the calendar type.
calendar.getDisplayName(); // Returns the string representation (display name) of the calendar field value in the given style and locale. If no string representation is applicable, null is returned.
calendar.getDisplayNames(); // Returns a map containing all string representations of Calendar field values in the given style and locale.
calendar.getMinimum(); // Returns the minimum value for the given calendar field.
calendar.getTime(); // Returns the time value of the given Calendar object.
calendar.getTimeInMillis(); // Returns the time in milliseconds.
calendar.getTimeZone(); // Returns the current time-zone of a given Calendar.
calendar.getWeeksInWeekYear(); // Returns the total number of weeks in a week year.
calendar.getWeekYear(); // Returns the week year.
calendar.hashCode(); // Returns the hash code for a Calendar object.
calendar.internalGet(); // Returns the value of a given field.
calendar.isLenient(); // Returns a boolean identifying a given calendar instance as lenient or not.
calendar.isSet(); // Evaluates whether the given calendar field has a value set or not.
calendar.isWeekDateSupported(); // Determines if the current Calendar object supports week dates.
calendar.roll(); // Adds or subtracts a single unit of time from a given calendar.
calendar.setFirstDayOfWeek(); // Sets the first day of the week.
calendar.setLenient(); // Sets whether the date/time interpretation should be lenient or not.
calendar.setMinimalDaysInFirstWeek(); // Sets how many minimal days required in the first week of the year.
```

### Conversion & Utilities

```java
int x = Integer.parseInt("9");
double c = Double.parseDouble("3.14");
```

### Capture regex matches

[Source](https://www.tutorialspoint.com/javaregex/javaregex_capturing_groups.htm)

```java
String text = "This order was placed for QT3000! OK?";

Pattern pattern = Pattern.compile("(.*)(\\d+)(.*)");
Matcher matcher = pattern.matcher(text);

if (m.find())
{
    System.out.println("Found value: " + matcher.group(0) );
    System.out.println("Found value: " + matcher.group(1) );
    System.out.println("Found value: " + matcher.group(2) );
}
else
{
    System.out.println("NO MATCH");
}
```

## Functions
```java

public ReturnType myMethod(String someParameter)
{}

// For default parameter value
// See the Builder pattern

// Spread parameter
static void printMany(String ...elements) {
    // Treat as stream
    Arrays.stream(elements).forEach(System.out::println);

    // Treat as array
    for (String element: elements)
    {}
}

printMany("A", "B", "C");
printManu(new String[]{"A", "B", "C"});


/*
    Callbacks:
    Callbacks are implemented through OOP
    Example
*/
public class Test {
    public static void main(String[] args) throws  Exception {
        new Test().doWork(new Callback() { // implementing class
            @Override
            public void call() {
                System.out.println("callback called");
            }
        });
    }

    public void doWork(Callback callback) {
        System.out.println("doing work");
        callback.call();
    }

    public interface Callback {
        void call();
    }
}
```

### Lambda Expression

Lambdas are defined as :

```java
parameter -> expression
(param1, param2) -> expression
(param1, param2) -> { code block }
```

Saving a lambda

```java
Consumer<Integer> method = (n) -> { System.out.println(n); };
```



### Array List

[Source](https://www.codecademy.com/resources/docs/java/array-list)

The `ArrayList` class uses dynamic arrays that are resizable, unlike traditional fixed arrays. However, each element must still be of the same type. Elements can be added or removed at any time, making the `ArrayList` more flexible.

Some other important points about the `ArrayList` class include:

- It has the ability to contain duplicate elements.
- It maintains insertion order.
- It is non-synchronized and, therefore, not safe for multiple threading.
- It allows random access since arrays work on an index basis.
- The space/time complexity is a bit slower than a LinkedList due to the nature of adding/removing elements.


```java

import java.util.ArrayList;

ArrayList<String> arrayListOfString;

ArrayList

a.add("blabla"); // Adds an element to an ArrayList.
a.addAll(collection); // Adds a collection to an ArrayList.
a.clear(); // Removes all elements from an ArrayList.
a.clone(); // Returns a cloned version of the given ArrayList.
a.contains("bla"); // Checks if an element is present in the ArrayList or not.
a.forEach( n -> System.out.println(n)); // Performs a specified action on each element in an ArrayList.
a.get(position); // Retrieves the element present in a specified position in an ArrayList.
a.indexOf("bla"); // Returns the index of the first occurrence of a given element, or -1 if not found.
a.isEmpty(); // Checks if an ArrayList is empty.
a.iterator(); // Returns an iterator over the elements in an ArrayList.
a.listIterator(); // Iterates over the elements in an ArrayList in both directions.
a.remove("blabla"); // Removes a specified element from an ArrayList.
a.removeAll(collection); // Removes multiple elements from an ArrayList that are also contained in the specified collection.
a.removeIf( n -> n.startsWith("b")); // Removes all the elements of an ArrayList that satisfy a given predicate.
a.removeRange(0, 2); // Removes every element within a specified range.
a.replaceAll( n -> n.toUpperCase()); // (Sames as Map) Replaces each element in the ArrayList with the result of applying a specified unary operator to it.
a.retainAll( n -> !n.startWith("b")); // (Filter) Retains only the elements that are contained in the specified collection.
a.set(5, "bla"); // Replaces the element present in a specified position in an ArrayList.
a.size(); // Returns the number of elements in the ArrayList.
a.sort(); // Used to sort arrays of primitive types and objects.
a.spliterator(); // Returns a Spliterator over the elements in ArrayList.
a.subList(); // Returns a view of a portion of the list based on the specified start and end indices.
a.toArray(); // Converts an ArrayList into an array.
a.trimToSize(); // Adjusts the capacity of the ArrayList to be the same as its size.

```

## OOP

[Source](https://www.codecademy.com/resources/docs/java/interfaces)

### Classes

```java
accessModifier class ClassName {
  dataType attributeOne;
  dataType attributeTwo;
  dataType attributeN;

  accessModifier void classMethod {
    // Method code here
  }
}


// Anonymous class (example with a thread class)
new Runnable() {
    @Override public void run() {
        ...
    }
}

```

### Inheritance

```java
public class Child extends Parent {
  // Class body
}
```
To overide a parent method, simply put `@Override` before the method declaration
```java
public class Child extends Parent {
  @Override public void speak()
  {

  }
}
```

### Interface

```java
interface InterfaceName {
  String constantVariable = "value";

  int abstractMethod();

  static void staticMethod() {
    // Method body
  }

  default void defaultMethod() {
    // Method body
  }
}

class MyClass implements InterfaceName, AnotherInterface
{

}
```

The following items are allowed in an interface definition:

- Constant variables: These are `public`, `static`, and `final` by definition.
- Abstract methods: These must be overridden by the class implementing the interface.
- Static methods: These are not overridden but accessed like any class static method.
- Default methods: These may be overridden, but if not, the definition in the interface is used.

Note: No interface method can be `protected` or `final`.


## Async programming

### Threading

1. Implement through the `Thread` class

```java
public class Main extends Thread {
  public void run() {
    System.out.println("This code is running in a thread");
  }
}
```

2. OR Implement through the `Runnable` interface

```java
public class Main implements Runnable {
  public void run() {
    System.out.println("This code is running in a thread");
  }
}
```


Methods

```java
MyThreadClass thread = new MyThreadClass();

thread.start() // Launch the thread
thread.sleep() // Pause the thread

Thread.sleep(1000) // Sleep for a second

thread.join() // Wait for a thread to finish
```


## Database

### Connect to MySQL Database

[Source](https://waytolearnx.com/2020/05/connexion-a-une-base-de-donnees-mysql-avec-jdbc-java.html)

Connection can be done through the `jbdc` library

```java
//étape 1: Load driver class
Class.forName("com.mysql.jdbc.Driver");

//étape 2: Create connection object
Connection connection = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/test", "root", "");

//étape 3: Create statement object
Statement statement = connection.createStatement();
ResultSet response = statement.executeQuery("SELECT * FROM person");

//étape 4: Execute the query
while(response.next())
  System.out.println(
    response.getInt(1) + " " +
    response.getString(2) + " " +
    response.getString(3)
  );

//étape 5: Close the connection
connection.close();
```

## Testing

### Unit Testing

The main library to make unit testing with Java is called [JUnit](https://junit.org/junit5/)

[Source](https://www.baeldung.com/junit-5)

Maven dependancy
```xml
<dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter-engine</artifactId>
    <version>5.11.0-M2</version>
    <scope>test</scope>
</dependency>
```

#### JUnit Platform

The platform is responsible for launching testing frameworks on the JVM. It defines a stable and powerful interface between JUnit and its clients, such as build tools.
The platform easily integrates clients with JUnit to discover and execute tests.
It also defines the TestEngine API for developing a testing framework that runs on the JUnit platform. By implementing a custom TestEngine, we can plug 3rd party testing libraries directly into JUnit.

#### JUnit Jupiter

This module includes new programming and extension models for writing tests in JUnit 5. New annotations in comparison to JUnit 4 are:

- `@TestFactory` – denotes a method that’s a test factory for dynamic tests
- `@DisplayName` – defines a custom display name for a test class or a test method
- `@Nested` – denotes that the annotated class is a nested, non-static test class
- `@Tag` – declares tags for filtering tests
- `@ExtendWith` – registers custom extensions
- `@BeforeEach` – denotes that the annotated method will be executed before each test method (previously @Before)
- `@AfterEach` – denotes that the annotated method will be executed after each test method (previously @After)
- `@BeforeAll` – denotes that the annotated method will be executed before all test methods in the current class (previously @BeforeClass)
- `@AfterAll` – denotes that the annotated method will be executed after all test methods in the current class (previously @AfterClass)
- `@Disabled` – disables a test class or method (previously @Ignore)



#### JUnit Vintage

JUnit Vintage supports running tests based on JUnit 3 and JUnit 4 on the JUnit 5 platform

#### Launch Tests

With maven
```bash
mvn clean test
mvn clean test -Dtest=your.package.TestClassName
```

With gradle

```bash
gradle test
gradle test --info
gradle test --tests your.package.TestClassName
```

## Web

### Web framework Frameworks

[Source](https://rollbar.com/blog/most-popular-java-web-frameworks/#)

The most popular Java web frameworks are:
- [Spring](https://rollbar.com/blog/most-popular-java-web-frameworks/#spring)
- [JSF](https://rollbar.com/blog/most-popular-java-web-frameworks/#JSP)
- [GWT](https://rollbar.com/blog/most-popular-java-web-frameworks/#GWT)
- [Play!](https://www.playframework.com/)
- [Struts](https://struts.apache.org/)
- [Vaadin](https://vaadin.com/)
- [Grails](https://grails.org/)

Java Frameworks that are popular but not for the Web (We don’t want to forget them):
- [Hibernate](http://hibernate.org/) (Data-focused)
- [Maven](https://maven.apache.org/) (Build-focused)
- [Apache Ant](http://ant.apache.org/) with [Ivy](https://ant.apache.org/ivy/) (Build-focused)
