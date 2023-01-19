import 'package:equatable/equatable.dart';
import 'package:example/open_library/bloc/service_bloc.dart';
import 'package:example/open_library/modal/modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_service_bloc/flutter_service_bloc.dart';

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
