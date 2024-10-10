import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:azkar_application/features/providers/search_provider.dart';
import 'package:azkar_application/features/screens/azkar/azkar_page.dart';
import 'package:azkar_application/features/widgets/custom_appbar.dart';

class AzkarSearchPage extends StatefulWidget {
  const AzkarSearchPage({super.key});

  @override
  State<AzkarSearchPage> createState() => _AzkarSearchPageState();
}

class _AzkarSearchPageState extends State<AzkarSearchPage> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final searchProvider = context.watch<SearchProvider>();
    final results = searchProvider.results;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'بحث الأذكار',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () =>
              Navigator.pop(context), // العودة التلقائية للقائمة السابقة
        ),
        actions: [
          if (query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  query = '';
                  searchProvider.updateQuery('');
                });
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'ابحث هنا...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                fillColor: Theme.of(context).cardColor,
                filled: true,
              ),
              onChanged: (val) {
                setState(() {
                  query = val;
                  searchProvider.updateQuery(query);
                });
              },
            ),
          ),
          Expanded(
            child: query.isEmpty
                ? const Center(
                    child: Text(
                      "ابدأ بالكتابة للبحث",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : results.isEmpty
                    ? const Center(
                        child: Text(
                          "لا توجد نتائج",
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final item = results[index];
                          return ListTile(
                            title: Text(item["text"]!,
                                style: const TextStyle(fontSize: 18)),
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => AzkarPage(
                                    type: item["type"]!,
                                    title: item["text"]!,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
