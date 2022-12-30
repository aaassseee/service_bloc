import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_bloc/service_bloc.dart';

/// [ServiceBlocBuilder] handles building a widget in response to relative state.
///
/// If parameter [buildWhen] is omitted, default [buildWhen] will only return true
/// when certain parameter is set. For example [onInitial] [onLoading] [onFailed].
/// [onSuccess] is a required parameter so [buildWhen] will always return true if
/// state is [ServiceLoadSuccess]
class ServiceBlocBuilder<
    Bloc extends ServiceBloc<ServiceRequestedEvent, Response>,
    ServiceRequestedEvent extends ServiceRequested,
    Response> extends BlocBuilder<Bloc, ServiceState> {
  /// A widget builder which is only used when build get build in first time and
  /// current state is [ServiceInitial]. When [onInitial] is omitted and
  /// [buildWhen] is omitted, [fallback] widget will be used when first build
  /// and layout would not update when state is [ServiceInitial]. That means
  /// layout will be preserved from previous build.
  final Widget Function(BuildContext context, ServiceInitial state)? onInitial;

  /// A widget builder which is only used when current state is
  /// [ServiceLoadInProgress]. When [onLoading] is omitted and [buildWhen] is
  /// omitted, layout would not update when state is [ServiceLoadInProgress].
  /// That means layout will be preserved from previous build.
  final Widget Function(
      BuildContext context,
      ServiceLoadInProgress<ServiceRequestedEvent> state,
      ServiceRequestedEvent event)? onLoading;

  /// A widget builder which is only used when current state is
  /// [ServiceLoadSuccess].
  final Widget Function(
      BuildContext context,
      ServiceLoadSuccess<ServiceRequestedEvent, Response> state,
      ServiceRequestedEvent event,
      Response response) onSuccess;

  /// A widget builder which is only used when current state is
  /// [ServiceLoadFailure]. When [onFailure] is omitted and [buildWhen] is
  /// omitted, layout would not update when state is [ServiceLoadFailure]. That
  /// means layout will be preserved from previous build.
  final Widget Function(
      BuildContext context,
      ServiceLoadFailure<ServiceRequestedEvent> state,
      ServiceRequestedEvent event,
      dynamic error)? onFailed;

  /// A fallback widget for [builder] to use when [buildWhen] got passed and
  /// widget builder function is omitted.
  ///
  /// Please make sure, which [RenderObject] is extends by parent widget. You
  /// should the same type of [RenderObject] with [fallback].
  /// For example: [RenderBox], [RenderSliver].
  final Widget? fallback;

  /// A constructor for creating a [ServiceBlocBuilder]. Default [buildWhen] is
  /// used when [buildWhen] is omitted.
  ServiceBlocBuilder({
    Key? key,
    Bloc? bloc,
    BlocBuilderCondition? buildWhen,
    this.onInitial,
    this.onLoading,
    required this.onSuccess,
    this.onFailed,
    this.fallback,
  }) : super(
          key: key,
          bloc: bloc,
          buildWhen: buildWhen ??
              (previous, current) {
                if (current is ServiceInitial) {
                  return onInitial != null;
                }

                if (current is ServiceLoadInProgress<ServiceRequestedEvent>) {
                  return onLoading != null;
                }

                if (current
                    is ServiceLoadSuccess<ServiceRequestedEvent, Response>) {
                  return true;
                }

                if (current is ServiceLoadFailure<ServiceRequestedEvent>) {
                  return onFailed != null;
                }

                return false;
              },
          builder: (context, state) {
            if (state is ServiceInitial) {
              if (onInitial == null) {
                return fallback ?? Container();
              }
              return onInitial(context, state);
            }

            if (state is ServiceLoadInProgress<ServiceRequestedEvent>) {
              if (onLoading == null) {
                return fallback ?? Container();
              }
              return onLoading(context, state, state.event);
            }

            if (state is ServiceLoadSuccess<ServiceRequestedEvent, Response>) {
              final data = state.data;
              if (data == null) {
                return fallback ?? Container();
              }

              return onSuccess(context, state, state.event, data);
            }

            if (state is ServiceLoadFailure<ServiceRequestedEvent>) {
              if (onFailed == null) {
                return fallback ?? Container();
              }
              return onFailed(context, state, state.event, state.error);
            }

            return fallback ?? Container();
          },
        );
}
