
# platops-upgrade-dependencies

Upgrade dependency version X to Y.

## Requirements

-   git
-   gnu make
-   grep
-   sbt
-   (optional) sbt updates plugin for report task
-   sed

## Usage

### Simple case

For a given sbt project we want to upgrade a dependency.

It can be done with a one-liner:

``` {.example}
grep -l \"${GROUPID}\".*\"${ARTIFACTID}\" *.sbt project/*.scala \
| xargs sed -i "s/\"${ACTUALREVISION}\"/\"${REVISION}\"/"
```

Check it is working:

``` {.example}
sbt clean test
```

A real example:

``` {.example}
git clone git@github.com:hmrc/http-verbs-test.git
cd http-verbs-test
sbt clean test
grep -l org.scalatest.*scalatest *.sbt project/*.scala | xargs sed -i "s/\"2.2.6\"/\"3.0.5\"/"
sbt clean test
```

### One task

The previous steps can be run as a sequence of make tasks, where the
makefile clones the repository, performs the upgrade and run the tests.

``` {.example}
make name=http-verbs-test groupid=org.scalatest artifactid=scalatest actualversion=2.2.6 version=3.0.5 setup upgrade test
```

``` {.example}
-  "org.scalatest" %% "scalatest" % "2.2.4",
+  "org.scalatest" %% "scalatest" % "3.0.5",
```

## Edge cases

### Libraries with diferent group id but same version

In this case you want to invoke *strict-upgrade* task instead of *upgrade*.

## Examples

``` {.example}
make name=income-tax-subscription-stubs groupid=uk.gov.hmrc artifactid=bootstrap-play-26 actualversion=0.26.0 version=0.36.0 setup upgrade test
```

``` {.example}
-  private val bootstrapVersion = "0.26.0"
+  private val bootstrapVersion = "0.36.0"
```

## License

This code is open source software licensed under the [Apache 2.0 License]("http://www.apache.org/licenses/LICENSE-2.0.html").
