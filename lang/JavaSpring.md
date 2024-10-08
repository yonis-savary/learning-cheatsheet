
[< Back to README](../README.md)

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
  - [Models (Entity)](#models)
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
@ResponseStatus(HttpsStatus.CREATED)
public ResponseEntity postController(@RequestBody LoginForm loginForm)
{
    exampleService.fakeAuthenticate(loginForm);
    return ResponseEntity.ok(HttpStatus.OK);
}
```


Note :
- `@RestController` is reserved to RESTful apis and cannot return views


## Models (Entity)

[Good Source !](https://www.youtube.com/watch?v=31KTdfRH6nY)
[Source TODO](https://spring.io/guides/gs/accessing-data-jpa)
[Source TODO](https://stackoverflow.com/questions/36995670/how-can-i-generate-entities-classes-from-database-using-spring-boot-and-intellij)


## Views

Popular view engine [Thymeleaf](https://www.thymeleaf.org/)

```java
// Returning an HTML page

public String landingPage(Model model)
{
  // Add a rendering context variable
  model.addAttribute("message", "Hello everyone !");

  // Render "resources/templates/index.html"
  return "index";
}

```

## Events

## Logging

```java
class MyClass
{
  // Get a Logger from the application context
  private static final Logger log = LoggerFactory.getLogger(MyClass.class);
}
```

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

TODO

## Queueing

TODO

## Event Source

TODO

## Upload file

# Serving assets

- [Source](https://www.baeldung.com/spring-mvc-static-resources)
- [Soruce](https://www.geeksforgeeks.org/serve-static-resources-with-spring/)

Spring boot serves resources by default

We can customize which directories are used

```java
@Configuration
public class WebConfig implements WebMvcConfigurer
{
  @Override
  public void
  addResourceHandlers(ResourceHandlerRegistry registry)
  {
    registry.addResourceHandler("/static/**")
      .addResourceLocations("classpath:/static/")
      .setCachePeriod(3900)//mention in seconds
      .resourceChain(true)
      .addResolver(new PathResourceResolver());
  }
}
```

- Enabling Resource Chains : You can add a special code in the resource’s web address, making sure that browsers know when it changes. This helps in controlling how long the browser keeps a copy and ensures users always see the latest version of the resource. Lets see how we do this,


# Connect to database

Connect with `JDBC` connector library (can be added on initializr)

```java
// TODO GET JDBC URL

private JdbcClient jdbcClient;

public MyClass (JdbcClient jdbcClient) // Get from application context
{
  this.jdbcClient = jdbcClient;
}

jdbcClient.sql("SELECT * FROM ...")
.query(ModelClass.class)
.list()

var optionnalRun = jdbcClient.sql("SELECT ... WHERE id = :id")
.param("id", someId)
.query(ModelClass.class)
.optional();

optionnalRun.isPresent();

var created = jdbcClient.sql("INSERT INTO () VALUES (?, ?, ?, ?)") // SAME FOR UPDATE/DELETE STATEMENT
.params(List.of("A","B","C","D"))
.update();

boolean success = created == 1;

jdbcClient.sql("SELECT * FROM ...").query().listOfRows().size();
// TODO SEE @functionnalInterface
```

Connect to database

in `application.properties`
```ini
spring.datasource.url="jdbc:mysql://localhost:3360/mydatabase"
spring.datasource.username="root"
spring.datasource.password="somesecret"
```

## Generate entities from database

[Source](https://stackoverflow.com/a/36996497)

Install [`Hibernate`](https://www.jetbrains.com/help/idea/hibernate.html?origin=old_help#d1785882e332) library

```xml
<dependency>
    <groupId>org.hibernate</groupId>
    <artifactId>hibernate-core</artifactId>
    <version>5.6.0.Final</version>
</dependency>
```

[Tutorial](https://www.jetbrains.com/help/idea/persistence-tool-window.html#generate-entities-from-database)

# Utils

## Changing port server

In `resources/application.properties`
```ini
server.port=8085
```

- Put `@Component` to add class to application context


```java
TypeReference.class.getResourceAsStream("./relpathfromAppResources");
```


## Authentication with Spring Security

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-security</artifactId>
</dependency>
```

(Optionnal) Specify Spring Security Version

```xml
<properties>
	<spring-security.version>6.3.3</spring-security.version>
</properties>
```

Create the security filters that allow unauthenticated user to only visits `/login` and `/register`

```java
@Configuration
@EnableWebSecurity
public class SecurityConfiguration
{
  /*
  Specify the way we encode passwords
  */
  @Bean
  public PasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder();
  }

  @Bean
  SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception
  {
    return http
    .csrf(AbstractHttpConfigurer::disable)
    .formLogin(form ->
      form
        .loginPage("/login")
        .loginProcessingUrl("/handle-login")
        .defaultSuccessUrl("/")
        .failureUrl("/login")
        .permitAll()
    )
    .authorizeHttpRequests(customizer -> {
        customizer.requestMatchers("/register**", "/login").permitAll();
        customizer.anyRequest().authenticated();
    })
    .build();
  }
}
```

Create the user entity

```java
@Entity
@Table(name = "user")
public class User implements UserDetails
{
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "id", nullable = false)
  private Integer id;

  @Column(name="login", unique = true, nullable = false, length = 200)
  private String login;

  @Column(name="password", nullable = false, length = 100)
  private String password;

  public Integer getId() { return id; }
  public void setId(Integer id) { this.id = id; }

  @Override
  public String getUsername() { return this.getLogin(); }
  public String getLogin() { return login; }
  public void setLogin(String login) { this.login = login; }

  @Override
  public Collection<? extends GrantedAuthority> getAuthorities()
  {
      return List.of(() -> "read");
  }

  @Override
  public String getPassword() { return this.password; }
  public void setPassword(String password) { this.password = password; }
}
```

Then, create a basic crud repository for the model

```java
public interface UserRepository extends ListCrudRepository<User,Integer> {
    Optional<User> findByLogin(String login);
}
```

Implements the `UserDetailsService` provider

```java
@Service
public class SecurityUserDetailService implements UserDetailsService
{
  UserRepository userRepository;

  public SecurityUserDetailService(UserRepository userRepository)
  {
      this.userRepository = userRepository;
  }

  @Override
  public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
      return userRepository.findByLogin(username)
              .orElseThrow(() -> new UsernameNotFoundException("User not present"));
  }

  public void createUser(User user)
  {
      userRepository.save(user);
  }
}
```

Finally, create a login controller

```java
@Controller
public class LoginController
{
  SecurityUserDetailService userDetailsManager;
  PasswordEncoder passwordEncoder;
  Logger logger = LoggerFactory.getLogger(LoginController.class);

  public LoginController (
    SecurityUserDetailService userDetailsManager,
    PasswordEncoder passwordEncoder
  )
  {
      this.userDetailsManager = userDetailsManager;
      this.passwordEncoder = passwordEncoder;
  }

  @PostMapping(value="/register", consumes=MediaType.APPLICATION_FORM_URLENCODED_VALUE)
  public ModelAndView addUser(@RequestParam Map<String, String> body)
  {
    User user = new User();
    user.setLogin(body.get("username"));
    user.setPassword(passwordEncoder.encode(body.get("password")));
    userDetailsManager.createUser(user);

    return new ModelAndView("redirect:/login");
  }

  @GetMapping("/register")
  public String register()
  {
    return "register";
  }


  @GetMapping("/login")
  public String login()
  {
    return "login";
  }
}
```

Example of login page
```html
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:th="https://www.thymeleaf.org">
	<head>
		<title>Please Log In</title>
	</head>
	<body>
		<h1>Please Log In</h1>
		<div th:if="${param.error}">
			Invalid username and password.</div>
		<div th:if="${param.logout}">
			You have been logged out.</div>
		<form th:action="@{/handle-login}" method="post">
			<div>
			<input type="text" name="username" placeholder="Username"/>
			</div>
			<div>
			<input type="password" name="password" placeholder="Password"/>
			</div>
			<input type="submit" value="Log in" />
		</form>
	</body>
</html>
```

### Utils

Get authenticated user

```java
String myMethod(Principal user, Model model)
{
  model.addAttribute("user", user.getName());
  return "my-view";
}
```