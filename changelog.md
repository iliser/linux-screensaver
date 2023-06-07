# [3.10.1] - 2023-05-24

feat:
- GenericHttpException for unproceed codes
- GuardHttpErrorWidgetConfiguration

# [3.10.0] - 2023-05-15

feat:
- update freezed code snippets
deps: 
- migrate to flutter 3.10.0

# [3.9.4] - 2023-05-03

fix: 
- bump guarded core

# [3.9.3] - 2023-05-01

feat:
- network data stream extension

fix:
- onesignal push notification `fallbackToSettings: false`

# [3.9.2] - 2023-04-09

fix:
- github build, set correct

feat:
- send artifacts to telegram

# [3.9.1] - 2023-04-08

fix: 
- add monochome adaptive icon

# [3.9.0] - 2023-04-08

feat:
- add riverpod lints

deps: Major dependency updates
- migrate to autoroute 6.0
- migrate to sentry 7.4.0
- migrate to dio 5.0.0
- migrate to sliver_stream_builder 0.4.0

# [3.8.0] - 2023-03-31

feat: 
- rework AuthNetwork creation, replace with ParametrizedNetwork concept. That allow to implicitly provide parameters to network constructor. Reduce new network type declaration boilerplate to define `args` getter and `Network.value` constructor


# [3.7.0] - 2023-03-06

feat:
- migrate to guarded_core 0.4.0


# [3.6.4] - 2023-01-20

fix:
- improve custom dialog animation: animate blur, curves for 
- multiple custom dialog pop 
- theme select border to prevent 
- language select icon alignment
- move config.enableSentry after DisplayedException handle

# [3.6.3] - 2023-01-18

feat:
- hive serialization utils

fix:
- listenFuture and AuthNetwork creation
- HttpError 422, 429, 503 incorrect fromResponse
- CustomDialogPage avoid system padding
- language select dialog not pop after locale change
- hive generator
- any_map and exlude_if_null for json serializable
- add more strict lint rules and fix warnings

example:
- localized network example, show 'dependency injection' into network class

# [3.6.2] - 2023-01-16

feat(network error):
- allow customize from which field error message was been extracted

# [3.6.1] - 2023-01-15

feat(network):
- network integrations that allow to modify or rewrite dio instance

# [3.6.0] - 2023-01-15

feat:
- predefined dialogs use CustomRoute
- manage translations with riverpod
- sentry tracing

fix: 
- template_modules set to readonly in initialize_template
- sentry now enable based only on config

## [3.5.5] - 2023-01-07

feat: 
- remove unused string.i18n.json file
- watch localization task
- add about dialog
fix: 
- item select dialog border zero

## [3.5.4] - 2023-01-05

fix: 
- selected theme watch

## [3.5.3] - 2023-01-05

feat(network):
- server sent event for network
- add oled dark theme
- animated item select dialog

## [3.5.2] - 2023-12-07

feat(template)
- initialize template script

fix:
- pubspec version

## [3.5.1] - 2022-12-07

feat(network):
- timeouts now is duration
- allowRetry getter
- can retry form data request with `MultipartFileRecreatable`
- update major deps

## [3.5.0] - 2022-12-01

feat(gradle):
- update gradle version
- update onesignal integration
- add `onesignalDefaultExternalUserId` to config for dev purpose

## [3.4.4] - 2022-11-29

feat(mixer):
- rewrite github actions with mixer

## [3.4.3] - 2022-11-29

fix:
- enable 'unawaited_future' linter rule 
- use splash screen as autorouter placeholder

## [3.4.2] - 2022-11-24

feat: 
- replace `awaitNetwork` with `Network.value.watch`
- simplify network provider creation with riverpod style providers

## [3.4.1] - 2022-11-10

feat:
- add onLongPress, onDoubleTap to `TapableBox`

## [3.4.0] - 2022-11-03

feat:
- DisplayedException now has `errorSnackBar` for more control over error visual

## [3.3.1] - 2022-11-03

fix: 
- splash generation error
- HttpGuard log error in debugMode
deps:
- bump all dependencies


## [3.3.0] - 2022-09-18

feat(build):
- rewrite all utility scripts to dart and extract to `mixer` project
- preloadImage optional decode params
fix: 
- preload image double complete error

## [3.2.0] - 2022-08-20

feat(filestructure):
- update docs
- complete refactor of filescruture
- small global authorization refactor

## [3.1.0] - 2022-08-20

feat:
- extract riverpod_persistent_state to separate package
- extract guarded_core to separate package
- SafeRetryInterceptor that does't retry if data is FormData
- network disposeToken that allow cancel dio request when provider was disposed
- auto register network `dispose` for autodispose providers
- CancelTokenExtension for advanced use cases
- change localization for packages
fix: 
- global authorization example blink


## [3.0.4] - 2022-08-04

fixes:
- sanitize ./tool scripts
- bump deps

## [3.0.3] - 2022-07-19

feat(error processing):
- add 429, 503 http error process
fix: 
- vscode localization task
- replace "do_not_display" hint with const `DisplayedException.doNotDisplayHint` symbol

## [3.0.2] - 2022-07-15

feat(branding):
- add massa branding: icons, splash, name, id
fix: 
- migrate from fast_i18n to slang

## [3.0.0] - 2022-07-14

feat(flutter 3.0):
- bump dependencies to support flutter 3.0

## [2.6.1] - 2022-06-05

feat(localization improvment):
- add system language variant
- change translation sync mehtod
- languageProvider rewrite to PersistentSyncedStateProviders
- change visual to match theme select

fix:
- PersistentSyncedStateProviders nullable type process error
- disable automatic deploy to playmarket beta and enable github releases

## [2.6.0] - 2022-06-05

feat(theme improvment):
- add place for initialize PersistentSyncedStateProviders in main
- add core for theme registration, change functionality
- add persistent theme, and widget for theme select
- load theme before `runApp` so application load with correct visual
- add MASSA theming

fix:
- temporary lock flutter version to 2.10.5
- fix sign.sh missing `set -e` 

## [2.5.4] - 2022-06-05

feat(persistent store):
- add PersistentSyncedStateStore provider

## [2.5.3] - 2022-05-16

feat(persistent store):
- add PersistentStateProvider.createStore for create store from riverpod ref
- add FutureProxyStore for simplify store created asyncroniosly like store dependent on other `PersistentStateProvider`
- delete riverpod utils

feat(network|snippet): snippets for requests
- add `authRequest`, `authPRequest` code snippets

## [2.5.2] - 2022-05-07

feat(persistent store):
- rename PersistentValueProvider to PersistentStateProvider to consist with riverpod StateStore
- add PersistentMemoryStore for testing
- some PersistentStoreBase improvments


## [2.5.1] - 2022-04-30

feat(network):
- add auth request provider snippets

## [2.5.0] - 2022-04-30

feat(network): correct auth network incorrect behavior when used in future provider, this provider return `UnathorizedError` when authorizationProvider in loading state
- remove `AuthNetwork.watch` constructor 
- add `AuthNetwork.value` for creation with authorization value
- add `awaitNetwork(ref,AuthNetwork.value)` for use network in future providers
- change `AuthNetwork.authorizationProvider` to use `AsyncValue<AuthorizationValue>` 
- update code snippets

## [2.4.0] - 2022-04-29

feat(ci/cd):
- add screenshot generation for android
- add deploy to play store beta track

## [2.3.0] - 2022-04-28

feat(ci/cd):
- split build workflow to jobs
- add version fallback for non tags builds
- configure jobs cache

## [2.2.0] - 2022-04-28

feat(network):
- clean network base classes code
- improve network base classes docs
- add retries

## [2.1.2] - 2022-04-27

fix:
- fix integration test infinite "loading"

## [2.1.1] - 2022-04-20

Deps:
- bump deppendencies versions

## [2.1.0] - 2022-04-20

Feat: network and authorization refactor that prevent incorect usage
- new class AuthorizationValue for store authorization tokens of different types
- network now construct through `.of` and `.watch` factories that must prevent incorect usage and allow to wipe current user data when token change through rebuild with new token
- allow authNetwork subclass to change override `authorizationProvider`
- authorization module now accept logout path and check function
- authorization module provide isAuthorized provider


Minor: 
- add vscode extension recommendations for [riverpod snippets](https://marketplace.visualstudio.com/items?itemName=robert-brunhage.flutter-riverpod-snippets)
- add vscode persistent provider snippet: `persistentProvider`, `persistentJsonProvider`
- add vscode guarded widgets snippets: `guardedWidget`, `guardedScreen`
- add vscode network snippets: `authNetwork`, `network`

## [2.0.1] - 2022-04-20

Fix: 
- ios emulator bug when app is froze

## [2.0.0] - 2022-04-04

Feat: global refactoring
- refactor and add guard system
- extract guards system to module
- add two widget base clases `GuardedScreen`, `GuardedWidget`
- improve http error processing
- improve http error messages
- extract persistent store to module
- add multiple examples of guards usage

Fix:
- persistent provider now catch error on update
- github build trigger

## [1.4.0] - 2022-03-01

Feat: flutter 2.10.0 migration

## [1.3.0] - 2022-02-07

Feat: persistent value based on StateNotifier

- remove bloc dependency
- rewrite persistent value to StateNotifier (yep another place for bugs)
- rename persisten store 
- add close method to store
- find locale change trouble see. login_location.dart:35

## [1.2.1] - 2021-12-16

Fix:
- linter config
- tapable box fit option
- bump dart sdk version

## [1.2.0] - 2021-12-16

Feat:
- extract splash screen

## [1.1.1] - 2021-12-14

Fix:
- gihtub actions app version

## [1.1.0] - 2021-12-14

Improve build:
- build use upload key from secres 
Fixes:
- build config fixes, speed up build runner
- build create native splash now call only once

## [1.0.2] - 2021-12-14
Fixes:
- change dependencies from git to pub
## [1.0.1] - 2021-12-10
Fixes:
- flutter 2.8.0 support

## [1.0.0] - 2021-12-10

Riverpod migration:
- migrate code from bloc + provider to riverpod
- global project structure rework
- update readme

Minor fixes: 
- changelog normalization


## [0.4.6] - 2021-12-03

Improve build:
- application version fallback
- extract splash config and build second splash based on it
- change locale store from HiveAdapter to HiveStringStore
- rewrite replace scripts to dart
- ./tool/build.sh - save working directory state
- preloadImage work for any image provider

Fixes:
- fix rebuild after locale change

## [0.4.5] - 2021-11-03

- update deps to remove warnings
- update gradle version
- change baseApiUrl check method [cause assert does't work in debug **wtf?**]

## [0.4.4] - 2021-11-03

- improve dio error processing

## [0.4.3] - 2021-10-28

- application config refactor
- move launcher icons to `assets/config/launcher_icon.png`

## [0.4.2] - 2021-10-27

- change splash creation flow `tool/create_native_splash.sh`
- seamless splash transition from native to second
- preload second splash to remove flashes
- light/dark theme support for second splash

## [0.4.1] - 2021-10-01

- fix: application name split on space

## [0.4.0] - 2021-09-30

- Add docs and fix problem with build on non tag commit