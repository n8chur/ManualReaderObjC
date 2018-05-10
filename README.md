# ManualReaderObjC

ManualReaderObjC parses fixtures generated by [Manual](https://github.com/Automatic/Manual) and provides methods to easily get example JSON payloads for particular object schemas, get request and response information for endpoints, and even stub request responses (powered by [Nocilla](https://github.com/luisobo/Nocilla)).

## Usage

Stub a network request/response.

```objective-c
// Use a test target class to get the bundle which contains the test fixtures.
NSBundle *bundle = [NSBundle bundleForClass:SomeTestTargetClass.class];
NSString *path = @"Fixtures/example.automatic.com";
AUTAPIServiceFixtures *serviceFixtures = [AUTAPIServiceFixtures fixturesInBundle:bundle atPath:path];

[serviceFixtures stubRequestWithMethod:@"GET" pathTemplate:@"test/{test_id}/" statusCode:200];

// Perform network request and verify response is valid.
```

Get example JSON for model generation testing.

```objective-c
// Where "Base_A" is the name of the object schema being tested.
NSDictionary *json = serviceFixtures.examples[@"Base_A"];

// Perform JSON object deserialization and validate fields.
```

Get a type safe representation of an endpoint fixture.

```objective-c
AUTAPIFixtureEndpointInfo *endpointInfo = serviceFixtures.endpoints[@"test/{test_id}/"];
AUTAPIFixture *fixture = endpointInfo[@"GET-200"];

// Now we can query values within the test fixture with type safety.
// For example:
NSDictionary<NSString *, id> *responseJSONBody = fixture.response.jsonBody;
```

### Installing

ManualReaderObjC supports [Carthage](https://github.com/Carthage/Carthage).

Setup the project by running:
```bash
$ make bootstrap
```

## Built With

* [Nocilla](https://github.com/luisobo/Nocilla) - HTTP stubbing for iOS and Mac OS X

## Contributing

Fork the repository and and open a pull request to the master branch.

Please report any issues found on Github in the issues section.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/Automatic/ManualReaderObjC/tags).
