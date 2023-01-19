# service_bloc

Dart package for service layer implement with bloc architecture

## Usage

Create your own base service bloc to reduce redundant code, for example:

- User permission (bloc level)

```dart
enum UserPermissionLevel {
  invalid,
  normal,
  vip,
}

class UserPermissionLevelCubit extends Cubit<UserPermissionLevel> {
  UserPermissionLevelCubit(UserPermissionLevel initialState)
      : super(UserPermissionLevel.invalid);
}

abstract class UserPermissionRequiredServiceBloc<
ServiceRequestedEvent extends ServiceRequested,
ResponseData> extends ServiceBloc<ServiceRequestedEvent, ResponseData> {
  UserPermissionRequiredServiceBloc(
      {required this.userPermissionLevelCubit,
        EventTransformer<ServiceRequestedEvent>? eventTransformer})
      : super(eventTransformer: eventTransformer);

  final UserPermissionLevelCubit userPermissionLevelCubit;
}

class ProductCheckoutServiceRequested extends ServiceRequested {
  const ProductCheckoutServiceRequested(this.productIdList);

  final List<String> productIdList;

  @override
  List<Object?> get props => [productIdList];
}

class ProductCheckoutServiceBloc extends UserPermissionRequiredServiceBloc<
    ProductCheckoutServiceRequested, String> {
  ProductCheckoutServiceBloc({
    required UserPermissionLevelCubit userPermissionLevelCubit,
    required this.repository,
  }) : super(userPermissionLevelCubit: userPermissionLevelCubit);

  final ProductRepository repository;

  @override
  FutureOr<void> onRequest(
      ProductCheckoutServiceRequested event, Emitter<ServiceState> emit) async {
    if (userPermissionLevelCubit.state == UserPermissionLevel.invalid) {
      // TODO: implement permission error
    }
    // TODO: implement onRequest
  }
}
```

- Locale (event level)

```dart
class LocaleRequiredServiceRequested extends ServiceRequested {
  const LocaleRequiredServiceRequested({required this.locale});
  
  final Locale locale;
  
  @override
  List<Object?> get props => [locale];
}
  
class ProductDetailServiceRequested extends LocaleRequiredServiceRequested {
  const ProductDetailServiceRequested({
    required this.productId,
    required Locale locale,
  }) : super(locale: locale);
  
  final String productId;
  
  @override
  List<Object?> get props => [
    locale,
    productId,
  ];
}
  
abstract class LocaleRequiredServiceBloc<
ServiceRequested extends LocaleRequiredServiceRequested,
ResponseData> extends ServiceBloc<ServiceRequested, ResponseData> {}
  
class ProductDetailServiceBloc extends LocaleRequiredServiceBloc<
    ProductDetailServiceRequested, ProductDetail> {
  ProductDetailServiceBloc(this.repository);

  final ProductRepository repository;
  
  @override
  FutureOr<void> onRequest(
      ProductDetailServiceRequested event, Emitter<ServiceState> emit) async {
    final locale = event.locale;
    // TODO: implement onRequest
  }
}
```
> This two examples shows that you can create your own service bloc with extensibility feature.

Implement the pagination easily with built-in pagination service bloc

- Open library author search

```dart
class OpenLibraryAuthorSearchServiceRequested
    extends PaginationServiceRequested {
  const OpenLibraryAuthorSearchServiceRequested(this.keyword);

  final String keyword;

  @override
  List<Object?> get props => [
        keyword,
      ];
}

class OpenLibraryAuthorSearchReloadServiceRequested
    extends OpenLibraryAuthorSearchServiceRequested with PaginationReload {
  OpenLibraryAuthorSearchReloadServiceRequested(super.keyword);
}

class OpenLibraryAuthorSearchServiceBloc
    extends PageBasedPaginationListServiceBloc<
        OpenLibraryAuthorSearchServiceRequested,
        OpenLibraryAuthorSearchResult> {
  OpenLibraryAuthorSearchServiceBloc(this.repository);

  final OpenLibraryRepository repository;

  @override
  FutureOr<List<OpenLibraryAuthorSearchResult>> onPaginationRequest(
      OpenLibraryAuthorSearchServiceRequested event, num page) async {
    // TODO: implement onRequest
  }
}
```

## Live Template

Generating boilerplate for service bloc

You can generate service bloc boilerplate code easily by using live template, check
out [setup](https://www.jetbrains.com/help/idea/creating-and-editing-live-templates.html) to create your own shortcut
with the following code.

```
class $SERVICE_NAME$ServiceRequested extends ServiceRequested {
  const $SERVICE_NAME$ServiceRequested();
  
  @override
  List<Object?> get props => [];
}

class $SERVICE_NAME$ServiceBloc extends ServiceBloc<$SERVICE_NAME$ServiceRequested, $RETURN_TYPE$> {

  @override
  FutureOr<void> onRequest($SERVICE_NAME$ServiceRequested event, Emitter<ServiceState> emit) async {
    $END$// TODO: implement service call
  }
}
```

For more example detail, please check out [example](https://github.com/aaassseee/service_bloc/tree/main/service_bloc/example/lib/).

## Maintainer

[Jack Liu](https://github.com/aaassseee)