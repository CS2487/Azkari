import 'package:azkar_application/features/azkar/azkar_page.dart';
import 'package:azkar_application/features/search/search_provider/search_provider.dart';
import 'package:azkar_application/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    context.read<SearchProvider>().updateQuery(query);
    return Consumer<SearchProvider>(
      builder: (context, state, _) {
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
                    builder: (_) => AzkarPage(type: item["type"]!)),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    context.read<SearchProvider>().updateQuery(query);
    return Consumer<SearchProvider>(
      builder: (context, state, _) {
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
