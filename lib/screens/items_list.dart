import 'package:flutter/material.dart';
import 'package:code_generator/models/qr_code.dart';
import 'package:code_generator/views/item_tile.dart';
import 'package:code_generator/widgets/modeIcon.dart';
import 'package:code_generator/widgets/myText.dart';

import '../constants/colors.dart';
import '../db/storage_helper.dart';
import '../widgets/my_icon_btn.dart';

class ItemsList extends StatefulWidget {
  const ItemsList({super.key});

  @override
  State<ItemsList> createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  final TextEditingController _searchController = TextEditingController();
  Future<List<Items>>? _itemsFuture;
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(fontFamily: regularFont),
                decoration: const InputDecoration(
                  hintText: 'ابحث بالاسم...',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const MyText(
                    txt: 'الاصناف',
                    family: boldFont,
                    size: 18,
                  ),
                  MyIconButton(
                    iconData: const Icon(Icons.search),
                    onPressed: () => setState(() => _isSearching = true),
                  ),
                  const ModeIcon(),
                ],
              ),
      ),
      body: FutureBuilder<List<Items>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: MyText(txt: 'لا يوجد منتجات بعد'));
          }
          final filteredItems = _filterItems(snapshot.data!);
          return ListView.builder(
            itemCount: filteredItems.length,
            itemBuilder: (context, index) => ItemTile(
              items: filteredItems[index],
              onItemDeleted: _refreshItems,
            ),
          );
        },
      ),
    );
  }

  void _refreshItems() {
    setState(() {
      _itemsFuture = ItemStorage.getItems();
    });
  }

  List<Items> _filterItems(List<Items> items) {
    if (_searchQuery.isEmpty) return items;
    return items.where((item) {
      final name = item.name.toLowerCase();
      final type = item.type.toLowerCase();
      return name.contains(_searchQuery.toLowerCase()) ||
          type.contains(_searchQuery.toLowerCase());
    }).toList();
  }
}
