import 'package:flutter/material.dart';
import '../../services/wardrobe_service.dart';
import '../../repositories/wardrobe_repository.dart';
import '../../models/wardrobe_item.dart';
import '../../models/outfit.dart';

class OutfitsScreen extends StatefulWidget {
  const OutfitsScreen({super.key});

  @override
  State<OutfitsScreen> createState() => _OutfitsScreenState();
}

class _OutfitsScreenState extends State<OutfitsScreen> {
  final _service = WardrobeService(WardrobeRepository());
  List<Outfit> _outfits = [];
  List<WardrobeItem> _allItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final outfits = await _service.getOutfits();
      final items = await _service.getWardrobeItems();
      setState(() {
        _outfits = outfits;
        _allItems = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _showCreateOutfitDialog() async {
    if (_allItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add some wardrobe items first!')),
      );
      return;
    }

    final nameController = TextEditingController();
    final selectedItemIds = <String>{};
    
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Create Outfit'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Outfit name',
                    hintText: 'e.g., Casual Friday, Date Night',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Select items:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _allItems.length,
                    itemBuilder: (context, index) {
                      final item = _allItems[index];
                      final isSelected = selectedItemIds.contains(item.id);
                      return CheckboxListTile(
                        title: Text(item.name),
                        value: isSelected,
                        onChanged: (checked) {
                          setDialogState(() {
                            if (checked == true) {
                              selectedItemIds.add(item.id);
                            } else {
                              selectedItemIds.remove(item.id);
                            }
                          });
                        },
                        secondary: CircleAvatar(
                          backgroundImage: item.imageUrl != null 
                              ? NetworkImage(item.imageUrl!) 
                              : null,
                          child: item.imageUrl == null 
                              ? const Icon(Icons.checkroom) 
                              : null,
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '${selectedItemIds.length} items selected',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty && selectedItemIds.isNotEmpty) {
                  Navigator.pop(context, {
                    'name': nameController.text.trim(),
                    'itemIds': selectedItemIds.toList(),
                  });
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      try {
        await _service.createOutfit(
          name: result['name'],
          itemIds: List<String>.from(result['itemIds']),
        );
        _loadData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Created outfit "${result['name']}"')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  Future<void> _deleteOutfit(Outfit outfit) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Outfit'),
        content: Text('Delete "${outfit.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _service.deleteOutfit(outfit.id);
      _loadData();
    }
  }

  List<WardrobeItem> _getOutfitItems(Outfit outfit) {
    return _allItems.where((item) => outfit.itemIds.contains(item.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Outfits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _outfits.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.style, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No outfits yet',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Create your first outfit!',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _outfits.length,
                  itemBuilder: (context, index) {
                    final outfit = _outfits[index];
                    final items = _getOutfitItems(outfit);
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: InkWell(
                        onLongPress: () => _deleteOutfit(outfit),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      outfit.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () => _deleteOutfit(outfit),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 80,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: items.length,
                                  itemBuilder: (context, i) {
                                    final item = items[i];
                                    return Container(
                                      width: 70,
                                      margin: const EdgeInsets.only(right: 8),
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 25,
                                            backgroundImage: item.imageUrl != null
                                                ? NetworkImage(item.imageUrl!)
                                                : null,
                                            child: item.imageUrl == null
                                                ? const Icon(Icons.checkroom)
                                                : null,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            item.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontSize: 11),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Text(
                                '${items.length} items',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateOutfitDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

