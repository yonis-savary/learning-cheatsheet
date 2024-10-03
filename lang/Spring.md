<center>
    <img src="https://cdn.worldvectorlogo.com/logos/spring-3.svg" width="200">
</center>


# Work with Java Spring

## Resources

- [Spring Official Website Guides](https://spring.io/guides)

## Quick Start

[Source](https://spring.io/quickstart)

Sprint projects can be generated from [Spring intializr](https://start.spring.io/)

### Demo Example

```java
package com.example.demo;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class DemoApplication
{
    public static void main(String[] args)
    {
      SpringApplication.run(DemoApplication.class, args);
    }

    @GetMapping("/hello")
    public String hello(
        @RequestParam(value = "name", defaultValue = "World") String name
    ){
      return String.format("Hello %s!", name);
    }
}
```

### Run an Spring Application

To run the application, run the following command in a terminal window (in the `complete`) directory
```bash
# With maven
./mvnw spring-boot:run

# With gradle
./gradlew bootRun
```

## Request & Response
## Configuration
## Commands
## Models
## Views
## Controller
## Routing
## Middlewares
## Events
## Logging
## Utils
## Session
## Caching
## Queueing
## Event Source
## Upload file