import 'package:example/main.dart';
import 'package:example/open_library/modal/modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_service_bloc/flutter_service_bloc.dart';

class OpenLibraryHomePage extends StatefulWidget {
  static const routeName = '/openLibrary';

  const OpenLibraryHomePage({Key? key}) : super(key: key);

  @override
  State<OpenLibraryHomePage> createState() => _OpenLibraryHomePageState();
}

class _OpenLibraryHomePageState extends State<OpenLibraryHomePage> {
  late final TextEditingController _textEditingController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final serviceBloc = context.read<OpenLibraryAuthorSearchServiceBloc>();

    _textEditingController = TextEditingController();
    _textEditingController.addListener(() {
      serviceBloc.add(OpenLibraryAuthorSearchReloadServiceRequested(
          _textEditingController.text));
    });

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent -
                  _scrollController.position.pixels <=
              144.0 &&
          !serviceBloc.isEmptyReturned) {
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
      appBar: AppBar(),
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
                onSucceed: (context, state, event, response) =>
                    ListView.builder(
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    final searchResult = response[index];
                    return ListTile(
                      title: Text(searchResult.name),
                    );
                  },
                  itemCount: response.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
