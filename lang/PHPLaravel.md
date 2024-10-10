[< Back to README](../README.md)

<p align="center">
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/Laravel.svg/1969px-Laravel.svg.png" width="200">
</p>

# Laravel Webdev Cheatsheet

[Source](https://laravel.com/docs/11.x/structure)

Root Directory
  - `app/` : application files
  - `bootstrap/` : bootstrap & performance cache
  - `config/` : php configuration files
  - `database/` : migration, model factories & seeds
  - `public/` : index & assets
  - `resources/` : views & uncompiled assets
  - `routes/` : every http and non-http routes files
  - `storage/` : logs, compiled templates, caches
  - `tests/`
  - `vendor/`

App Directory
  - `Broadcasting/`: broadcasting classes (`make:channel` commmand)
  - `Console/`: custom artisan commands (`make:command`)
  - `Events/` : custom events classes (`make:event` or `event:generate`)
  - `Exceptions/` : custom exceptions (`make:exception`)
  - `Http/`: all of web logic (controllers, middlewares...etc)
  - `Jobs/` [queueables jobs](https://laravel.com/docs/11.x/queues) made through (`make:job`)
  - `Listeners/`: classes that handles events (`make:listener`)
  - `Mail/` : mails that your app sends (`make:mail`)
  - `Models/`: [Eloquent model classes](https://laravel.com/docs/11.x/eloquent), database entities to work with
  - `Notifications/`: sames as `Mail`, but for notifications (`make:notification`)
  - `Policies/`: Policies are used to determine if a user can perform a given action against a resource. (`make:policy`)
  - `Providers/` : [service providers](https://laravel.com/docs/11.x/providers) for your app
  - `Rules/`: Rules are used to encapsulate complicated validation logic in a simple object. For more information, check out the [validation documentation](https://laravel.com/docs/11.x/validation).(`make:rule`)


## More on `/storage`

The `storage/app/public` directory may be used to store user-generated files, such as profile avatars, that should be publicly accessible. You should create a symbolic link at `public/storage` which points to this directory. You may create the link using the `php artisan storage:link` Artisan command

























## Service Container

[Source](https://laravel.com/docs/11.x/container)

> The Laravel service container is a powerful tool for managing class dependencies and performing dependency injection. Dependency injection is a fancy phrase that essentially means this: class dependencies are "injected" into the class via the constructor or, in some cases, "setter" methods.

In other words, when laravel has to deal with a special class that you're calling, you need to specify how to create an instance of that special class

### Zero Configuration Resolution

If a class has no dependencies or only depends on other concrete classes (not interfaces), the container does not need to be instructed on how to resolve that class. For example, you may place the following code in your routes/web.php file:

```php
<?php

class Service { }

Route::get('/', function (Service $service) {
    die($service::class);
});
```

In this example, hitting your application's `/` route will automatically resolve the `Service` class and inject it into your route's handler.

This is game changing. It means you can develop your application and take advantage of dependency injection without worrying about bloated configuration files.

> Thankfully, many of the classes you will be writing when building a Laravel application automatically receive their dependencies via the container, including controllers, event listeners, middleware, and more. Additionally, you may type-hint dependencies in the `handle` method of queued jobs. [...]

### When to Utilize the Container

Let's examine two situations

First, if you write a class that implements an interface and you wish to type-hint that interface on a route or class constructor, you must tell the container how to resolve that interface. Secondly, if you are writing a Laravel package that you plan to share with other Laravel developers, you may need to bind your package's services into the container

### Binding

Through a service provider

```php
$this->app->bind(Transistor::class, function (Application $app) {
    return new Transistor($app->make(PodcastParser::class));
});

# You may use the bindIf method to register a container binding only if a binding has not already been registered for the given type:
$this->app->bindIf(Transistor::class, function (Application $app) {
    return new Transistor($app->make(PodcastParser::class));
});

# You may also do it from the `App` facade
App::bind(Transistor::class, function (Application $app) {
    // ...
});

# Build a singleton for classes that only need to be resolved once
# `singletonIf()` also exists
$this->app->singleton(Transistor::class, function (Application $app) {
    return new Transistor($app->make(PodcastParser::class));
});


# Binding a scoped singletons, which means, a singleton that will be flushed once the request lifecycle ends
$this->app->scoped(Transistor::class, function (Application $app) {
    return new Transistor($app->make(PodcastParser::class));
});

# Bind a specific instance
$this->app->instance(Transistor::class, $service);

# Bind interfaces to implementations
$this->app->bind(EventPusher::class, RedisEventPusher::class);


# Provide different implementation for two classes that implements the same interface
$this->app->when(PhotoController::class)
          ->needs(Filesystem::class)
          ->give(function () {
              return Storage::disk('local');
          });

$this->app->when([VideoController::class, UploadController::class])
          ->needs(Filesystem::class)
          ->give(function () {
              return Storage::disk('s3');
          });

```

Laravel provides a CurrentUser attribute for injecting the currently authenticated user into a given route or class:

```php
Route::get('/user', function (#[CurrentUser] User $user) {
    return $user;
})->middleware('auth');
```

Use services providers when needed

```php
$transistor = App::make(Transistor::class);
```

Using events

```php
$this->app->resolving(Transistor::class, function (Transistor $transistor, Application $app) {
    // Called when container resolves objects of type "Transistor"...
});

$this->app->resolving(function (mixed $object, Application $app) {
    // Called when container resolves object of any type...
});
```



























## Service Providers

[Source](https://laravel.com/docs/11.x/providers)


> Service providers are the central place of all Laravel application bootstrapping. Your own application, as well as all of Laravel's core services, are bootstrapped via service providers. [...] All user-defined service providers are registered in the `bootstrap/providers.php` file.

Create a service provider

```bash
php artisan make:provider RiakServiceProvider
```

Basic Usage

```php
class RiakServiceProvider extends ServiceProvider
{
    /** Register any application services. */
    public function register(): void
    {
        $this->app->singleton(Connection::class, function (Application $app) {
            return new Connection(config('riak'));
        });
    }
}
```

Shorthand usage

```php
class AppServiceProvider extends ServiceProvider
{
    /** All of the container bindings that should be registered.*/
    public $bindings = [
        ServerProvider::class => DigitalOceanServerProvider::class,
    ];

    /** All of the container singletons that should be registered. */
    public $singletons = [
        DowntimeNotifier::class => PingdomDowntimeNotifier::class,
        ServerProvider::class => ServerToolsProvider::class,
    ];
}
```


### The Boot Method

So, what if we need to register a view composer within our service provider? This should be done within the `boot` method. This method is called after all other service providers have been registered, meaning you have access to all other services that have been registered by the framework:

```php
public function boot(): void
{
    View::composer('view', function () {
        // ...
    });
}
```

### Registering providers

in `app/bootstrap/providers.php`

```php
return [
  App\Providers\AppServiceProvider::class,
];
```

Note: `make:provider` automatically adds your new provider to this file

### Deferred Providers

> If your provider is only registering bindings in the service container, you may choose to defer its registration until one of the registered bindings is actually needed. Deferring the loading of such a provider will improve the performance of your application, since it is not loaded from the filesystem on every request.

> To defer the loading of a provider, implement the `\Illuminate\Contracts\Support\DeferrableProvider` interface and define a `provides` method. The `provides` method should return the service container bindings registered by the provider:

```php
class RiakServiceProvider extends ServiceProvider implements DeferrableProvider
{
  // ...

  /**  Get the services provided by the provider. */
  public function provides(): array
  {
      return [Connection::class];
  }
}
```




















## Optimization & Caching

### Optimizations

When deploying your application to production, there are a variety of files that should be cached, including your configuration, events, routes, and views. Laravel provides a single, convenient optimize Artisan command that will cache all of these files. This command should typically be invoked as part of your application's deployment process:

```bash
php artisan optimize
```

The optimize:clear method may be used to remove all of the cache files generated by the optimize command as well as all keys in the default cache driver:

```bash
php artisan optimize:clear
```

In the following documentation, we will discuss each of the granular optimization commands that are executed by the optimize command.

## Directory Structure



























## Configuration

Configuration is done throught `.env` file

```ini
KEY="VALUE"
```

Access config values
```php
$value = Config::get("app.timezone");
$value = Config::integer("max-age");
$value = config("app.timezone");
$value = config("app.timezone", "defaultValue");
```


Get application environment

```php
$environment = App::environment();
```





















## Facades

[Source](https://laravel.com/docs/11.x/facades)

> Facades provide a "static" interface to classes that are available in the application's service container. Laravel ships with many facades which provide access to almost all of Laravel's features.

> Facades have many benefits. They provide a terse, memorable syntax that allows you to use Laravel's features without remembering long class names that must be injected or configured manually. Furthermore, because of their unique usage of PHP's dynamic methods, they are easy to test.























## Helpers

[Source](https://laravel.com/docs/11.x/helpers)

Arrays & Objects
 - [`Arr::accessible`](https://laravel.com/docs/11.x/helpers#method-array-accessible)
 - [`Arr::add`](https://laravel.com/docs/11.x/helpers#method-array-add)
 - [`Arr::collapse`](https://laravel.com/docs/11.x/helpers#method-array-collapse)
 - [`Arr::crossJoin`](https://laravel.com/docs/11.x/helpers#method-array-crossJoin)
 - [`Arr::divide`](https://laravel.com/docs/11.x/helpers#method-array-divide)
 - [`Arr::dot`](https://laravel.com/docs/11.x/helpers#method-array-dot)
 - [`Arr::except`](https://laravel.com/docs/11.x/helpers#method-array-except)
 - [`Arr::exists`](https://laravel.com/docs/11.x/helpers#method-array-exists)
 - [`Arr::first`](https://laravel.com/docs/11.x/helpers#method-array-first)
 - [`Arr::flatten`](https://laravel.com/docs/11.x/helpers#method-array-flatten)
 - [`Arr::forget`](https://laravel.com/docs/11.x/helpers#method-array-forget)
 - [`Arr::get`](https://laravel.com/docs/11.x/helpers#method-array-get)
 - [`Arr::has`](https://laravel.com/docs/11.x/helpers#method-array-has)
 - [`Arr::hasAny`](https://laravel.com/docs/11.x/helpers#method-array-hasAny)
 - [`Arr::isAssoc`](https://laravel.com/docs/11.x/helpers#method-array-isAssoc)
 - [`Arr::isList`](https://laravel.com/docs/11.x/helpers#method-array-isList)
 - [`Arr::join`](https://laravel.com/docs/11.x/helpers#method-array-join)
 - [`Arr::keyBy`](https://laravel.com/docs/11.x/helpers#method-array-keyBy)
 - [`Arr::last`](https://laravel.com/docs/11.x/helpers#method-array-last)
 - [`Arr::map`](https://laravel.com/docs/11.x/helpers#method-array-map)
 - [`Arr::mapSpread`](https://laravel.com/docs/11.x/helpers#method-array-mapSpread)
 - [`Arr::mapWithKeys`](https://laravel.com/docs/11.x/helpers#method-array-mapWithKeys)
 - [`Arr::only`](https://laravel.com/docs/11.x/helpers#method-array-only)
 - [`Arr::pluck`](https://laravel.com/docs/11.x/helpers#method-array-pluck)
 - [`Arr::prepend`](https://laravel.com/docs/11.x/helpers#method-array-prepend)
 - [`Arr::prependKeysWith`](https://laravel.com/docs/11.x/helpers#method-array-prepend-keys-with)
 - [`Arr::pull`](https://laravel.com/docs/11.x/helpers#method-array-pull)
 - [`Arr::query`](https://laravel.com/docs/11.x/helpers#method-array-query)
 - [`Arr::random`](https://laravel.com/docs/11.x/helpers#method-array-random)
 - [`Arr::set`](https://laravel.com/docs/11.x/helpers#method-array-set)
 - [`Arr::shuffle`](https://laravel.com/docs/11.x/helpers#method-array-shuffle)
 - [`Arr::sort`](https://laravel.com/docs/11.x/helpers#method-array-sort)
 - [`Arr::sortDesc`](https://laravel.com/docs/11.x/helpers#method-array-sortDesc)
 - [`Arr::sortRecursive`](https://laravel.com/docs/11.x/helpers#method-array-sort-recursive)
 - [`Arr::take`](https://laravel.com/docs/11.x/helpers#method-array-take)
 - [`Arr::toCssClasses`](https://laravel.com/docs/11.x/helpers#method-array-to-css-classes)
 - [`Arr::toCssStyles`](https://laravel.com/docs/11.x/helpers#method-array-to-css-styles)
 - [`Arr::undot`](https://laravel.com/docs/11.x/helpers#method-array-undot)
 - [`Arr::where`](https://laravel.com/docs/11.x/helpers#method-array-where)
 - [`Arr::whereNotNull`](https://laravel.com/docs/11.x/helpers#method-array-where-not-null)
 - [`Arr::wrap`](https://laravel.com/docs/11.x/helpers#method-array-wrap)
 - [`data_fill`](https://laravel.com/docs/11.x/helpers#method-data-fill)
 - [`data_get`](https://laravel.com/docs/11.x/helpers#method-data-get)
 - [`data_set`](https://laravel.com/docs/11.x/helpers#method-data-set)
 - [`data_forget`](https://laravel.com/docs/11.x/helpers#method-data-forget)
 - [`head`](https://laravel.com/docs/11.x/helpers#method-head)
 - [`last`](https://laravel.com/docs/11.x/helpers#method-last)

Numbers
 - [`Number::abbreviate`](https://laravel.com/docs/11.x/helpers#method-number-abbreviate)
 - [`Number::clamp`](https://laravel.com/docs/11.x/helpers#method-number-clamp)
 - [`Number::currency`](https://laravel.com/docs/11.x/helpers#method-number-currency)
 - [`Number::fileSize`](https://laravel.com/docs/11.x/helpers#method-number-fileSize)
 - [`Number::forHumans`](https://laravel.com/docs/11.x/helpers#method-number-for-humans)
 - [`Number::format`](https://laravel.com/docs/11.x/helpers#method-number-format)
 - [`Number::ordinal`](https://laravel.com/docs/11.x/helpers#method-number-ordinal)
 - [`Number::pairs`](https://laravel.com/docs/11.x/helpers#method-number-pairs)
 - [`Number::percentage`](https://laravel.com/docs/11.x/helpers#method-number-percentage)
 - [`Number::spell`](https://laravel.com/docs/11.x/helpers#method-number-spell)
 - [`Number::trim`](https://laravel.com/docs/11.x/helpers#method-number-trim)
 - [`Number::useLocale`](https://laravel.com/docs/11.x/helpers#method-number-use-locale)
 - [`Number::withLocale`](https://laravel.com/docs/11.x/helpers#method-number-with-locale)

Paths
 - [`app_path`](https://laravel.com/docs/11.x/helpers#method-app-path)
 - [`base_path`](https://laravel.com/docs/11.x/helpers#method-base-path)
 - [`config_path`](https://laravel.com/docs/11.x/helpers#method-config-path)
 - [`database_path`](https://laravel.com/docs/11.x/helpers#method-database-path)
 - [`lang_path`](https://laravel.com/docs/11.x/helpers#method-lang-path)
 - [`mix`](https://laravel.com/docs/11.x/helpers#method-mix)
 - [`public_path`](https://laravel.com/docs/11.x/helpers#method-public-path)
 - [`resource_path`](https://laravel.com/docs/11.x/helpers#method-resource-path)
 - [`storage_path`](https://laravel.com/docs/11.x/helpers#method-storage-path)

URLs
 - [`action`](https://laravel.com/docs/11.x/helpers#method-action)
 - [`asset`](https://laravel.com/docs/11.x/helpers#method-asset)
 - [`route`](https://laravel.com/docs/11.x/helpers#method-route)
 - [`secure_asset`](https://laravel.com/docs/11.x/helpers#method-secure-asset)
 - [`secure_url`](https://laravel.com/docs/11.x/helpers#method-secure-url)
 - [`to_route`](https://laravel.com/docs/11.x/helpers#method-to_route)
 - [`url`](https://laravel.com/docs/11.x/helpers#method-url)

Miscellaneous
 - [`abort`](https://laravel.com/docs/11.x/helpers#method-abort)
 - [`abort_if`](https://laravel.com/docs/11.x/helpers#method-abort-if)
 - [`abort_unless`](https://laravel.com/docs/11.x/helpers#method-abort-unless)
 - [`app`](https://laravel.com/docs/11.x/helpers#method-app)
 - [`auth`](https://laravel.com/docs/11.x/helpers#method-auth)
 - [`back`](https://laravel.com/docs/11.x/helpers#method-back)
 - [`bcrypt`](https://laravel.com/docs/11.x/helpers#method-bcrypt)
 - [`blank`](https://laravel.com/docs/11.x/helpers#method-blank)
 - [`broadcast`](https://laravel.com/docs/11.x/helpers#method-broadcast)
 - [`cache`](https://laravel.com/docs/11.x/helpers#method-cache)
 - [`class_uses_recursive`](https://laravel.com/docs/11.x/helpers#method-class-uses-recursive)
 - [`collect`](https://laravel.com/docs/11.x/helpers#method-collect)
 - [`config`](https://laravel.com/docs/11.x/helpers#method-config)
 - [`context`](https://laravel.com/docs/11.x/helpers#method-context)
 - [`cookie`](https://laravel.com/docs/11.x/helpers#method-cookie)
 - [`csrf_field`](https://laravel.com/docs/11.x/helpers#method-csrf-field)
 - [`csrf_token`](https://laravel.com/docs/11.x/helpers#method-csrf-token)
 - [`decrypt`](https://laravel.com/docs/11.x/helpers#method-decrypt)
 - [`dd`](https://laravel.com/docs/11.x/helpers#method-dd)
 - [`dispatch`](https://laravel.com/docs/11.x/helpers#method-dispatch)
 - [`dispatch_sync`](https://laravel.com/docs/11.x/helpers#method-dispatch-sync)
 - [`dump`](https://laravel.com/docs/11.x/helpers#method-dump)
 - [`encrypt`](https://laravel.com/docs/11.x/helpers#method-encrypt)
 - [`env`](https://laravel.com/docs/11.x/helpers#method-env)
 - [`event`](https://laravel.com/docs/11.x/helpers#method-event)
 - [`fake`](https://laravel.com/docs/11.x/helpers#method-fake)
 - [`filled`](https://laravel.com/docs/11.x/helpers#method-filled)
 - [`info`](https://laravel.com/docs/11.x/helpers#method-info)
 - [`literal`](https://laravel.com/docs/11.x/helpers#method-literal)
 - [`logger`](https://laravel.com/docs/11.x/helpers#method-logger)
 - [`method_field`](https://laravel.com/docs/11.x/helpers#method-method-field)
 - [`now`](https://laravel.com/docs/11.x/helpers#method-now)
 - [`old`](https://laravel.com/docs/11.x/helpers#method-old)
 - [`once`](https://laravel.com/docs/11.x/helpers#method-once)
 - [`optional`](https://laravel.com/docs/11.x/helpers#method-optional)
 - [`policy`](https://laravel.com/docs/11.x/helpers#method-policy)
 - [`redirect`](https://laravel.com/docs/11.x/helpers#method-redirect)
 - [`report`](https://laravel.com/docs/11.x/helpers#method-report)
 - [`report_if`](https://laravel.com/docs/11.x/helpers#method-report-if)
 - [`report_unless`](https://laravel.com/docs/11.x/helpers#method-report-unless)
 - [`request`](https://laravel.com/docs/11.x/helpers#method-request)
 - [`rescue`](https://laravel.com/docs/11.x/helpers#method-rescue)
 - [`resolve`](https://laravel.com/docs/11.x/helpers#method-resolve)
 - [`response`](https://laravel.com/docs/11.x/helpers#method-response)
 - [`retry`](https://laravel.com/docs/11.x/helpers#method-retry)
 - [`session`](https://laravel.com/docs/11.x/helpers#method-session)
 - [`tap`](https://laravel.com/docs/11.x/helpers#method-tap)
 - [`throw_if`](https://laravel.com/docs/11.x/helpers#method-throw-if)
 - [`throw_unless`](https://laravel.com/docs/11.x/helpers#method-throw-unless)
 - [`today`](https://laravel.com/docs/11.x/helpers#method-today)
 - [`trait_uses_recursive`](https://laravel.com/docs/11.x/helpers#method-trait-uses-recursive)
 - [`transform`](https://laravel.com/docs/11.x/helpers#method-transform)
 - [`validator`](https://laravel.com/docs/11.x/helpers#method-validator)
 - [`value`](https://laravel.com/docs/11.x/helpers#method-value)
 - [`view`](https://laravel.com/docs/11.x/helpers#method-view)
 - [`with`](https://laravel.com/docs/11.x/helpers#method-with)
 - [`when`](https://laravel.com/docs/11.x/helpers#method-when)


Benchmarking
```php
Benchmark::dd(fn () => User::count(), iterations: 10); // 0.5 ms
```

Date manipulation ([Carbon documentation](https://carbon.nesbot.com/docs/))
```php
$now = now();
```


Defer (Beta), call a function after the response has been sent
```php
defer(fn() => print("Hello"));
defer(fn () => Metrics::report(), 'reportMetrics');
defer()->forget('reportMetrics');
```


Lottery

Laravel's lottery class may be used to execute callbacks based on a set of given odds. This can be particularly useful when you only want to execute code for a percentage of your incoming requests:

```php
Lottery::odds(1, 20)
    ->winner(fn () => $user->won())
    ->loser(fn () => $user->lost())
    ->choose();
```

Pipelines

```php
$user = Pipeline::send($user)
  ->through([
      function (User $user, Closure $next) {
          // ...

          return $next($user);
      },
      function (User $user, Closure $next) {
          // ...

          return $next($user);
      },
  ])
  ->then(fn (User $user) => $user);

$user = Pipeline::send($user)
  ->through([
    GenerateProfilePhoto::class,
    ActivateSubscription::class,
    SendWelcomeEmail::class,
  ])
  ->then(fn (User $user) => $user);

```






















## Others


### Sail on linux

If you're developing on Linux and Docker Compose is already installed, you can use a simple terminal command to create a new Laravel application.

First, if you are using Docker Desktop for Linux, you should execute the following command. If you are not using Docker Desktop for Linux, you may skip this step:

```bash
docker context use default
```

Then, to create a new Laravel application in a directory named "example-app", you may run the following command in your terminal:

``` bash
curl -s https://laravel.build/example-app | bash
```

Of course, you can change "example-app" in this URL to anything you like - just make sure the application name only contains alpha-numeric characters, dashes, and underscores. The Laravel application's directory will be created within the directory you execute the command from.

Sail installation may take several minutes while Sail's application containers are built on your local machine.

After the application has been created, you can navigate to the application directory and start Laravel Sail. Laravel Sail provides a simple command-line interface for interacting with Laravel's default Docker configuration:

``` bash
cd example-app
./vendor/bin/sail up
```

Once the application's Docker containers have started, you should run your application's database migrations:

``` bash
./vendor/bin/sail artisan migrate
```

Finally, you can access the application in your web browser at: http://localhost.



















## Routing

### Api Routing

The routes in `routes/api.php` are stateless and are assigned to the api middleware group. Additionally, the `/api` URI prefix is automatically applied to these routes, so you do not need to manually apply it to every route in the file. You may change the prefix by modifying your application's `bootstrap/app.php` file:

```php
->withRouting(
    api: __DIR__.'/../routes/api.php',
    apiPrefix: 'api/admin',
    // ...
)
```

Available Router Methods

The router allows you to register routes that respond to any HTTP verb:

```php
Route::any($uri, $callback);
Route::get($uri, $callback);
Route::post($uri, $callback);
Route::put($uri, $callback);
Route::patch($uri, $callback);
Route::delete($uri, $callback);
Route::options($uri, $callback);
Route::redirect($uri, $anotherIRU, 301);

Route::view('/welcome', 'welcome');
Route::view('/welcome', 'welcome', ['name' => 'Taylor']);
```

CSRF Protection

Remember, any HTML forms pointing to POST, PUT, PATCH, or DELETE routes that are defined in the web routes file should include a CSRF token field. Otherwise, the request will be rejected. You can read more about CSRF protection in the CSRF documentation:

```php
<form method="POST" action="/profile">
    @csrf
    ...
</form>
```

Listing routes

```
php artisan route:list --path=api
```

Routes parameters (slug)

```php
Route::get('/user/{id}', function (int $id) {
    return 'User '.$id;
});
```

> Route parameters are always encased within {} braces and should consist of alphabetic characters. Underscores (_) are also acceptable within route parameter names

> If your route has dependencies that you would like the Laravel service container to automatically inject into your route's callback, you should list your route parameters after your dependencies:

```php
Route::get('/user/{id}', function (Request $request, string $id) {
    return 'User '.$id;
});

# Optionnal parameter
Route::get('/user/{id?}', function (?string $id) {
    return 'User '.$id;
});

# Using regex and format helpers
Route::get('/user/{name}', /* ... */)->where('name', '[A-Za-z]+');
Route::get('/user/{id}/', /* ... */)->whereNumber('id')->whereAlpha('name');
Route::get('/user/{name}', /* ... */)->whereAlphaNumeric('name');
Route::get('/user/{id}', /* ... */)->whereUuid('id');
Route::get('/user/{id}', /* ... */)->whereUlid('id');
Route::get('/category/{category}', /* ... */)->whereIn('category', ['movie', 'song', 'painting']);
Route::get('/category/{category}', /* ... */)->whereIn('category', CategoryEnum::cases());

```

Global Constraints

>If you would like a route parameter to always be constrained by a given regular expression, you may use the pattern method. You should define these patterns in the boot method of your application's App\Providers\AppServiceProvider class [...] Once the pattern has been defined, it is automatically applied to all routes using that parameter name

```php
Route::pattern('id', '[0-9]+');
```

Naming a route & generating an url to it

```php

Route::get(...)->name("profile");

$url = route("profile");
return to_route("profile");
return redirect()->route("profile");

Route::get("/user/{id}")->name("profile");

$url = route("profile", ["id" => 5]);
```

Get current route in a controller

```php
public function handleLogin(Request $request)
{
  $request->route();
}
```


Routes groups

```php

# Path prefix
Route::prefix('admin')->group(function () {});

# Apply a middleware on routes
Route::middleware(['first', 'second'])->group(function () {});

# Apply the same controller
Route::controller(OrderController::class)->group(function () {
    Route::get('/orders/{id}', 'show');
    Route::post('/orders', 'store');
});

# Apply to a specific subdomain
Route::domain('{account}.example.com')->group(function () {});

# Apply route name prefix
Route::name('admin.')->group(function () {});

```

#### Route Model Binding

> When injecting a model ID to a route or controller action, you will often query the database to retrieve the model that corresponds to that ID. Laravel route model binding provides a convenient way to automatically inject the model instances directly into your routes. For example, instead of injecting a user's ID, you can inject the entire User model instance that matches the given ID.

```php
# With primary key (id)
Route::get('/users/{user}', function (User $user) {
    return $user->email;
});

# define fallback callback
Route::get('/users/{user}', function (User $user) {
    return $user->email;
})->missing(function (Request $request) {
    return Redirect::route('locations.index');
});

# With custom column
Route::get('/posts/{post:slug}', function (Post $post) {
    return $post;
});

Route::get('/users/{user}/posts/{post}', function (User $user, Post $post) {
    return $post;
})->scopeBindings();

Route::scopeBindings()->group(function () {...});
```

#### Fallback Routes

> Using the `Route::fallback` method, you may define a route that will be executed when no other route matches the incoming request. Typically, unhandled requests will automatically render a "404" page via your application's exception handler. However, since you would typically define the fallback route within your `routes/web.php` file, all middleware in the web middleware group will apply to the route. You are free to add additional middleware to this route as needed:

```php
Route::fallback(function () {
    // ...
});
```

**Note : The fallback route should always be the last route registered by your application.**


#### Defining Rate Limiters

Laravel includes powerful and customizable rate limiting services that you may utilize to restrict the amount of traffic for a given route or group of routes. To get started, you should define rate limiter configurations that meet your application's needs.

Rate limiters may be defined within the boot method of your application's App\Providers\AppServiceProvider class:

```php
protected function boot(): void
{
    RateLimiter::for('api', function (Request $request) {
        return Limit::perMinute(60)->by($request->user()?->id ?: $request->ip());
    });

    RateLimiter::for('global', function (Request $request) {
        return Limit::perMinute(1000)->response(function (Request $request, array $headers) {
       ;     return response('Custom response...', 429, $headers);
        });
    });

    RateLimiter::for('uploads', function (Request $request) {
        return $request->user()->vipCustomer()
          ? Limit::none()
          : Limit::perMinute(100)->by($request->ip());
    });
}
```

Attach to routes

```php
Route::middleware(['throttle:uploads'])->group(function () {});
```

#### Cross-Origin Resource Sharing (CORS)

Laravel can automatically respond to CORS `OPTIONS` HTTP requests with values that you configure. The `OPTIONS` requests will automatically be handled by the `HandleCors` middleware that is automatically included in your application's global middleware stack.

Sometimes, you may need to customize the CORS configuration values for your application. You may do so by publishing the `cors` configuration file using the `config:publish` Artisan command:

```bash
php artisan config:publish cors
```

This command will place a `cors.php` configuration file within your application's `config` directory.
 > For more information on CORS and CORS headers, please consult the [MDN web documentation on CORS.](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS#The_HTTP_response_headers)


#### Route caching

```bash
php artisan route:cache
php artisan route:clear
```




















## Middlewares

[Source](https://laravel.com/docs/11.x/middleware)

Make a middleware
```bash
php artisan make:middleware EnsureTokenIsValid
```

Will generate

```php
class EnsureTokenIsValid
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        if ($request->input('token') !== 'my-secret-token') {
            return redirect('/home');
        }

        return $next($request);
    }
}
```

> It's best to envision middleware as a series of "layers" HTTP requests must pass through before they hit your application. Each layer can examine the request and even reject it entirely.


Perform a task on response

```php
public function handle(Request $request, Closure $next): Response
{
  $response = $next($request);

  // Perform action

  return $response;
}
```


### Registering global middleware

In `bootstrap/app.php`

```php
->withMiddleware(function (Middleware $middleware) {
     $middleware->append(EnsureTokenIsValid::class);
})
```

Add middlewares to a route

```php
# Single route
Route::get('/', function () {
    // ...
})->middleware([First::class, Second::class]);

# To a group of routes
Route::middleware([EnsureTokenIsValid::class])->group(function () {});
```

### Middlewares aliases

In `bootstrap/app.php`

```php
->withMiddleware(function (Middleware $middleware) {
    $middleware->alias([
        'subscribed' => EnsureUserIsSubscribed::class
    ]);
})
```

then, when declaring routes

```php
Route::get('/profile', function () {})->middleware('subscribed');
```

### Middleware parameters

How to give parameters to this middleware ?

```php
public function handle(Request $request, Closure $next, string $role): Response {}
```

With the `:param` syntax

```php
Route::put('/post/{id}', function (string $id) {})
->middleware(EnsureUserHasRole::class.':editor,publisher');
```

> Note: Sometimes a middleware may need to do some work after the HTTP response has been sent to the browser. If you define a terminate method on your middleware and your web server is using FastCGI, the terminate method will automatically be called after the response is sent to the browser






















## Controllers

[Source](https://laravel.com/docs/11.x/controllers)

Make a controller with

```bash
php artisan make:controller UserController
```

Creates

```php
class UserController extends Controller {...}
```

> Controllers are not required to extend a base class. However, it is sometimes convenient to extend a base controller class that contains methods that should be shared across all of your controllers.

### Single Action Controllers

> If a controller action is particularly complex, you might find it convenient to dedicate an entire controller class to that single action. To accomplish this, you may define a single __invoke method within the controller:

```bash
php artisan make:controller ProvisionServer --invokable
```

```php
Route::post('/server', ProvisionServer::class);
```

### Controller Middleware

```php
class UserController extends Controller implements HasMiddleware
{
    /**
     * Get the middleware that should be assigned to the controller.
     */
    public static function middleware(): array
    {
        return [
            'auth',
            new Middleware('log', only: ['index']),
            new Middleware('subscribed', except: ['store']),
        ];

        // or directly with a callback

        return [
          function (Request $request, Closure $next) {
              return $next($request);
          },
        ];
    }
}
```


### Resource Controllers

> Imagine your application contains a Photo model and a Movie model. It is likely that users can create, read, update, or delete these resources.

Create the controller

```bash
php artisan make:controller PhotoController --resource
```

Bind the controller

```php
Route::resource('photos', PhotoController::class);
Route::resources([
    'photos' => PhotoController::class,
    'posts' => PostController::class,
]);

Route::resource('photos', PhotoController::class)->only(['index', 'show']);
Route::resource('photos', PhotoController::class)->except(['create', 'store', 'update', 'destroy']);

# Exclude create and edit
Route::apiResource('photos', PhotoController::class);
```

| Method    | URI                  | Action  | Route name     |
|-----------|----------------------|---------|----------------|
| GET       | /photos              | index   | photos.index   |
| GET       | /photos/create       | create  | photos.create  |
| POST      | /photos 	           | store   | photos.store   |
| GET       | /photos/{photo}      | show    | photos.show    |
| GET       | /photos/{photo}/edit | edit    | photos.edit    |
| PUT/PATCH | /photos/{photo}      | update  | photos.update  |
| DELETE    | /photos/{photo}      | destroy | photos.destroy |

Specifying the Resource Model

```bash
php artisan make:controller PhotoController --model=Photo --resource
```

You may provide the --requests option when generating a resource controller to instruct Artisan to generate form request classes for the controller's storage and update methods:

```bash
php artisan make:controller PhotoController --model=Photo --resource --requests
```

Give `--api` to generate an API resource controller

```
php artisan make:controller PhotoController --model=Photo -resource --api
```

### Nested resources

> Sometimes you may need to define routes to a nested resource. For example, a photo resource may have multiple comments that may be attached to the photo. To nest the resource controllers, you may use "dot" notation in your route declaration:

```php
Route::resource('photos.comments', PhotoCommentController::class);
```

### Shallow nesting

> Often, it is not entirely necessary to have both the parent and the child IDs within a URI since the child ID is already a unique identifier. When using unique identifiers such as auto-incrementing primary keys to identify your models in URI segments, you may choose to use "shallow nesting":

```php
Route::resource('photos.comments', CommentController::class)->shallow();
```

| Verb       | URI                              | Action   | Route Name             |
|------------|----------------------------------|----------|------------------------|
| GET        | /photos/{photo}/comments         | index    | photos.comments.index  |
| GET        | /photos/{photo}/comments/create  | create   | photos.comments.create |
| POST       | /photos/{photo}/comments         | store    | photos.comments.store  |
| GET        | /comments/{comment}              | show     | comments.show          |
| GET        | /comments/{comment}/edit         | edit     | comments.edit          |
| PUT/PATCH  | /comments/{comment}              | update   | comments.update        |
| DELETE     | /comments/{comment}              | destroy  | comments.destroy       |

### Scoping resource routes

[Scoped implicit model binding](https://laravel.com/docs/11.x/routing#implicit-model-binding-scoping)

```php
Route::resource('photos.comments', PhotoCommentController::class)->scoped([
    'comment' => 'slug',
]);
```

### Singleton Resource Controllers

Sometimes, your application will have resources that may only have a single instance. For example, a user's "profile" can be edited or updated, but a user may not have more than one "profile". Likewise, an image may have a single "thumbnail". These resources are called "singleton resources", meaning one and only one instance of the resource may exist. In these scenarios, you may register a "singleton" resource controller:

```php
Route::singleton('profile', ProfileController::class);
Route::apiSingleton('profile', ProfileController::class);
```

| Verb       | URI            | Action  | Route Name     |
|------------|----------------|---------|----------------|
| GET        | /profile       | show    | profile.show   |
| GET        | /profile/edit  | edit    | profile.edit   |
| PUT/PATCH  | /profile       | update  | profile.update |























## Request

```php

$request->path();
$request->url();
$request->fullUrl();
$request->expectsJson();
$request->ip();
$request->isMethod("post");
$request->header("X-Header-Name", "default");
$request->hasHeader("X-Header-Name");


$request->all();
$request->input("users", "default");

$request->collect('users')->each(function (string $user) {
    // ...
});

# When working with forms that contain array inputs, use "dot" notation to access the arrays
$name = $request->input('products.0.name');

# From query string (GET parameters)
$name = $request->query('name', "default");
# Get all GET params
$name = $request->query();

# Work with json
$name = $request->input('user.name');

$name = $request->string("name")->trim();
$perPage = $request->integer('per_page');
$archived = $request->boolean('archived');

# Get a Carbon instance
$birthday = $request->date('birthday');
$elapsed = $request->date('elapsed', '!H:i', 'Europe/Madrid');

# Retrieve enum or null
$status = $request->enum('status', Status::class);

# Retrieve subsets
# Note: The only method returns all of the key / value pairs that you request; however, it will not return key / value pairs that are not present on the request.
$input = $request->only('username', 'password');
$input = $request->except(['credit_card']);


$request->has("name");
$request->has(["name", "email"]); // both values presents
$request->hasAny(["name", "email"]); // any value presents
$request->whenHas("name", function(string $value){});
$request->filled("name"); // Not empty
$request->isNotFilled("name"); // Not empty
$request->missing("name"); // Not empty

$request->mergeIfMissing(['votes' => 0]);

$file = $request->file('photo'); // Returns an UploadedFile

$file->path();
$file->extension();
$file->store("avatars");
$request->file('avatar')->storeAs('avatars', $request->user()->id);
$file->move($directory, $newName); // Succes or throw errors
$request->hasFile('photo');
$request->file('photo')->isValid();
```























## Responses

From a controller :
- Returning a string will be converted into an HTTP response
- Returning an array will be converted into a JSON response

```php
response('Hello World', 200)->header('Content-Type', 'text/plain');
response($content)->withHeaders(['Content-Type' => $type, 'X-Header-One' => 'Header Value', 'X-Header-Two' => 'Header Value']);

response()->view('hello', $data, 200)->header('Content-Type', $type);
response()->json(['name' => 'Abigail', 'state' => 'CA']);

# Send large json by streaming it
response()->streamJson(['users' => User::cursor()]);

# Download a file
response()->download($pathToFile, $name, $headers);
# Streamed download
response()->streamDownload(function () { echo $myLargeContent}, 'laravel-readme.md');


# Display a file
response()->file($pathToFile);

#Response Caching while routing
Route::middleware('cache.headers:public;max_age=2628000;etag')->group(function () {});

redirect('/home/dashboard');
back() // previous page

# You may use the `withInput` to flash the current input's data to the session before redirecting the user to a new location.
# This is typically done if the user has encountered a validation error.
# Once the input has been flashed to the session, you may easily retrieve it during the next request to repopulate the form:
back()->withInput();

redirect()->route('login'); // Named route
redirect()->action([UserController::class, 'index']);
redirect()->action([UserController::class, 'profile'], ['id' => 1]);
redirect()->away('https://www.google.com');

redirect('/dashboard')->with('status', 'Profile updated!');
@if (session('status'))
    <div class="alert alert-success">
        {{ session('status') }}
    </div>
@endif

view('auth.login');
view('greeting', ['name' => 'James']);
```


### Macro response

Defiition

```php
public function boot(): void
{
    Response::macro('caps', function (string $value) {
        return Response::make(strtoupper($value));
    });
}
```

return the response

```php
return response()->caps('foo');
```



















## Views

Laravel supports views with the [Blade templating language](https://laravel.com/docs/11.x/blade),
which supports `.blade.php` files

Create a view with

```bash
php artisan make:view greeting
```

Render a view
```php
view("profile");
# Give data to blade
view("profile", ["name" => "Dale"])

view('greeting')->with('name', 'Victoria')->with('occupation', 'Astronaut');

# Specify subdirectory admin/profile view
view('admin.profile', $data);
```


Utiltitaries
```php
View::exists('admin.profile');
```

Sharing global data to views in a service provider
```php
public function boot(): void
{
    View::share('key', 'value');
}
```

Optimization
```bash
php artisan view:cache
php artisan view:clear
```















## Blade templating

[Source](https://laravel.com/docs/11.x/blade)

Display data in a view
```php
<div>
    Hello, {{ $name }}.
    It is, {{ time() }}.

    <!-- unescaped data -->
    Hello, {!! $name !!}.

    <!-- Use @ to escape any blade directive-->
    Hello, @{{ name }}.

    <!-- Or use @verbatim to completely disable a section rendering -->
    @verbatim
        <div class="container">
            Hello, {{ name }}.
        </div>
    @endverbatim

</div>

<!-- render JSON data -->
<script>
    var app = {{ Js::from($array) }};
</script>
```

Directives

```blade
@if //...
@elseif //...
@else //...
@endif

@unless (Auth::check()) // You are not signed in.
@endunless

@isset($records)// $records is defined and is not null...
@endisset

@empty($records) // $records is "empty"...
@endempty

@auth // The user is authenticated...
@endauth

@guest // The user is not authenticated...
@endguest

# Specify authentication guard
@auth('admin')// The user is authenticated...
@endauth

@guest('admin') // The user is not authenticated...
@endguest

@production // Production specific content...
@endproduction

@env(['staging', 'production']) // The application is running in "staging" or "production"...
@endenv

@hasSection('navigation')
@endif

@sectionMissing('navigation')
@endif

@session('status')
    {{ $value }} // $value value is automatically set
@endsession


@switch($i)
    @case(1)
        @break
    @case(2)
        @break
    @default
        Default case...
@endswitch

@for ($i = 0; $i < 10; $i++)
@endfor

@foreach ($users as $user)
@endforeach

@forelse ($users as $user)
@empty // no users
@endforelse

@while (true)
@endwhile

// Loop control statements are availables
@continue
@break
// ... They can also take a condition
@continue($user->type == 1)
@break($user->number == 5)

// Use the $loop variable in a loop to know where we are in the loop
$loop->index     // The index of the current loop iteration (starts at 0).
$loop->iteration // The current loop iteration (starts at 1).
$loop->remaining // The iterations remaining in the loop.
$loop->count     // The total number of items in the array being iterated.
$loop->first     // Whether this is the first iteration through the loop.
$loop->last      // Whether this is the last iteration through the loop.
$loop->even      // Whether this is an even iteration through the loop.
$loop->odd       // Whether this is an odd iteration through the loop.
$loop->depth     // The nesting level of the current loop.
$loop->parent    // When in a nested loop, the parent's loop variable.

@php
    $isActive = false;
    $hasError = true;
@endphp
<span @class([
    'p-4',
    'font-bold' => $isActive,
    'text-gray-500' => ! $isActive,
    'bg-red' => $hasError,
])></span>
<span @style([
    'background-color: red',
    'font-weight: bold' => $isActive,
])></span>


<input @checked($condition)>
<input @selected($condition)>
<input @disabled($condition)>
<input @readonly($condition)>
<input @required($condition)>

# include a subview
@include("profile.picture")
@include("profile.picture", ["user" => $currentUser])
# Include a view but does not throw an error if inexistant
@includeIf("profile.picture", ["user" => $currentUser])

@includeWhen($condition, $view, $data);
@includeUnless($condition, $view, $data);
@includeFirst(['custom.admin', 'admin'], ['status' => 'complete'])

# Render view name for each $jobs with the variable $job
# render view.empty if $jobs is empty
@each('view.name', $jobs, 'job', 'view.empty')

# Render the subtemplate only once in the rendering cycle
@pushOnce('scripts')
    <script>
        // Your custom JavaScript...
    </script>
@endPushOnce
```

Create a custom directory in service provider
```php
public function boot(): void
{
    Blade::directive('datetime', function (string $expression) {
        return "<?php echo ($expression)->format('m/d/Y H:i'); ?>";
    });
}
```

Use it with
```php
@datetime($var)
```

Specify how blade should `echo` some types in your service provider
```php
Blade::stringable(fn (Money $money) => $money->formatTo('en_GB'));
```

Custom condition in service provider
```php
Blade::if('isAdmin', function (string $user=null) {
    $user ??= $authenticatedUser
    return isAdmin($user);
});

// blade
@isAdmin()
@endisAdmin

@unlessisAdmin
@endisAdmin
```




















## Bundling assets

[Source](https://laravel.com/docs/11.x/vite)

In `vite.config.js`

```js
import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';

// Process every static resource at once
import.meta.glob([
  '../images/**',
  '../scripts/**',
  '../styles/**',
  '../fonts/**',
]);

export default defineConfig({
    plugins: [
        laravel([
            'resources/css/app.css',
            'resources/js/app.js',
        ]),
    ],
});
```

Importing in in a view

```php
@vite(['resources/css/app.css', 'resources/js/app.js'])

<!-- Given build path is relative to public path. -->
@vite('resources/js/app.js', 'vendor/courier/build')

# manually include assets
{!! Vite::content('resources/css/app.css') !!}
```

Run & build assets
```bash
# Run the Vite development server...
npm run dev

# Build and version the assets for production...
npm run build
```

[Work with vue](https://laravel.com/docs/11.x/vite#vue)

Refreshing page on change

```js
export default defineConfig({
    plugins: [
        laravel({
            // ...
            refresh: true,
        }),
    ],
});
```


### Vite Aliases

In your service provider
```php
public function boot(): void
{
    Vite::macro('image', fn (string $asset) => $this->asset("resources/images/{$asset}"));
}
```

In your view
```php
<img src="{{ Vite::image('logo.png') }}" alt="Laravel Logo">
```

### Prefetch

To enable assets prefetching,
write in your service provider

```php
public function boot(): void
{
    # Limit to 3 concurrent file at once
    Vite::prefetch(concurrrency: 3);

    # No limit, download all at once
    Vite::prefetch();
}
```

### View URL

In `.env`

```ini
ASSET_URL=/
```

TODO: See how to configure client caching on assets




















## Url Generation

```php

url("/posts/{$post->id}");

url()->query("/post", ["search" => "laravel"]);

url()->query('/posts', ['columns' => ['title', 'body']]);
// http://example.com/posts?columns%5B0%5D=title&columns%5B1%5D=body

URL::current();
url()->current();
url()->full();
url()->previous();

URL::signedRoute('unsubscribe', ['user' => 1]);
# Exclude the domain
URL::signedRoute('unsubscribe', ['user' => 1], absolute: false);

URL::temporarySignedRoute('unsubscribe', now()->addMinutes(30), ['user' => 1]);

if (! $request->hasValidSignature())
    return response()->view('errors.link-expired', status: 403);

Route::post(...)->middleware('signed');
Route::post(...)->middleware('signed:relative'); // for absolute signed urls

```


















## Session

Your application's session configuration file is stored at `config/session.php`. Be sure to review the options available to you in this file. By default, Laravel is configured to use the `database` session driver.

The session driver configuration option defines where session data will be stored for each request. Laravel includes a variety of drivers:
- `file` - sessions are stored in storage/framework/sessions.
- `cookie` - sessions are stored in secure, encrypted cookies.
- `database` - sessions are stored in a relational database.
- `memcached` / `redis` - sessions are stored in one of these fast, cache based stores.
- `dynamodb` - sessions are stored in AWS DynamoDB.
- `array` - sessions are stored in a PHP array and will not be persisted.


When using `database` driver

```bash
php artisan make:session-table
php artisan migrate
```


### Data manipulation


```php

public function control(Request $request)
{
    # Retrieve
    session("key")
    session("key", "default")
    $request->session()->all();
    $request->session()->get('key', 'default');
    $request->session()->get('key', fn() => 'generate default');
    $value = $request->session()->pull('key', 'default');

    # set
    session(["key" => "default"]);
    $request->session()->put('key', 'value');
    $request->session()->push('user.teams', 'developers');

    $request->session()->exists('key');
    $request->session()->missing('key');


    $request->session()->increment('count');
    $request->session()->increment('count', $incrementBy = 2);
    $request->session()->decrement('count');
    $request->session()->decrement('count', $decrementBy = 2);

    // Put data for this request and the next one only
    $request->session()->flash('status', 'Task was successful!');
    $request->session()->reflash() // Refresh flash duration
    $request->session()->keep(['status']) // Freeze the flash value and put it in session
    $request->session()->now('status', 'Task was successful!'); // Flash only for the current request

    # Delete data
    $request->session()->forget(['name', 'status']);
    $request->session()->flush();
    # Delete all session
    $request->session()->invalidate();

    # Refresh the session Id
    $request->session()->regenerate();
}
```

See [Session blocking](https://laravel.com/docs/11.x/session#session-blocking)  and
[Adding Custom Session Drivers](https://laravel.com/docs/11.x/session#adding-custom-session-drivers) for more























## Form Validation

```php
$validatedData = $request->validate([
    'title' => ['required', 'unique:posts', 'max:255'],
    'body' => ['required'],
    'author.description' => 'required',
    'v1\.0' => 'required',
]);
```

Display errors in a view

```php
@if ($errors->any())
    <div class="alert alert-danger">
        <ul>
            @foreach ($errors->all() as $error)
                <li>{{ $error }}</li>
            @endforeach
        </ul>
    </div>
@endif

<input
    id="title"
    type="text"
    name="title"
    class="@error('title') is-invalid @enderror"
>

```


> When Laravel generates a redirect response due to a validation error, the framework will automatically flash all of the request's input to the session. This is done so that you may conveniently access the input during the next request and repopulate the form that the user attempted to submit.

To retrieve said data
```php
$request->old('title');
```

[Available Validation rules](https://laravel.com/docs/11.x/validation#available-validation-rules)
 - [Accepted](https://laravel.com/docs/11.x/validation#rule-accepted)
 - [Accepted If](https://laravel.com/docs/11.x/validation#rule-accepted-if)
 - [Active URL](https://laravel.com/docs/11.x/validation#rule-active-url)
 - [After (Date)](https://laravel.com/docs/11.x/validation#rule-after)
 - [After Or Equal (Date)](https://laravel.com/docs/11.x/validation#rule-after-or-equal)
 - [Alpha](https://laravel.com/docs/11.x/validation#rule-alpha)
 - [Alpha Dash](https://laravel.com/docs/11.x/validation#rule-alpha-dash)
 - [Alpha Numeric](https://laravel.com/docs/11.x/validation#rule-alpha-numeric)
 - [Array](https://laravel.com/docs/11.x/validation#rule-array)
 - [Ascii](https://laravel.com/docs/11.x/validation#rule-ascii)
 - [Bail](https://laravel.com/docs/11.x/validation#rule-bail)
 - [Before (Date)](https://laravel.com/docs/11.x/validation#rule-before)
 - [Before Or Equal (Date)](https://laravel.com/docs/11.x/validation#rule-before-or-equal)
 - [Between](https://laravel.com/docs/11.x/validation#rule-between)
 - [Boolean](https://laravel.com/docs/11.x/validation#rule-boolean)
 - [Confirmed](https://laravel.com/docs/11.x/validation#rule-confirmed)
 - [Contains](https://laravel.com/docs/11.x/validation#rule-contains)
 - [Current Password](https://laravel.com/docs/11.x/validation#rule-current-password)
 - [Date](https://laravel.com/docs/11.x/validation#rule-date)
 - [Date Equals](https://laravel.com/docs/11.x/validation#rule-date-equals)
 - [Date Format](https://laravel.com/docs/11.x/validation#rule-date-format)
 - [Decimal](https://laravel.com/docs/11.x/validation#rule-decimal)
 - [Declined](https://laravel.com/docs/11.x/validation#rule-declined)
 - [Declined If](https://laravel.com/docs/11.x/validation#rule-declined-if)
 - [Different](https://laravel.com/docs/11.x/validation#rule-different)
 - [Digits](https://laravel.com/docs/11.x/validation#rule-digits)
 - [Digits Between](https://laravel.com/docs/11.x/validation#rule-digits-between)
 - [Dimensions (Image Files)](https://laravel.com/docs/11.x/validation#rule-dimensions)
 - [Distinct](https://laravel.com/docs/11.x/validation#rule-distinct)
 - [Doesnt Start With](https://laravel.com/docs/11.x/validation#rule-doesnt-start-with)
 - [Doesnt End With](https://laravel.com/docs/11.x/validation#rule-doesnt-end-with)
 - [Email](https://laravel.com/docs/11.x/validation#rule-email)
 - [Ends With](https://laravel.com/docs/11.x/validation#rule-ends-with)
 - [Enum](https://laravel.com/docs/11.x/validation#rule-enum)
 - [Exclude](https://laravel.com/docs/11.x/validation#rule-exclude)
 - [Exclude If](https://laravel.com/docs/11.x/validation#rule-exclude-if)
 - [Exclude Unless](https://laravel.com/docs/11.x/validation#rule-exclude-unless)
 - [Exclude With](https://laravel.com/docs/11.x/validation#rule-exclude-with)
 - [Exclude Without](https://laravel.com/docs/11.x/validation#rule-exclude-without)
 - [Exists (Database)](https://laravel.com/docs/11.x/validation#rule-exists)
 - [Extensions](https://laravel.com/docs/11.x/validation#rule-extensions)
 - [File](https://laravel.com/docs/11.x/validation#rule-file)
 - [Filled](https://laravel.com/docs/11.x/validation#rule-filled)
 - [Greater Than](https://laravel.com/docs/11.x/validation#rule-greater-than)
 - [Greater Than Or Equal](https://laravel.com/docs/11.x/validation#rule-greater-than-or-equal)
 - [Hex Color](https://laravel.com/docs/11.x/validation#rule-hex-color)
 - [Image (File)](https://laravel.com/docs/11.x/validation#rule-image)
 - [In](https://laravel.com/docs/11.x/validation#rule-in)
 - [In Array](https://laravel.com/docs/11.x/validation#rule-in-array)
 - [Integer](https://laravel.com/docs/11.x/validation#rule-integer)
 - [IP Address](https://laravel.com/docs/11.x/validation#rule-ip-address)
 - [JSON](https://laravel.com/docs/11.x/validation#rule-json)
 - [Less Than](https://laravel.com/docs/11.x/validation#rule-less-than)
 - [Less Than Or Equal](https://laravel.com/docs/11.x/validation#rule-less-than-or-equal)
 - [List](https://laravel.com/docs/11.x/validation#rule-list)
 - [Lowercase](https://laravel.com/docs/11.x/validation#rule-lowercase)
 - [MAC Address](https://laravel.com/docs/11.x/validation#rule-mac-address)
 - [Max](https://laravel.com/docs/11.x/validation#rule-max)
 - [Max Digits](https://laravel.com/docs/11.x/validation#rule-max-digits)
 - [MIME Types](https://laravel.com/docs/11.x/validation#rule-mime-types)
 - [MIME Type By File Extension](https://laravel.com/docs/11.x/validation#rule-mime-type-by-file-extension)
 - [Min](https://laravel.com/docs/11.x/validation#rule-min)
 - [Min Digits](https://laravel.com/docs/11.x/validation#rule-min-digits)
 - [Missing](https://laravel.com/docs/11.x/validation#rule-missing)
 - [Missing If](https://laravel.com/docs/11.x/validation#rule-missing-if)
 - [Missing Unless](https://laravel.com/docs/11.x/validation#rule-missing-unless)
 - [Missing With](https://laravel.com/docs/11.x/validation#rule-missing-with)
 - [Missing With All](https://laravel.com/docs/11.x/validation#rule-missing-with-all)
 - [Multiple Of](https://laravel.com/docs/11.x/validation#rule-multiple-of)
 - [Not In](https://laravel.com/docs/11.x/validation#rule-not-in)
 - [Not Regex](https://laravel.com/docs/11.x/validation#rule-not-regex)
 - [Nullable](https://laravel.com/docs/11.x/validation#rule-nullable)
 - [Numeric](https://laravel.com/docs/11.x/validation#rule-numeric)
 - [Present](https://laravel.com/docs/11.x/validation#rule-present)
 - [Present If](https://laravel.com/docs/11.x/validation#rule-present-if)
 - [Present Unless](https://laravel.com/docs/11.x/validation#rule-present-unless)
 - [Present With](https://laravel.com/docs/11.x/validation#rule-present-with)
 - [Present With All](https://laravel.com/docs/11.x/validation#rule-present-with-all)
 - [Prohibited](https://laravel.com/docs/11.x/validation#rule-prohibited)
 - [Prohibited If](https://laravel.com/docs/11.x/validation#rule-prohibited-if)
 - [Prohibited Unless](https://laravel.com/docs/11.x/validation#rule-prohibited-unless)
 - [Prohibits](https://laravel.com/docs/11.x/validation#rule-prohibits)
 - [Regular Expression](https://laravel.com/docs/11.x/validation#rule-regular-expression)
 - [Required](https://laravel.com/docs/11.x/validation#rule-required)
 - [Required If](https://laravel.com/docs/11.x/validation#rule-required-if)
 - [Required If Accepted](https://laravel.com/docs/11.x/validation#rule-required-if-accepted)
 - [Required If Declined](https://laravel.com/docs/11.x/validation#rule-required-if-declined)
 - [Required Unless](https://laravel.com/docs/11.x/validation#rule-required-unless)
 - [Required With](https://laravel.com/docs/11.x/validation#rule-required-with)
 - [Required With All](https://laravel.com/docs/11.x/validation#rule-required-with-all)
 - [Required Without](https://laravel.com/docs/11.x/validation#rule-required-without)
 - [Required Without All](https://laravel.com/docs/11.x/validation#rule-required-without-all)
 - [Required Array Keys](https://laravel.com/docs/11.x/validation#rule-required-array-keys)
 - [Same](https://laravel.com/docs/11.x/validation#rule-same)
 - [Size](https://laravel.com/docs/11.x/validation#rule-size)
 - [Sometimes](https://laravel.com/docs/11.x/validation#rule-sometimes)
 - [Starts With](https://laravel.com/docs/11.x/validation#rule-starts-with)
 - [String](https://laravel.com/docs/11.x/validation#rule-string)
 - [Timezone](https://laravel.com/docs/11.x/validation#rule-timezone)
 - [Unique (Database)](https://laravel.com/docs/11.x/validation#rule-unique)
 - [Uppercase](https://laravel.com/docs/11.x/validation#rule-uppercase)
 - [URL](https://laravel.com/docs/11.x/validation#rule-url)
 - [ULID](https://laravel.com/docs/11.x/validation#rule-urlid)
 - [UUID](https://laravel.com/docs/11.x/validation#rule-uuid)





















## Error Handling

[Source](https://laravel.com/docs/11.x/errors)






















## Logging

[Source](https://laravel.com/docs/11.x/logging)

### Writing log messages

```php
Log::emergency($message);
Log::alert($message);
Log::critical($message);
Log::error($message);
Log::warning($message);
Log::notice($message);
Log::info($message);
Log::debug($message);

Log::info('Showing the user profile for user: {id}', ['id' => $id]);
```





















## Artisan Command

Make a command
```bash
php artisan make:command SendEmails
```

```php
class SendEmails extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'mail:send {user}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Send a marketing email to a user';

    /**
     * Execute the console command.
     */
    public function handle(DripEmailer $drip, string $user): void
    {
        $drip->send(User::find($this->argument('user')));

        // exit code
        return 0;
    }
}
```


Another solution to define a command is to declare a closure command

```php
Artisan::command('mail:send {user}', function (string $user) {
    $this->info("Sending email to: {$user}!");
})->purpose('Send a marketing email to a user');;
```

### Isolatable command

> Sometimes you may wish to ensure that only one instance of a command can run at a time. To accomplish this, you may implement the Illuminate\Contracts\Console\Isolatable interface on your command class:

```php
class SendEmails extends Command implements Isolatable {}
```

> By default, Laravel will use the command's name to generate the string key that is used to acquire the atomic lock in your application's cache. However, you may customize this key by defining an isolatableId method on your Artisan command class, allowing you to integrate the command's arguments or options into the key:

```php
public function isolatableId(): string
{
    return $this->argument('user');
}
```

Argument options

```php
'mail:send {user} {--queue=default}' // $this->option("queue")
'mail:send {user} {--Q|queue}'
'mail:send {user*}' // php artisan mail:send 1 2
'mail:send {--id=*}' // php artisan mail:send --id=1 --id=2

$name = $this->choice(
    'What is your name?',
    ['Taylor', 'Dayle'],
    $defaultIndex,
    $maxAttempts = null,
    $allowMultipleSelections = false
);
```

Writing output

```php
$this->info('The command was successful!');
$this->error('Something went wrong!');
$this->line('Display this on the screen');
// Write three blank lines...
$this->newLine(3);


$this->table(
    ['Name', 'Email'],
    User::all(['name', 'email'])->toArray()
);

$users = $this->withProgressBar(User::all(), function (User $user) {
    $this->performTask($user);
});

// Or
$bar->start();
foreach ($users as $user)
{
    $this->performTask($user);
    $bar->advance();
}
$bar->finish();


// Call a command

Artisan::call('mail:send', ['--id' => [5, 13]]);


// Signal interrupting
$this->trap(SIGTERM, fn () => $this->shouldKeepRunning = false);

while ($this->shouldKeepRunning) {
    // ...
}
```



## Broadcasting


[Source](https://laravel.com/docs/11.x/broadcasting)



## Caching

[Source](https://laravel.com/docs/11.x/cache)


## Collections
[Source](https://laravel.com/docs/11.x/collections)

## Concurrency
[Source](https://laravel.com/docs/11.x/concurrency)

## context
[Source](https://laravel.com/docs/11.x/context)
## contracts
[Source](https://laravel.com/docs/11.x/contracts)
## events
[Source](https://laravel.com/docs/11.x/events)
## filesystem
[Source](https://laravel.com/docs/11.x/filesystem)
## http-client
[Source](https://laravel.com/docs/11.x/http-client)
## mail
[Source](https://laravel.com/docs/11.x/mail)
## notifications
[Source](https://laravel.com/docs/11.x/notifications)
## packages
[Source](https://laravel.com/docs/11.x/packages)
## processes
[Source](https://laravel.com/docs/11.x/processes)
## queues
[Source](https://laravel.com/docs/11.x/queues)
## strings
[Source](https://laravel.com/docs/11.x/strings)
## scheduling
[Source](https://laravel.com/docs/11.x/scheduling)

## Authentication
[Source](https://laravel.com/docs/11.x/authentication)
## Authorization
[Source](https://laravel.com/docs/11.x/authorization)
## Verification
[Source](https://laravel.com/docs/11.x/verification)
## Encryption
[Source](https://laravel.com/docs/11.x/encryption)
## Hashing
[Source](https://laravel.com/docs/11.x/hashing)
## Passwords
[Source](https://laravel.com/docs/11.x/passwords)

## Database
[Source](https://laravel.com/docs/11.x/database)
## Queries
[Source](https://laravel.com/docs/11.x/queries)
## Pagination
[Source](https://laravel.com/docs/11.x/pagination)
## Migrations
[Source](https://laravel.com/docs/11.x/migrations)
## Seeding
[Source](https://laravel.com/docs/11.x/seeding)
## Redis
[Source](https://laravel.com/docs/11.x/redis)

## Eloquent
[Source](https://laravel.com/docs/11.x/eloquent)
## Eloquent-relationships
[Source](https://laravel.com/docs/11.x/eloquent-relationships)
## Eloquent-collections
[Source](https://laravel.com/docs/11.x/eloquent-collections)
## Eloquent-mutators
[Source](https://laravel.com/docs/11.x/eloquent-mutators)
## Eloquent-resources
[Source](https://laravel.com/docs/11.x/eloquent-resources)
## Eloquent-serialization
[Source](https://laravel.com/docs/11.x/eloquent-serialization)
## Eloquent-factories
[Source](https://laravel.com/docs/11.x/eloquent-factories)