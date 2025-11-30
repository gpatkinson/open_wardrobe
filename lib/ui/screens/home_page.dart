import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketbase/pocketbase.dart';

import '../../main.dart';
import '../../services/wardrobe_service.dart';
import '../../repositories/wardrobe_repository.dart';
import '../../models/wardrobe_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<WardrobeItem>> _clothesFuture;
  final _wardrobeService = WardrobeService(WardrobeRepository());

  @override
  void initState() {
    super.initState();
    _clothesFuture = _getClothes();
  }

  Future<List<WardrobeItem>> _getClothes() async {
    return await _wardrobeService.getWardrobeItems();
  }

  void _signOut() {
    pb.authStore.clear();
    context.go('/auth');
  }

  void _refresh() {
    setState(() {
      _clothesFuture = _getClothes();
    });
  }

  Future<void> _showAddItemDialog() async {
    final nameController = TextEditingController();
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Wardrobe Item'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Item name',
            hintText: 'e.g., Blue Jeans, White T-Shirt',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                Navigator.pop(context, nameController.text.trim());
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result != null) {
      try {
        await _wardrobeService.addWardrobeItem(name: result);
        _refresh();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Added "$result" to your wardrobe!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error adding item: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _deleteItem(WardrobeItem item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
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
      try {
        await _wardrobeService.deleteWardrobeItem(item.id);
        _refresh();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Deleted "${item.name}"')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting item: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = pb.authStore.model as RecordModel?;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wardrobe'),
        actions: [
          if (user != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: Text(
                  user.getStringValue('username').isNotEmpty 
                      ? user.getStringValue('username')
                      : user.getStringValue('email'),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Sign out',
          ),
        ],
      ),
      body: FutureBuilder<List<WardrobeItem>>(
        future: _clothesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refresh,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final clothes = snapshot.data!;
            return ListView.builder(
              itemCount: clothes.length,
              itemBuilder: (context, index) {
                final item = clothes[index];
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.checkroom),
                  ),
                  title: Text(item.name),
                  subtitle: Text('Added ${_formatDate(item.createdAt)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _deleteItem(item),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.checkroom,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your wardrobe is empty',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Go to the Wardrobe tab to add items',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays == 0) {
      return 'today';
    } else if (diff.inDays == 1) {
      return 'yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
