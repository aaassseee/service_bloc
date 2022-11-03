import 'dart:async';

import 'package:bloc/src/bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:service_bloc/service_bloc.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

// ignore_for_file: prefer_const_constructors

void main() {
  final firstPageResponse = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
  ];

  final secondPageResponse = [
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
  ];

  group('service bloc', () {
    group('service bloc object equatable', () {
      test('service bloc ServiceInitial state equatable', () {
        expect(ServiceInitial() == ServiceInitial(), true);
      });

      test('service bloc ServiceLoadInProgress state equatable', () {
        expect(
            ServiceLoadInProgress(
                    event: SampleServiceSuccessRequested('test')) ==
                ServiceLoadInProgress(
                    event: SampleServiceSuccessRequested('test')),
            true);
      });

      test('service bloc ServiceLoadSuccess state equatable', () {
        expect(
            ServiceLoadSuccess(
                    event: SampleServiceSuccessRequested('test'), data: null) ==
                ServiceLoadSuccess(
                    event: SampleServiceSuccessRequested('test'), data: null),
            true);
      });

      test('service bloc ServiceLoadFailure state equatable', () {
        expect(
            ServiceLoadFailure(
                    event: SampleServiceSuccessRequested('test'),
                    error: ServiceError()) ==
                ServiceLoadFailure(
                    event: SampleServiceSuccessRequested('test'),
                    error: ServiceError()),
            true);
      });
    });

    test('service bloc initial state', () {
      final serviceBloc = SampleServiceBloc();
      expect(serviceBloc.state, const ServiceInitial());
    });

    test('service bloc initial data', () {
      final serviceBloc = SampleServiceBloc();
      expect(serviceBloc.data, null);
      expect(serviceBloc.hasData, false);
    });

    test('service bloc data', () async {
      final serviceBloc = SampleServiceBloc();
      serviceBloc.add(const SampleServiceSuccessRequested('para'));
      await for (final state in serviceBloc.stream) {
        if (state is! ServiceResponseState) continue;
        expect(serviceBloc.data, 'string');
        expect(serviceBloc.hasData, true);
        break;
      }
    });

    blocTest<SampleServiceBloc, ServiceState>(
      'service bloc requested success',
      build: () => SampleServiceBloc(),
      act: (bloc) => bloc.add(const SampleServiceSuccessRequested('test')),
      expect: () => [
        const ServiceLoadInProgress<SampleServiceRequestedBase>(
            event: SampleServiceSuccessRequested('test')),
        const ServiceLoadSuccess<SampleServiceRequestedBase, String>(
            event: SampleServiceSuccessRequested('test'), data: 'string'),
      ],
    );

    blocTest<SampleServiceBloc, ServiceState>(
      'service bloc requested failure',
      build: () => SampleServiceBloc(),
      act: (bloc) => bloc.add(const SampleServiceFailureRequested()),
      expect: () => [
        const ServiceLoadInProgress<SampleServiceRequestedBase>(
            event: SampleServiceFailureRequested()),
        ServiceLoadFailure<SampleServiceRequestedBase>(
            event: const SampleServiceFailureRequested(),
            error: ServiceError()),
      ],
    );
  });

  group('pagination list service bloc', () {
    test('pagination list service bloc initial state', () {
      final serviceBloc = SamplePaginationListServiceBloc();
      expect(serviceBloc.state, ServiceInitial());
    });

    test('pagination list service bloc initial data', () {
      final serviceBloc = SamplePaginationListServiceBloc();
      expect(serviceBloc.data, null);
      expect(serviceBloc.hasData, false);
    });

    test('pagination list service bloc data', () async {
      // page 0
      final serviceBloc = SamplePaginationListServiceBloc();
      serviceBloc.add(const SampleServicePaginationSuccessRequested('param'));
      await for (final state in serviceBloc.stream) {
        if (state is ServiceLoadInProgress) {
          expect(serviceBloc.isFirstLoad, true);
          continue;
        }

        if (state is! ServiceResponseState) continue;
        expect(
            state,
            ServiceLoadSuccess<SampleServicePaginationRequestedBase,
                    List<String>>(
                event: SampleServicePaginationSuccessRequested('param'),
                data: firstPageResponse));
        break;
      }
      expect(serviceBloc.data, firstPageResponse);
      expect(serviceBloc.hasData, true);
      expect(serviceBloc.responseData, firstPageResponse);
      expect(serviceBloc.isEmptyReturned, false);

      // page 1
      serviceBloc.add(const SampleServicePaginationSuccessRequested('param'));
      await for (final state in serviceBloc.stream) {
        if (state is ServiceLoadInProgress) {
          expect(serviceBloc.isFirstLoad, false);
          continue;
        }

        if (state is! ServiceResponseState) continue;
        expect(
            state,
            ServiceLoadSuccess<SampleServicePaginationRequestedBase,
                    List<String>>(
                event: SampleServicePaginationSuccessRequested('param'),
                data: [
                  ...firstPageResponse,
                  ...secondPageResponse,
                ]));
        break;
      }
      expect(serviceBloc.data, [
        ...firstPageResponse,
        ...secondPageResponse,
      ]);
      expect(serviceBloc.hasData, true);
      expect(serviceBloc.responseData, [
        ...firstPageResponse,
        ...secondPageResponse,
      ]);
      expect(serviceBloc.isEmptyReturned, false);

      // page 2
      serviceBloc.add(const SampleServicePaginationSuccessRequested('param'));
      await for (final state in serviceBloc.stream) {
        if (state is ServiceLoadInProgress) {
          expect(serviceBloc.isFirstLoad, false);
          continue;
        }

        if (state is! ServiceResponseState) continue;
        expect(
            state,
            ServiceLoadSuccess<SampleServicePaginationRequestedBase,
                    List<String>>(
                event: SampleServicePaginationSuccessRequested('param'),
                data: [
                  ...firstPageResponse,
                  ...secondPageResponse,
                ]));
        break;
      }
      expect(serviceBloc.data, [
        ...firstPageResponse,
        ...secondPageResponse,
      ]);
      expect(serviceBloc.hasData, true);
      expect(serviceBloc.responseData, [
        ...firstPageResponse,
        ...secondPageResponse,
      ]);
      expect(serviceBloc.isEmptyReturned, true);

      // reload
      serviceBloc.add(const SampleServicePaginationReloadRequested('param'));

      await for (final state in serviceBloc.stream) {
        if (state is ServiceLoadInProgress) {
          expect(serviceBloc.isFirstLoad, true);
          continue;
        }

        if (state is! ServiceResponseState) continue;
        expect(state, isA<ServiceLoadSuccess>());
        break;
      }
      expect(serviceBloc.data, firstPageResponse);
      expect(serviceBloc.hasData, true);
      expect(serviceBloc.responseData, firstPageResponse);
      expect(serviceBloc.isEmptyReturned, false);
    });

    blocTest<SamplePaginationListServiceBloc, ServiceState>(
      'pagination list service bloc requested success',
      build: () => SamplePaginationListServiceBloc(),
      act: (bloc) =>
          bloc.add(const SampleServicePaginationSuccessRequested('param')),
      expect: () => [
        const ServiceLoadInProgress<SampleServicePaginationRequestedBase>(
            event: SampleServicePaginationSuccessRequested('param')),
        ServiceLoadSuccess<SampleServicePaginationRequestedBase, List<String>>(
            event: SampleServicePaginationSuccessRequested('param'),
            data: firstPageResponse),
      ],
    );

    blocTest<SamplePaginationListServiceBloc, ServiceState>(
      'pagination list service bloc requested failure',
      build: () => SamplePaginationListServiceBloc(),
      act: (bloc) => bloc.add(const SampleServicePaginationFailureRequested()),
      expect: () => [
        const ServiceLoadInProgress<SampleServicePaginationRequestedBase>(
            event: SampleServicePaginationFailureRequested()),
        ServiceLoadFailure<SampleServicePaginationRequestedBase>(
            event: const SampleServicePaginationFailureRequested(),
            error: ServiceError()),
      ],
    );
  });

  group('pagination object service bloc', () {
    test('pagination object service bloc initial state', () {
      final serviceBloc = SamplePaginationListServiceBloc();
      expect(serviceBloc.state, ServiceInitial());
    });

    test('pagination object service bloc initial data', () {
      final serviceBloc = SamplePaginationListServiceBloc();
      expect(serviceBloc.data, null);
      expect(serviceBloc.hasData, false);
    });

    test('pagination object service bloc data', () async {
      // page 0
      final serviceBloc = SamplePaginationObjectServiceBloc();
      serviceBloc.add(const SampleServicePaginationSuccessRequested('param'));
      await for (final state in serviceBloc.stream) {
        if (state is ServiceLoadInProgress) {
          expect(serviceBloc.isFirstLoad, true);
          continue;
        }

        if (state is! ServiceResponseState) continue;
        expect(
            state,
            ServiceLoadSuccess<SampleServicePaginationRequestedBase,
                    SampleObject>(
                event: SampleServicePaginationSuccessRequested('param'),
                data: SampleObject(firstPageResponse, firstPageResponse)));
        break;
      }
      expect(
          serviceBloc.data, SampleObject(firstPageResponse, firstPageResponse));
      expect(serviceBloc.hasData, true);
      expect(serviceBloc.responseData,
          SampleObject(firstPageResponse, firstPageResponse));
      expect(serviceBloc.isEmptyReturned, false);

      // page 1
      serviceBloc.add(const SampleServicePaginationSuccessRequested('param'));
      await for (final state in serviceBloc.stream) {
        if (state is ServiceLoadInProgress) {
          expect(serviceBloc.isFirstLoad, false);
          continue;
        }

        if (state is! ServiceResponseState) continue;
        expect(
            state,
            ServiceLoadSuccess<SampleServicePaginationRequestedBase,
                    SampleObject>(
                event: SampleServicePaginationSuccessRequested('param'),
                data: SampleObject([
                  ...firstPageResponse,
                  ...secondPageResponse,
                ], [
                  ...firstPageResponse,
                  ...secondPageResponse,
                ])));
        break;
      }
      expect(
          serviceBloc.data,
          SampleObject([
            ...firstPageResponse,
            ...secondPageResponse,
          ], [
            ...firstPageResponse,
            ...secondPageResponse,
          ]));
      expect(serviceBloc.hasData, true);
      expect(
          serviceBloc.responseData,
          SampleObject([
            ...firstPageResponse,
            ...secondPageResponse,
          ], [
            ...firstPageResponse,
            ...secondPageResponse,
          ]));
      expect(serviceBloc.isEmptyReturned, false);

      // page 2
      serviceBloc.add(const SampleServicePaginationSuccessRequested('param'));
      await for (final state in serviceBloc.stream) {
        if (state is ServiceLoadInProgress) {
          expect(serviceBloc.isFirstLoad, false);
          continue;
        }

        if (state is! ServiceResponseState) continue;
        expect(
            state,
            ServiceLoadSuccess<SampleServicePaginationRequestedBase,
                    SampleObject>(
                event: SampleServicePaginationSuccessRequested('param'),
                data: SampleObject([
                  ...firstPageResponse,
                  ...secondPageResponse,
                ], [
                  ...firstPageResponse,
                  ...secondPageResponse,
                ])));
        break;
      }
      expect(
          serviceBloc.data,
          SampleObject([
            ...firstPageResponse,
            ...secondPageResponse,
          ], [
            ...firstPageResponse,
            ...secondPageResponse,
          ]));
      expect(serviceBloc.hasData, true);
      expect(
          serviceBloc.responseData,
          SampleObject([
            ...firstPageResponse,
            ...secondPageResponse,
          ], [
            ...firstPageResponse,
            ...secondPageResponse,
          ]));
      expect(serviceBloc.isEmptyReturned, true);

      // reload
      serviceBloc.add(const SampleServicePaginationReloadRequested('param'));

      await for (final state in serviceBloc.stream) {
        if (state is ServiceLoadInProgress) {
          expect(serviceBloc.isFirstLoad, true);
          continue;
        }

        if (state is! ServiceResponseState) continue;
        expect(state, isA<ServiceLoadSuccess>());
        break;
      }
      expect(
          serviceBloc.data, SampleObject(firstPageResponse, firstPageResponse));
      expect(serviceBloc.hasData, true);
      expect(serviceBloc.responseData,
          SampleObject(firstPageResponse, firstPageResponse));
      expect(serviceBloc.isEmptyReturned, false);
    });

    blocTest<SamplePaginationObjectServiceBloc, ServiceState>(
      'pagination object service bloc requested success',
      build: () => SamplePaginationObjectServiceBloc(),
      act: (bloc) =>
          bloc.add(const SampleServicePaginationSuccessRequested('param')),
      expect: () => [
        const ServiceLoadInProgress<SampleServicePaginationRequestedBase>(
            event: SampleServicePaginationSuccessRequested('param')),
        ServiceLoadSuccess<SampleServicePaginationRequestedBase, SampleObject>(
            event: SampleServicePaginationSuccessRequested('param'),
            data: SampleObject(firstPageResponse, firstPageResponse)),
      ],
    );

    blocTest<SamplePaginationObjectServiceBloc, ServiceState>(
      'pagination object service bloc requested failure',
      build: () => SamplePaginationObjectServiceBloc(),
      act: (bloc) => bloc.add(const SampleServicePaginationFailureRequested()),
      expect: () => [
        const ServiceLoadInProgress<SampleServicePaginationRequestedBase>(
            event: SampleServicePaginationFailureRequested()),
        ServiceLoadFailure<SampleServicePaginationRequestedBase>(
            event: const SampleServicePaginationFailureRequested(),
            error: ServiceError()),
      ],
    );
  });
}

class ServiceError extends Error with EquatableMixin {
  @override
  List<Object?> get props => [];
}

abstract class SampleServiceRequestedBase extends ServiceRequested {
  const SampleServiceRequestedBase();
}

class SampleServiceSuccessRequested extends SampleServiceRequestedBase {
  const SampleServiceSuccessRequested(this.param);

  final String param;

  @override
  List<Object?> get props => [];
}

class SampleServiceFailureRequested extends SampleServiceRequestedBase {
  const SampleServiceFailureRequested();

  @override
  List<Object?> get props => [];
}

class SampleServiceBloc
    extends ServiceBloc<SampleServiceRequestedBase, String> {
  @override
  FutureOr<void> onRequest(
      SampleServiceRequestedBase event, Emitter<ServiceState> emit) {
    if (event is SampleServiceSuccessRequested) {
      return onSampleServiceSuccessRequested(event, emit);
    }

    if (event is SampleServiceFailureRequested) {
      return onSampleServiceFailureRequested(event, emit);
    }

    emit(ServiceLoadFailure<SampleServiceRequestedBase>(
        event: event, error: UnimplementedError()));
  }

  FutureOr<void> onSampleServiceSuccessRequested(
      SampleServiceSuccessRequested event, Emitter<ServiceState> emit) {
    emit(ServiceLoadSuccess<SampleServiceRequestedBase, String>(
        event: event, data: 'string'));
  }

  FutureOr<void> onSampleServiceFailureRequested(
      SampleServiceFailureRequested event, Emitter<ServiceState> emit) {
    emit(ServiceLoadFailure<SampleServiceRequestedBase>(
        event: event, error: ServiceError()));
  }
}

abstract class SampleServicePaginationRequestedBase
    extends PaginationServiceRequested {
  const SampleServicePaginationRequestedBase();
}

class SampleServicePaginationSuccessRequested
    extends SampleServicePaginationRequestedBase {
  const SampleServicePaginationSuccessRequested(this.param);

  final String param;

  @override
  List<Object?> get props => [];
}

class SampleServicePaginationFailureRequested
    extends SampleServicePaginationRequestedBase {
  const SampleServicePaginationFailureRequested();

  @override
  List<Object?> get props => [];
}

class SampleServicePaginationReloadRequested
    extends SampleServicePaginationSuccessRequested
    implements PaginationReloadServiceRequested {
  const SampleServicePaginationReloadRequested(String param) : super(param);

  @override
  List<Object?> get props => [];
}

class SamplePaginationListServiceBloc extends PaginationListServiceBloc<
    SampleServicePaginationRequestedBase, String> {
  @override
  FutureOr<List<String>> onPaginationRequest(
      SampleServicePaginationRequestedBase event, int page) {
    if (event is SampleServicePaginationSuccessRequested) {
      return onSampleServicePaginationSuccessRequested(event, page);
    }

    if (event is SampleServicePaginationFailureRequested) {
      return onSampleServicePaginationFailureRequested(event, page);
    }

    throw UnimplementedError();
  }

  FutureOr<List<String>> onSampleServicePaginationSuccessRequested(
      SampleServicePaginationSuccessRequested event, int page) {
    if (page == 2) return <String>[];
    return List.generate(10, (index) => (index + (10 * page)).toString());
  }

  FutureOr<List<String>> onSampleServicePaginationFailureRequested(
      SampleServicePaginationFailureRequested event, int page) {
    throw ServiceError();
  }
}

class SampleObject extends Equatable {
  const SampleObject(this.data1, this.data2);

  final List<String> data1;

  final List<String> data2;

  @override
  List<Object?> get props => [
        data1,
        data2,
      ];
}

class SamplePaginationObjectServiceBloc extends PaginationObjectServiceBloc<
    SampleServicePaginationRequestedBase, SampleObject> {
  @override
  FutureOr<bool> isEmptyPage(SampleObject responseData) {
    return responseData.data1.isEmpty && responseData.data2.isEmpty;
  }

  @override
  FutureOr<SampleObject> onPaginationRequest(
      SampleServicePaginationRequestedBase event, int page) {
    if (event is SampleServicePaginationSuccessRequested) {
      return onSampleServicePaginationSuccessRequested(event, page);
    }

    if (event is SampleServicePaginationFailureRequested) {
      return onSampleServicePaginationFailureRequested(event, page);
    }

    throw UnimplementedError();
  }

  FutureOr<SampleObject> onSampleServicePaginationSuccessRequested(
      SampleServicePaginationSuccessRequested event, int page) {
    if (page == 2) {
      return SampleObject(const [], const []);
    }

    return SampleObject(
      List.generate(10, (index) => (index + (10 * page)).toString()),
      List.generate(10, (index) => (index + (10 * page)).toString()),
    );
  }

  FutureOr<SampleObject> onSampleServicePaginationFailureRequested(
      SampleServicePaginationFailureRequested event, int page) {
    throw ServiceError();
  }

  @override
  FutureOr<SampleObject> onProcessResponseData(
      covariant SampleObject? previousResponseData, SampleObject responseData) {
    if (previousResponseData == null) {
      return responseData;
    }

    return SampleObject([...previousResponseData.data1, ...responseData.data1],
        [...previousResponseData.data2, ...responseData.data2]);
  }
}
