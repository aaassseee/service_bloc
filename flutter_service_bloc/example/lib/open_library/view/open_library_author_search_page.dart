import 'package:example/main.dart';
import 'package:example/open_library/modal/modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_service_bloc/flutter_service_bloc.dart';

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
          serviceBloc.hasNextPage) {
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
            onSucceed: (context, state, event, response) => const SizedBox(),
            onFailed: (context, state, event, error) => const SizedBox(),
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
                onSucceed: (context, state, event, response) {
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
