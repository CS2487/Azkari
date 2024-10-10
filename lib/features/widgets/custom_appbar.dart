import 'package:shopping/core/imports/imports.dart';

import '../../data/models/product_model.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ProductModel? product;

  const CustomAppBar({
    super.key,
    this.product,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70.0);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final greeting =
        DateTime.now().hour < 12 ? l10n.goodMorning : l10n.goodEvening;
    final username = l10n.username;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/Search');
              },
              icon: Tooltip(
                message: l10n.search,
                child: const Icon(Icons.search_rounded),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          greeting,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Row(
                          children: [
                            Text(
                              username,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.waving_hand_rounded,
                              color: Colors.amber,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
