import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../../azkar/presentation/pages/azkar_page.dart';

class AzkarSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => close(context, ''),
      );

  @override
  Widget buildResults(BuildContext context) {
    context.read<SearchBloc>().add(SearchQueryChanged(query));
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final results = state.results;
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final item = results[index];
            return ListTile(
              title: Text(item["text"]!),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AzkarPage(type: item["type"]!))),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    context.read<SearchBloc>().add(SearchQueryChanged(query));
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final suggestions = state.results;
        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final item = suggestions[index];
            return ListTile(
              title: Text(item["text"]!),
              onTap: () {
                query = item["text"]!;
                showResults(context);
              },
            );
          },
        );
      },
    );
  }
}
