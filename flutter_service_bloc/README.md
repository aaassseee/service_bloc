# flutter_service_bloc

Flutter package for service layer implement with bloc architecture

## Usage

### Bloc

For bloc usage please ref to [service_bloc](https://github.com/aaassseee/service_bloc/blob/main/service_bloc/README.md).

### Listener

- Dialog

```dart
ServiceBlocListener<ProductCheckoutServiceBloc, ProductCheckoutServiceRequested, String>(
  onLoading: (context, state, event) => showLoading(),
  onResponded: (context, state, event) => hideLoading(),
  onFailed: (context, state, event, error) => showErrorDialog(context, error),
),
```

- Navigate

```dart
ServiceBlocListener<ProductCheckoutServiceBloc, ProductCheckoutServiceRequested, String>(
  onSucceed: (context, state, event, response) => Navigator.of(context).pushNamed(<your route>),
),
```

- Bloc communication

```dart
ServiceBlocListener<UserLogoutServiceBloc, UserLogoutServiceRequested, dynamic>(
  onSucceed: (context, state, event, response) => context.read<UserCubit>().clearUserData(),
),
```

### Builder

```dart
ServiceBlocBuilder<OpenLibraryAuthorDetailServiceBloc, OpenLibraryAuthorDetailServiceRequested, OpenLibraryAuthorDetail>(
  onLoading: (context, state, event) => // your loading widget,
  onSucceed: (context, state, event, response) {
    return // your success widget
  },
  onFailed: (context, state, event, error) => // your failure widget,
),
```

For more example detail, please check out [example](https://github.com/aaassseee/service_bloc/tree/main/flutter_service_bloc/example/lib/).

## Maintainer

[Jack Liu](https://github.com/aaassseee)