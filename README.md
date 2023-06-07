# Flutter Application Template
Template with commonly used packages and some approach for develop mobile application.

# Features
- error gathering by `sentry`
- display error for user from any place in app with `DisplayedException` class
- preconfigured push `onesignal`
- declarative routing and preconfigured support of deeplinks by `autoroute`
- perfect match of di `riverpod` and immutable data `freezed`
- persistent states integrated with di by `riverpod_persistent_state`
- localization based by `slang` with language select widget and persistent locale
- networking designed for use with `riverpod` based on `dio` with: cache, retries, error processing, auto cancel and authorized requests
- simple persistent global authorization
- guards for screens and widgets by `guarded_core` with deep integration with error processing and networks
- app updates  `upgrader`, `in_app_update`
- example of preconfigured splash screen and launcher icons generation
- persistent app themes 
- simple ci pipeline with specific build process and flavor support. that also support android sign and deploy
- `.vscode` snippets and configuration for better dev expirience

# Initialize new project

Initialize new project from template repository

```sh
git clone https://github.com/iliser/flutter-template-squashed
./tool/init_template.sh 
# then define app config in build_config.json
```

# Before start develop
To generate files required for build
```sh
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter pub run the_splash # need for generate assets/generated files
```

# Build config
In `build_config.json` file you must define application name, application id and can define deep link host

Info from that file used in build process to configure app.

# Build
To build apk fill build_config.json and run `tool/build.sh` that generate release apk with tmp sign, all changes in files after build must be discarded and not store in git, otherwise you can't reconfigure app in future
```sh
./tool/build.sh # to build the app
```

Also you can only apply config
```sh
./tool/prebuild.sh
```

# Dev flow.

## Filestructure (Not complete)
See [`file_structure.md`](./file_structure.md)

## Navigation and routes
Application navigation is URL based navigation. That use [`auto_route`](https://pub.dev/packages/auto_route/changelog) to generate material routes and proccess navigation and deep links.

### To define new route goto `router.dart`

```dart
@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[
    AutoRoute(page: InitialScreenGuarded, initial: true),
    AutoRoute(page: LoginScreen, path: '/login'),
    // place new routes here
    // All AutoRoute generate route with name based on page name, 
  ],
)
class $AppRouter{}
```

###  Screen defination
To use widget as route just annotate all required parameters as `@QueryParam` or `@PathParam`
```dart
class ExampleScreen extends StatelessWidget{
    ExampleScreen(
        @QueryPram() this.queryParam,
        @PathParam() this.pathParam,
    ):super();
    // prefer to use String? type as param other param sometimes work incorrect :[
    final String? queryParam;
    final String? pathParam;
}
```

More documentation see on [`auto_route` page](https://pub.dev/packages/auto_route/changelog)


## State managment

### Models

Prefer to use immutables models and NOT modify data in place, cause it follow some hard detected errors and strange behavior.

Prefer NOT implement business logic inside DATA model. Extract it to provider or widget layer. This does't affect common getters, and setters only some complicated logic.

Why to use immutables and not just classes?
- Mutable state is a pain in ass cause you can't be sure that model does't change from other code
- Immutable models is a good mix with `Stream`, `Cubit` and `ValueNotifier`, when you can just `copyWith` previos value
- Discriminated union stops downcasting models like `object is DerivedClass` and force to proceed all types through `when` or `map`


Immutable models implemented through [`freezed`](https://pub.dev/packages/freezed), that generate code for `copyWith` method, json serialization methods, and discriminated union model

For easy generation project has snippet `fi_model` for model with imports, and `f_model` for just model.
```dart
// simple model 
@freezed
abstract class CategoryModel implements _$CategoryModel {
  // need to use getter, setter and methods inside class
  const CategoryModel._();

  const factory CategoryModel(
    String id, 
    String? title,[
    @Default([]) // @Default define default value for optional fields
    List<CategoryModel> childs,
  ]) = _Data; // _Data can be any class name and can be accesed directly

  // force to generate json serialization code
  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}

```

Discriminated union model can contain different data types, and discriminator type.

Also generate: `map`, `maybeMap`, `when`, `maybeWhen` functions that provide ability to map concrete union type to other data and force to process all types.
```dart
// discriminated union
@Freezed(
  unionKey: 'type', // key in json which contain discriminator 
  unionValueCase: FreezedUnionCase.kebab, // case of discriminator
) // or just @freezed
abstract class DeliveryOptionDataModel implements _$DeliveryOptionDataModel {
  const DeliveryOptionDataModel._();

  //const factory DeliveryOptionDataModel.discriminator(String configId) = _ImpName;
  const factory DeliveryOptionDataModel.delivery(String configId,String address) = _Delivery;
  const factory DeliveryOptionDataModel.self(String configId) = _Self;

  // configId can be accesed directly because it's declared in all types
}
```

### DI / State managment

Minimal dependency injection point is provider from [`riverpod`](https://riverpod.dev/docs/getting_started)
```dart
final searchStringProvider = StateProvider((_) => '');

```

For data that depend on other and can easy rebuild without side effects you can write something like that. 
```dart

final productsFilterProvider = Provider((ref){
  final search = ref.watch(searchStringProvider);
  final category = ref.watch(categoryProvider);

  return ProductFilter(searchCubit, categoryCubit);
});

```


### Work with remote data

In simple case to load all data for the once
```dart
final newsProvider = FutureProvider((ref) => NewsNetwork.from(ref).getNews());

// for use it in widget prefer to use GuardedWidget or GuardedScreen
// that process loading and error states and allow work with data like it simple values
class NewsList extends GuardedWidget{
  @override
  List<WidgetGuard> get guards => [
        HttpGuard(newsProvider),
      ];

  @override
  Widget build(BuildContext context,WidgetRef ref){
    // never throw cause of guard process error and loading
    final List<NewsModel> news = ref.watch(newsProvider).value!;
    // build ur news list
  }
}

```

When you need reload data based on some other data.
```dart
final currentCityShopsProvider = FutureProvider((ref) {
  final cityId = ref.watch(currentCityProvider);
  return ShopsNetwork().getShops(cityId);
}
```

For authorized data request just use
```dart
final userProvider = FutureProvider((ref) async {
  // future resolves only when authorization is properly loaded
  // if authorization is `AuthorizationValue.unathorized` network throw exception on requests
  final network = await awaitNetwork(ref,UserNetwork.value);
  return network.getUserData();
}
```

If request data uses only in some screens and can be disposed after usage prefer to use. 
That allow automatic cancel request when provider disposed. 
When provider is not autodispose provider requestt never canceled automaticly
```dart
final newsProvider = FutureProvider.autoDispose((ref) => NewsNetwork.from(ref).getNews());
```


### PersistentValue
Provide interface to store data on user device and manipulate with it through `update` function. 

If you need to cache network data **Prefer** use `FutureProvider` wit http cache `dio_cache_interceptor`, cause it's not need to rewrite cache invalidation, and can easyly controlled from server side.


Simple example, by default use `HiveStore` that store object as binary data
```dart
final tokenProvider = PersistentStateProvider<AuthorizationValue>(
  store: HiveJsonStore(
    defaultValue: () => const AuthorizationValue.unauthorized(),
    boxName: 'authorization_token',
    fromJson: (json) => AuthorizationValue.fromJson(json),
  ),
);

// to update value, update accept updated fn that map old value to new
// that is good combine with copyWith from freezed
await ref
    .read(tokenProvider.notifier)
    .update((oldValue) async => AuthorizationValue.bearer('new_token'));
```

Or you can use `HiveStringStore` to store object as string
```dart
// prefer to use http cache on case like that when data duplicated on server and it's not critical to application to work offline with all features, in that particular case user data store only on device
final userInfoProvider = PersistentStateProvider<UserInfoModel>(
  store: HiveStringStore(
    defaultValue: () => UserInfoModel.empty
    encode: (v) => jsonEncode(v.toJson()),
    decode: (v) => UserInfoModel.fromJson(jsonDecode(v)),
    boxName: 'userInfo',
  )
);
```

### Networking 
To work with backend you can use 2 base classes `NetworkBase` and `AuthNetworkBase`, it's baseUrl configured in `config`. It's provide `dio` getter that represent configured dio instance



Simple usage
```dart
class NewsNetwork extends NetworkBase{
    NewsNetwork();
    NewsNetwork.from(Ref ref):super.from(ref);

    // you can define cache options to cache request 
    // or use one of predefined class with cache 
    // - CacheNetworkBase
    // - FileCacheNetworkBase
    // - AuthCachedNetworkBase
    CacheOptions? get cacheOptions => dbCacheOptions;
    Future<List<NewModel>> getNews() async {
        final ans = await dio.get('/news');
        return (ans.data as List)
            .map((e) => NewsModel.fromJson(e))
            .toList();
    }
}
```

Usage with authorization
```dart
// bearer auth token bloc implements NetworkDataProvider that provide additional headers
class UserOrderNetwork extends AuthNetworkBase {
  UserOrderNetwork.of(WidgetRef ref) : super.of(ref);
  UserOrderNetwork.value(AuthorizationValue value) : super.value(value);


  Future<OrderCreationModel> createOrder(OrderCreationModel order) async {
    final ans = await dio.post('/order/', data: order.toJson());
    return OrderCreationModel.fromJson(ans.data);
  }
}
```

### Lazy map stream to sliver
To map stream to scrollable list or grid you can use [`sliver_stream_builder`](https://pub.dev/packages/sliver_stream_builder) package.

That package support pause when screen is filled with data, display error with retry button and optimize items rebuild.

Example how to map paginated network ressource to stream
```dart
class NotificationNetwork extends AuthNetworkBase {
  /// for use in callbacks
  /// get the netwrok instance without listening token change
  NotificationNetwork.of(WidgetRef ref) : super.of(ref);

  /// for use with `awaitNetwork(ref,Network.value)`
  ///
  /// create network with given authorization value
  NotificationNetwork.value(AuthorizationValue value) : super.value(value);


  Stream<NotificationModel> getNotifications() {
    var page = 0;
    var cur = 0;
    late Response ans;
    num? total;

    return dataStreamWrapper(() async {
      if (cur < (total ?? cur)) return null;
      ans = await dio.post('/Notifications', data: {'page': page});

      total ??= (ans.data['total'] as num);

      cur += (ans.data['notifications'] as List).length;
      page += 1;

      return (ans.data['notifications'] as List)
          .map((e) => NotificationModel.fromJson(e))
          .toList();
    });
  }
}

// ... in build ...
SliverStreamBuilder(
  stream: NotificationNetwork.of(ref).getNotifications(),
  builder: (ctx,item) => NotificationItem(item),
)
```

### Localization
For localization used [`slang`](https://pub.dev/packages/slang) package.

All strings must be defined in `lib/strings.i18n.json` file and used in code like.
```dart
import 'package:template/template_modules/globals.dart';
// ... in widget ...
Text(L.someString);
```

To add new language just add file `lib/strings_${languageCode}.i18n.json` with same structure as `lib/strings.i18n.json`

