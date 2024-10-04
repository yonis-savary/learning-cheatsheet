<center>
    <img
        src="https://upload.wikimedia.org/wikipedia/commons/thumb/5/52/Apache_Maven_logo.svg/640px-Apache_Maven_logo.svg.png"
        width="300"
    >
</center>

# Java Maven Cheatsheet

### Using Maven [(Source)](https://maven.apache.org/guides/getting-started/maven-in-five-minutes.html)

Check Maven version :
```bash
mvn --version
```

Creating a project

```bash
mvn archetype:generate -DgroupId=com.mycompany.app -DartifactId=my-app -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.5 -DinteractiveMode=false
```

Build & test a project

```bash
mvn package
```

Test the program

```bash
java -cp target/my-app-1.0-SNAPSHOT.jar com.mycompany.app.App
```


Although hardly a comprehensive list, these are the most common default lifecycle phases executed.

- `validate`: validate the project is correct and all necessary information is available
- `compile`: compile the source code of the project
- `test`: test the compiled source code using a suitable unit testing- framework. These tests should not require the code be packaged or deployed
- `package`: take the compiled code and package it in its distributable format, such as a JAR.
- `integration-test`: process and deploy the package if necessary into an environment where integration tests can be run
- `verify`: run any checks to verify the package is valid and meets quality criteria
- `install`: install the package into the local repository, for use as a dependency in other projects locally
- `deploy`: done in an integration or release environment, copies the final package to the remote repository for sharing with other developers and projects.

There are two other Maven lifecycles of note beyond the default list above. They are

- `clean`: cleans up artifacts created by prior builds
- `site`: generates site documentation for this project

Phases are actually mapped to underlying goals. The specific goals executed per phase is dependant upon the packaging type of the project. For example, package executes jar:jar if the project type is a JAR, and war:war if the project type is - you guessed it - a WAR.

An interesting thing to note is that phases and goals may be executed in sequence.

```bash
mvn clean dependency:copy-dependencies package
```

This command will clean the project, copy dependencies, and package the project (executing all phases up to package, of course).


### Add classpath to define main function

1. (SOLUTION 1) Create a uber-jar that includes dependencies with [Maven Shade Plugin](https://medium.com/@lavneesh.chandna/unveiling-the-maven-shade-plugin-a-comprehensive-guide-e878966f6ee8), see [documentation](https://maven.apache.org/plugins/maven-shade-plugin/)

Add this in `pom.xml`

**Be sure that you're adding this in `build>plugins`, not in `build>pluginManagement>plugins`**

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-shade-plugin</artifactId>
    <version>3.6.0</version>
    <executions>
        <execution>
        <phase>package</phase>
        <goals>
            <goal>shade</goal>
        </goals>
        <configuration>
            <minimizeJar>true</minimizeJar>
            <transformers>
            <transformer
                implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                <mainClass>org.yourproject.YourMainClass</mainClass>
            </transformer>
            </transformers>
        </configuration>
        </execution>
    </executions>
</plugin>
```


2. (SOLUTION 2) Create a single Jar

Add this in `pom.xml`

```xml
  <build>
      <plugins>
          <plugin>
              <groupId>org.apache.maven.plugins</groupId>
              <artifactId>maven-jar-plugin</artifactId>
              <version>3.4.0</version>
              <configuration>
                <archive>
                    <manifest>
                    <addClasspath>true</addClasspath>
                    <mainClass>full.namespace.ClassName</mainClass>
                    </manifest>
                </archive>
              </configuration>
          </plugin>
      </plugins>
  </build>
```

And then

```bash
mvn package
java -jar target/something_snapshot.jar
```
