<p align="center">
    <img src="https://cdn.worldvectorlogo.com/logos/spring-3.svg" width="200">
</p>

# Java Spring cheatsheet

## Index

- [Java Spring cheatsheet](#java-spring-cheatsheet)
  - [Resources](#resources)
  - [Quick Start](#quick-start)
    - [Demo Example](#demo-example)
    - [Run an Spring Application](#run-an-spring-application)
- [With maven](#with-maven)
- [With gradle](#with-gradle)
  - [Request & Response](#request---response)
    - [Request Params](#request-params)
  - [Routing](#routing)
  - [Configuration](#configuration)
  - [Commands](#commands)
  - [Models](#models)
  - [Views](#views)
  - [Middlewares](#middlewares)
  - [Events](#events)
  - [Logging](#logging)
  - [Utils](#utils)
  - [Session](#session)
  - [Caching](#caching)
  - [Queueing](#queueing)
  - [Event Source](#event-source)
  - [Upload file](#upload-file)
- [Serving assets](#serving-assets)

## Resources

- [Spring Official Website Guides](https://spring.io/guides)
- [WIP Source](https://www.youtube.com/watch?v=8B0IjOIzicU)

## Quick Start

[Source](https://spring.io/quickstart)

Sprint projects can be generated from [Spring intializr](https://start.spring.io/)
**(For web project, don't forget to add "Spring Web" dependency before downloading)**

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

To run the applicatio8000n, run the following command in a terminal window (in the `complete`) directory
```bash
# With maven
./mvnw spring-boot:run

# With gradle
./gradlew bootRun
```

## Request & Response

### Request Params

We can get request params through the `@RequestParam` annotation

```java
@RequestParam(name = "id") int userId // specify query param name
@RequestParam(defaultValue = true) bool useJoin // specify default value

@RequestParam(required = false) String // Optionnal
@RequestParam Optional<String> // Optionnal

@RequestParam Map<String,String> allParams // Get all params at once

@RequestParam List<String> id // Get a list
/api/foo?id=1,2,3
/api/foo?id=1&id=2
```

## Routing

Put on the controller :
```java
@Controller // or @RestController
@RequestMapping("/route-group") // Optionnal but useful
```

Put on the method :

```java
@GetMapping("/route")
@PostMapping("/route")
@PutMapping("/route")
@DeleteMapping("/route")
@PatchMapping("/route")
```


Slugs (Path Variable)
```java
@GetMapping("/{id}")
public Person getPerson(@PathVariable Long id);
```


Consumable Media Types
```java
@PostMapping(path = "/pets", consumes = "application/json")
public void addPet(@RequestBody Pet pet);
```

Producible Media Types
```java
@GetMapping(path = "/pets/{petId}", produces = MediaType.APPLICATION_JSON_VALUE)
@ResponseBody
public Pet getPet(@PathVariable String petId);
```

`@ResponseBody` annotation tells a controller that the object returned is automatically serialized into JSON and passed back into the HttpResponse object.

`@RequestBody` annotation : Simply put, the @RequestBody annotation maps the HttpRequest body to a transfer or domain object, enabling automatic deserialization of the inbound HttpRequest body onto a Java object.

```java
@PostMapping("/request")
public ResponseEntity postController(@RequestBody LoginForm loginForm)
{
    exampleService.fakeAuthenticate(loginForm);
    return ResponseEntity.ok(HttpStatus.OK);
}
```


Note :
- `@RestController` is reserved to RESTful apis and cannot return views


## Configuration
## Commands
## Models
## Views
## Middlewares
## Events
## Logging
## Utils
## Session

Dependency

```xml
<dependency>
    <groupId>org.springframework.session</groupId>
    <artifactId>spring-session</artifactId>
    <version>1.2.2.RELEASE</version>
</dependency>
```

## Caching
## Queueing
## Event Source
## Upload file

# Serving assets

[Source](https://www.baeldung.com/spring-mvc-static-resources)