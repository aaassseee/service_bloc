## 4.0.0+1

* update dependencies

## 3.0.1

* migrate to dart 3.0 syntax

## 3.0.0+1

* service bloc isFirstLoaded getter remove visibleForTesting annotation

## 3.0.0 (breaking change)

* (breaking change) refactor object and list pagination object, number and cursor base pagination
  with [bridge design pattern](https://refactoring.guru/design-patterns/bridge)

## 2.0.0 (breaking change)

* (breaking change) changed mergedData from covariant parameter initialization parameter
* (breaking change) changed the initial mergedData fit from the type which is provided by user

## 1.0.0 (breaking change)

* (breaking change) rename responseData to mergedData
* remove parameter isFirstPage
* fixed incorrect page number due to page number added 1 after request

## 0.1.0

* add overridable updateNextPageNumber method to base pagination bloc, allowing to override the next page flow

## 0.0.1+3

* update README.md
* update example

## 0.0.1+2

* update example

## 0.0.1+1

* add test
* add documentation

## 0.0.1

* initial release
