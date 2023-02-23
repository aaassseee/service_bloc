import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:example/open_library/modal/modal.dart';
import 'package:example/open_library/repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_service_bloc/flutter_service_bloc.dart';

void main() {
  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider(
        create: (context) => OpenLibraryRepository(),
      )
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      onGenerateRoute: (settings) {
        late final Widget page;
        switch (settings.name) {
          case HomePage.routeName:
            page = const HomePage();
            break;

          case OpenLibraryAuthorSearchPage.routeName:
            page = BlocProvider(
              create: (context) => OpenLibraryAuthorSearchServiceBloc(
                  context.read<OpenLibraryRepository>()),
              child: const OpenLibraryAuthorSearchPage(),
            );
            break;

          case OpenLibraryAuthorDetailPage.routeName:
            assert(settings.arguments is OpenLibraryAuthorDetailPageParameter);
            final parameter =
                settings.arguments as OpenLibraryAuthorDetailPageParameter;
            page = BlocProvider(
              create: (context) => OpenLibraryAuthorDetailServiceBloc(
                  context.read<OpenLibraryRepository>())
                ..add(OpenLibraryAuthorDetailServiceRequested(parameter.key)),
              child: OpenLibraryAuthorDetailPage(parameter: parameter),
            );
            break;

          default:
            throw UnimplementedError('page name not found');
        }

        return MaterialPageRoute(
          builder: (context) => page,
          settings: settings,
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('flutter_service_bloc example'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.of(context)
                    .pushNamed(OpenLibraryAuthorSearchPage.routeName),
                child: const Text('Open Library API'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// OpenLibraryHomePage class should be put into /open_library/bloc folder. This
/// is only for displaying code in example purpose. Check out the correct
/// placement in /open_library.
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

class OpenLibraryAuthorSearchServiceBloc extends PaginationListServiceBloc<
    OpenLibraryAuthorSearchServiceRequested,
    OpenLibraryAuthorSearchResult,
    num> {
  OpenLibraryAuthorSearchServiceBloc(this.repository)
      : super(
            pagination: NumberBasedPagination(
          onUpdateHasNextPage: (responseData) => responseData.isNotEmpty,
        ));

  final OpenLibraryRepository repository;

  @override
  FutureOr<List<OpenLibraryAuthorSearchResult>> onPaginationRequest(
      OpenLibraryAuthorSearchServiceRequested event, num page) async {
    final response = await repository.searchAuthor(
        keyword: event.keyword, pageNo: page.toInt());
    return response.toList();
  }
}

class OpenLibraryAuthorDetailServiceRequested extends ServiceRequested {
  const OpenLibraryAuthorDetailServiceRequested(this.authorKey);

  final String authorKey;

  @override
  List<Object?> get props => [authorKey];
}

class OpenLibraryAuthorDetailServiceBloc extends ServiceBloc<
    OpenLibraryAuthorDetailServiceRequested, OpenLibraryAuthorDetail> {
  OpenLibraryAuthorDetailServiceBloc(this.repository);

  final OpenLibraryRepository repository;

  @override
  FutureOr<void> onRequest(OpenLibraryAuthorDetailServiceRequested event,
      Emitter<ServiceState> emit) async {
    try {
      final response =
          await repository.fetchAuthorDetail(authorKey: event.authorKey);
      emit(ServiceLoadSuccess(event: event, data: response));
    } catch (error) {
      emit(ServiceLoadFailure(event: event, error: error));
    }
  }
}

/// OpenLibraryHomePage class should be put into /open_library/view folder. This
/// is only for displaying code in example purpose. Check out the correct
/// placement in /open_library.
class OpenLibraryAuthorSearchPage extends StatefulWidget {
  static const routeName = '/openLibraryAuthorSearch';

  const OpenLibraryAuthorSearchPage({Key? key}) : super(key: key);

  @override
  State<OpenLibraryAuthorSearchPage> createState() =>
      _OpenLibraryAuthorSearchPageState();
}

class _OpenLibraryAuthorSearchPageState
    extends State<OpenLibraryAuthorSearchPage> {
  // using the [form_bloc] library you can skip the annoying form creation in page
  late final TextEditingController _textEditingController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final serviceBloc = context.read<OpenLibraryAuthorSearchServiceBloc>();

    _textEditingController = TextEditingController();
    _textEditingController.addListener(() {
      // add debounce if you want
      serviceBloc.add(OpenLibraryAuthorSearchReloadServiceRequested(
          _textEditingController.text));
    });

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent -
                  _scrollController.position.pixels <=
              144.0 &&
          serviceBloc.pagination.hasNextPage) {
        serviceBloc.add(OpenLibraryAuthorSearchServiceRequested(
            _textEditingController.text));
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Author Search'),
        actions: [
          ServiceBlocBuilder<
              OpenLibraryAuthorSearchServiceBloc,
              OpenLibraryAuthorSearchServiceRequested,
              List<OpenLibraryAuthorSearchResult>>(
            onLoading: (context, state, event) => const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
            onSuccess: (context, state, event, response) => const SizedBox(),
            onFailure: (context, state, event, error) => const SizedBox(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                hintText: 'Search author',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            Expanded(
              child: ServiceBlocBuilder<
                  OpenLibraryAuthorSearchServiceBloc,
                  OpenLibraryAuthorSearchServiceRequested,
                  List<OpenLibraryAuthorSearchResult>>(
                onSuccess: (context, state, event, response) {
                  return ListView.builder(
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      final author = response[index];
                      return ListTile(
                        title: Text(author.name),
                        onTap: () => Navigator.of(context).pushNamed(
                            OpenLibraryAuthorDetailPage.routeName,
                            arguments: OpenLibraryAuthorDetailPageParameter(
                                key: author.key, name: author.name)),
                      );
                    },
                    itemCount: response.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OpenLibraryAuthorDetailPageParameter extends Equatable {
  const OpenLibraryAuthorDetailPageParameter({
    required this.key,
    required this.name,
  });

  final String key;

  final String name;

  @override
  List<Object?> get props => [key, name];
}

class OpenLibraryAuthorDetailPage extends StatelessWidget {
  static const routeName = '/openLibraryAuthorDetail';

  const OpenLibraryAuthorDetailPage({Key? key, required this.parameter})
      : super(key: key);

  final OpenLibraryAuthorDetailPageParameter parameter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(parameter.name)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ServiceBlocBuilder<OpenLibraryAuthorDetailServiceBloc,
            OpenLibraryAuthorDetailServiceRequested, OpenLibraryAuthorDetail>(
          onLoading: (context, state, event) =>
              const Center(child: CircularProgressIndicator()),
          onSuccess: (context, state, event, response) {
            return ListView(
              children: [
                if (response.photoIdList.isNotEmpty) ...[
                  SizedBox(
                    height: 320,
                    child: PageView.builder(
                      itemBuilder: (context, index) {
                        final photoId = response.photoIdList[index];
                        return Image.network(
                          'https://covers.openlibrary.org/a/id/$photoId.jpg',
                          errorBuilder: (context, error, stackTrace) =>
                              const Placeholder(color: Colors.red),
                        );
                      },
                      itemCount: response.photoIdList.length,
                    ),
                  ),
                  const Divider(),
                ],
                Text('Name: ${response.name}'),
                const Divider(),
                if (response.personalName != null) ...[
                  Text('Personal Name: ${response.personalName}'),
                  const Divider(),
                ],
                if (response.alternateNameList.isNotEmpty) ...[
                  Text(
                      'Alternate names: ${response.alternateNameList.take(10).join(', ')}'),
                  const Divider(),
                ],
                if (response.title != null) ...[
                  Text('Title: ${response.title}'),
                  const Divider(),
                ],
                if (response.birthDate != null) ...[
                  Text('Birthday: ${response.birthDate}'),
                  const Divider(),
                ],
                if (response.wikipedia != null)
                  Text('Wikipedia: ${response.wikipedia}'),
              ],
            );
          },
        ),
      ),
    );
  }
}
