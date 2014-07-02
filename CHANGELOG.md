# WitRuby Changelog
All changes to this API wrapper will be documented in this file. This file follows the guidelines explained over at http://keepachangelog.com/.

## 1.1.1 - 2014-06-30
### Added
- As the wrapper defaults to the newest Wit.AI API version, new additions make WitRuby compatible.
- Added instance method, `entities`, for class Message that returns entities in result of a query
- Added optional argument, index, for methods `confidence`, `entities`, `entity_names`, and `intent` that returns each value at the desired index. Defaults at 0 if no index is passed (this is in response to Wit returning more than one outcome).
- Added ability to pass queries with spaces.
- Default to RSpec 3.

### Deprecated
- New Wit.AI version deprecates some specific methods as results has been changed.

### Removed
- Nothing

### Fixed
- Tests that fail due to defaulting to the newest RSpec (being RSpec 3). Now defaults to RSpec 3 and fixed accordingly.

## 1.1.0 - 2014-06-15

### Added
- Implemented API call to send a specific sound file containing a message over to wit.ai (GET).

### Deprecated
- Nothing.

### Removed
- Nothing.

### Fixed
- Changed testing suites to use a general instance for testing over at wit.ai so all developers can get passing tests.

## 1.0.1 - 2014-06-06

### Added
- Raise an error if a sent message has a length that is not between 0 to 256.

### Deprecated
- Nothing.

### Removed
- Nothing.

### Fixed
- Nothing.

## 1.0.0 - 2014-06-03

### Added
- Yay! 1.0.0 for no reason! (Kinda.)
- Error checking to make sure input parameters to the session are correct.

### Deprecated
- Adding expressions does not use a given BodyJson parameter and instead, requires the use of just the name of the entity, value, and new expression.

### Removed
- Nothing.

### Fixed
- Nothing.

## 0.0.3 - 2014-05-21

### Added
- Implemented getting array of entities from instance (GET).
- Implemented getting a specific entity from its name/id (GET).
- Implemented creation of entities (POST).
- Implemented the ability to update entities given the ID (PUT).
- Implemented deletion of entities (DELETE).
- Implemented addition of values (POST).
- Implemented deletion of values (DELETE).
- Implemented addition of expressions (POST).
- Implemented deletion of expressions (DELETE).
- New class definition for post / put calls assistance called BodyJson. Helps with JSON generation.

### Deprecated
- Changed required Ruby version from 1.8.7 to 1.9.3.

### Removed
- Nothing.

### Fixed
- Nothing.

## 0.0.2 - 2014-05-15

### Added
- Implemented API call to get specific information from a sent message from it's given ID (GET).
- Intent specific API calls functional (GET).
- Change results to be returned as specific objects that inherit from the original class Result. Message, Intent, Entity, Expression are the specific wrappers for results.
- Changed description in gemspec.
- Error check so that only specific results can be refreshed. Refreshable objects are ones that
  are directly returned from session calls.

### Deprecated
- Nothing.

### Removed
- Nothing.

### Fixed
- Nothing.

## 0.0.1 - 2014-05-08

### Added
- Implemented connection with wit.ai API and sending a text message (GET).

### Deprecated
- Nothing.

### Removed
- Nothing.

### Fixed
- Nothing.
