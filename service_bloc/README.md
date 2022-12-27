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
ServiceRequestedEvent extends ServiceRequested>
    extends ServiceBloc<ServiceRequestedEvent, ServiceState> {
  UserPermissionRequiredServiceBloc(
      {required this.userPermissionLevelCubit,
        EventTransformer<ServiceRequestedEvent>? eventTransformer})
      : super(eventTransformer: eventTransformer);

  final UserPermissionLevelCubit userPermissionLevelCubit;
}

class ProductCheckoutServiceBloc extends UserPermissionRequiredServiceBloc {
  ProductCheckoutServiceBloc(
      {required UserPermissionLevelCubit userPermissionLevelCubit})
      : super(userPermissionLevelCubit: userPermissionLevelCubit);

  @override
  FutureOr<void> onRequest(ServiceRequested event, Emitter<ServiceState> emit) {
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
  List<Object?> get props => [
    locale,
  ];
}

abstract class LocaleRequiredServiceBloc<
ServiceRequested extends LocaleRequiredServiceRequested>
    extends ServiceBloc<ServiceRequested, ServiceState> {}

class ProductDetailServiceRequested extends LocaleRequiredServiceRequested {
  ProductDetailServiceRequested({
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

class ProductDetailServiceBloc
    extends LocaleRequiredServiceBloc<ProductDetailServiceRequested> {

  @override
  FutureOr<void> onRequest(
      ProductDetailServiceRequested event, Emitter<ServiceState> emit) {
    final locale = event.locale;
    // TODO: implement onRequest
  }
}
```

This two examples shows that you can create your own service bloc with extensibility feature.

## Maintainer

[Jack Liu](https://github.com/aaassseee)