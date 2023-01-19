import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_service_bloc/flutter_service_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('service bloc listener', () {
    Future<void> buildTestBlocListener(
      WidgetTester widgetTester, {
      required ServiceState initialState,
      required ServiceState targetState,
      int expectedOnLoadingCallCount = 0,
      int expectedOnResponseCallCount = 0,
      int expectedOnSuccessCallCount = 0,
      int expectedOnFailureCallCount = 0,
    }) async {
      final mockServiceBloc = MockServiceBloc();
      whenListen(
        mockServiceBloc,
        Stream.value(targetState),
        initialState: initialState,
      );

      int onLoadingCallCount = 0;
      int onResponseCallCount = 0;
      int onSuccessCallCount = 0;
      int onFailureCallCount = 0;

      await widgetTester.pumpWidget(
        BlocProvider(
          create: (context) => mockServiceBloc,
          child: ServiceBlocListener<MockServiceBloc, MockServiceBlocRequested,
              String>(
            onLoading: (context, state, event) => onLoadingCallCount += 1,
            onResponded: (context, state, event) => onResponseCallCount += 1,
            onSuccess: (context, state, event, data) => onSuccessCallCount += 1,
            onFailure: (context, state, event, error) =>
                onFailureCallCount += 1,
            child: Container(),
          ),
        ),
      );
      await widgetTester.pump();

      expect(onLoadingCallCount, expectedOnLoadingCallCount);
      expect(onResponseCallCount, expectedOnResponseCallCount);
      expect(onSuccessCallCount, expectedOnSuccessCallCount);
      expect(onFailureCallCount, expectedOnFailureCallCount);
    }

    testWidgets('service bloc listener call times from initial to loading',
        (widgetTester) async {
      await buildTestBlocListener(
        widgetTester,
        initialState: const ServiceInitial(),
        targetState: ServiceLoadInProgress(event: MockServiceBlocRequested()),
        expectedOnLoadingCallCount: 1,
      );
    });

    testWidgets('service bloc listener call times from loading to success',
        (widgetTester) async {
      await buildTestBlocListener(
        widgetTester,
        initialState: ServiceLoadInProgress(event: MockServiceBlocRequested()),
        targetState: ServiceLoadSuccess(
            event: MockServiceBlocRequested(), data: 'success'),
        expectedOnResponseCallCount: 1,
        expectedOnSuccessCallCount: 1,
      );
    });

    testWidgets('service bloc listener call times from loading to failure',
        (widgetTester) async {
      await buildTestBlocListener(
        widgetTester,
        initialState: ServiceLoadInProgress(event: MockServiceBlocRequested()),
        targetState: ServiceLoadFailure(
            event: MockServiceBlocRequested(), error: Error()),
        expectedOnResponseCallCount: 1,
        expectedOnFailureCallCount: 1,
      );
    });
  });

  group('service bloc builder', () {
    void buildTestBlocBuilderWidget(
      WidgetTester widgetTester, {
      required ServiceState initialState,
      required ServiceState targetState,
      int expectedOnInitialBuildCount = 0,
      int expectedOnLoadingBuildCount = 0,
      int expectedOnSuccessBuildCount = 0,
      int expectedOnFailureBuildCount = 0,
    }) async {
      final mockServiceBloc = MockServiceBloc();
      whenListen(
        mockServiceBloc,
        Stream.value(targetState),
        initialState: initialState,
      );

      int onInitialBuildCount = 0;
      int onLoadingBuildCount = 0;
      int onSuccessBuildCount = 0;
      int onFailureBuildCount = 0;

      const onInitialWidget = ColoredBox(color: Colors.white);
      const onLoadingWidget = ColoredBox(color: Colors.blue);
      const onSuccessWidget = ColoredBox(color: Colors.green);
      const onFailureWidget = ColoredBox(color: Colors.red);

      await widgetTester.pumpWidget(
        BlocProvider(
          create: (context) => mockServiceBloc,
          child: ServiceBlocBuilder<MockServiceBloc, MockServiceBlocRequested,
              String>(
            onInitial: (context, state) {
              onInitialBuildCount += 1;

              return onInitialWidget;
            },
            onLoading: (context, state, event) {
              onLoadingBuildCount += 1;

              return onLoadingWidget;
            },
            onSuccess: (context, state, event, data) {
              onSuccessBuildCount += 1;

              return onSuccessWidget;
            },
            onFailure: (context, state, event, error) {
              onFailureBuildCount += 1;

              return onFailureWidget;
            },
          ),
        ),
      );
      await widgetTester.pumpAndSettle();

      expect(onInitialBuildCount, expectedOnInitialBuildCount);
      expect(onLoadingBuildCount, expectedOnLoadingBuildCount);
      expect(onSuccessBuildCount, expectedOnSuccessBuildCount);
      expect(onFailureBuildCount, expectedOnFailureBuildCount);

      if (targetState is ServiceInitial) {
        expect(find.byWidget(onInitialWidget), findsOneWidget);
      }

      if (targetState is ServiceLoadInProgress) {
        expect(find.byWidget(onLoadingWidget), findsOneWidget);
      }

      if (targetState is ServiceLoadSuccess) {
        expect(find.byWidget(onSuccessWidget), findsOneWidget);
      }

      if (targetState is ServiceLoadFailure) {
        expect(find.byWidget(onFailureWidget), findsOneWidget);
      }
    }

    testWidgets('service bloc builder build counts from initial to loading',
        (widgetTester) async {
      buildTestBlocBuilderWidget(
        widgetTester,
        initialState: const ServiceInitial(),
        targetState: ServiceLoadInProgress<MockServiceBlocRequested>(
            event: MockServiceBlocRequested()),
        expectedOnInitialBuildCount: 1,
        expectedOnLoadingBuildCount: 1,
      );
    });

    testWidgets('service bloc builder build counts from loading to success',
        (widgetTester) async {
      buildTestBlocBuilderWidget(
        widgetTester,
        initialState: ServiceLoadInProgress<MockServiceBlocRequested>(
            event: MockServiceBlocRequested()),
        targetState: ServiceLoadSuccess(
            event: MockServiceBlocRequested(), data: 'success'),
        expectedOnLoadingBuildCount: 1,
        expectedOnSuccessBuildCount: 1,
      );
    });

    testWidgets('service bloc builder build counts from loading to failure',
        (widgetTester) async {
      buildTestBlocBuilderWidget(
        widgetTester,
        initialState: ServiceLoadInProgress<MockServiceBlocRequested>(
            event: MockServiceBlocRequested()),
        targetState: ServiceLoadFailure(
            event: MockServiceBlocRequested(), error: Error()),
        expectedOnLoadingBuildCount: 1,
        expectedOnFailureBuildCount: 1,
      );
    });
  });
}

class MockServiceBlocRequested extends Mock implements ServiceRequested {}

class MockServiceBloc extends MockBloc<MockServiceBlocRequested, ServiceState>
    implements ServiceBloc<MockServiceBlocRequested, String> {}
