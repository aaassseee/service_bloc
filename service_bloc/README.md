# service_bloc

Flutter package for service layer implement with bloc architecture

## Usage

Create your own base service bloc

### Example

- User permission

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
  UserPermissionRequiredServiceBloc({required this.userPermissionLevelCubit,
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
    ProductCheckoutServiceRequested,
    String> {
  ProductCheckoutServiceBloc({required UserPermissionLevelCubit userPermissionLevelCubit})
      : super(userPermissionLevelCubit: userPermissionLevelCubit);

  @override
  FutureOr<void> onRequest(ProductCheckoutServiceRequested event, Emitter<ServiceState> emit) {
    if (userPermissionLevelCubit.state == UserPermissionLevel.invalid) {
      // TODO: implement permission error
    }
    // TODO: implement onRequest
  }
}
```

- Locale

```dart
class LocaleRequiredServiceRequested extends ServiceRequested {
  LocaleRequiredServiceRequested({required this.locale});

  final Locale locale;

  @override
  List<Object?> get props => [locale];
}

abstract class LocaleRequiredServiceBloc<
ServiceRequested extends LocaleRequiredServiceRequested,
ResponseData> extends ServiceBloc<ServiceRequested, ResponseData> {}

class ProductDetailServiceRequested extends LocaleRequiredServiceRequested {
  ProductDetailServiceRequested({
    required this.productId,
    required Locale locale,
  }) : super(locale: locale);

  final String productId;

  @override
  List<Object?> get props =>
      [
        locale,
        productId,
      ];
}

class ProductDetailServiceBloc extends LocaleRequiredServiceBloc<
    ProductDetailServiceRequested,
    ProductDetail> {
  @override
  FutureOr<void> onRequest(ProductDetailServiceRequested event, Emitter<ServiceState> emit) {
    final locale = event.locale;
    // TODO: implement onRequest
  }
}
```

This two examples shows that you can create your own service bloc with extensibility feature.

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

## Maintainer

[Jack Liu](https://github.com/aaassseee)