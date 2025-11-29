import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../services/wardrobe_service.dart';
import '../../services/background_removal_service.dart';
import '../../repositories/wardrobe_repository.dart';
import '../../models/wardrobe_item.dart';
import '../../models/item_category.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  final _service = WardrobeService(WardrobeRepository());
  final _imagePicker = ImagePicker();
  List<WardrobeItem> _items = [];
  List<ItemCategory> _categories = [];
  String? _selectedCategoryId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final items = await _service.getWardrobeItems();
      final categories = await _service.getCategories();
      setState(() {
        _items = items;
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  List<WardrobeItem> get _filteredItems {
    if (_selectedCategoryId == null) return _items;
    return _items.where((item) => item.categoryId == _selectedCategoryId).toList();
  }

  Future<void> _showAddItemDialog() async {
    final nameController = TextEditingController();
    String? selectedCategoryId;
    XFile? selectedImage;
    bool removeBackground = true; // Default to removing background
    Uint8List? previewBytes;
    bool isProcessing = false;
    
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('Add Wardrobe Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image picker
                GestureDetector(
                  onTap: isProcessing ? null : () async {
                    final image = await _imagePicker.pickImage(
                      source: ImageSource.gallery,
                      maxWidth: 800,
                      maxHeight: 800,
                      imageQuality: 85,
                    );
                    if (image != null) {
                      setDialogState(() {
                        selectedImage = image;
                        previewBytes = null;
                      });
                      // Load preview
                      final bytes = await image.readAsBytes();
                      setDialogState(() => previewBytes = bytes);
                    }
                  },
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: previewBytes != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              previewBytes!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : selectedImage != null
                            ? const Center(child: CircularProgressIndicator())
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo, size: 40, color: Colors.grey[500]),
                                  const SizedBox(height: 8),
                                  Text('Tap to add photo', style: TextStyle(color: Colors.grey[600])),
                                ],
                              ),
                  ),
                ),
                // Remove background toggle
                if (selectedImage != null) ...[
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('Remove background', style: TextStyle(fontSize: 14)),
                    subtitle: Text(
                      removeBackground ? 'AI will remove the background' : 'Keep original photo',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                    value: removeBackground,
                    onChanged: isProcessing ? null : (value) {
                      setDialogState(() => removeBackground = value);
                    },
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Item name',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedCategoryId,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          const DropdownMenuItem(value: null, child: Text('No category')),
                          ..._categories.map((c) => DropdownMenuItem(
                            value: c.id,
                            child: Text(c.name),
                          )),
                        ],
                        onChanged: (value) {
                          setDialogState(() => selectedCategoryId = value);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: () async {
                        final newCatName = await _showQuickCategoryDialog();
                        if (newCatName != null) {
                          try {
                            final newCat = await _service.addCategory(newCatName);
                            await _loadData();
                            setDialogState(() {
                              selectedCategoryId = newCat.id;
                            });
                          } catch (e) {
                            // ignore
                          }
                        }
                      },
                      icon: const Icon(Icons.add),
                      tooltip: 'New category',
                    ),
                  ],
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
              onPressed: isProcessing ? null : () {
                if (nameController.text.trim().isNotEmpty) {
                  Navigator.pop(context, {
                    'name': nameController.text.trim(),
                    'categoryId': selectedCategoryId,
                    'image': selectedImage,
                    'removeBackground': removeBackground,
                  });
                }
              },
              child: isProcessing 
                ? const SizedBox(
                    width: 16, 
                    height: 16, 
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Add'),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      // Show loading indicator
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                ),
                SizedBox(width: 12),
                Text('Processing image...'),
              ],
            ),
            duration: Duration(seconds: 30),
          ),
        );
      }
      
      try {
        List<int>? imageBytes;
        String? imageName;
        
        if (result['image'] != null) {
          final XFile image = result['image'];
          Uint8List bytes = await image.readAsBytes();
          imageName = image.name;
          
          // Remove background if enabled
          if (result['removeBackground'] == true) {
            try {
              bytes = await BackgroundRemovalService.removeBackground(bytes, imageName);
              imageName = '${imageName.split('.').first}.png'; // Change extension to PNG
            } catch (e) {
              // If background removal fails, use original image
              if (mounted) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Background removal failed, using original: $e'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            }
          }
          
          imageBytes = bytes;
        }
        
        await _service.addWardrobeItem(
          name: result['name'],
          categoryId: result['categoryId'],
          imageBytes: imageBytes,
          imageName: imageName,
        );
        _loadData();
        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Added "${result['name']}"')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  Future<String?> _showQuickCategoryDialog() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Category'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Category name',
            hintText: 'e.g., Tops, Shoes',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              Navigator.pop(context, value.trim());
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(context, controller.text.trim());
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddCategoryDialog() async {
    final controller = TextEditingController();
    
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Category'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Category name',
            hintText: 'e.g., Tops, Bottoms, Shoes',
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
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(context, controller.text.trim());
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (name != null) {
      try {
        await _service.addCategory(name);
        _loadData();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  Future<void> _editItem(WardrobeItem item) async {
    final nameController = TextEditingController(text: item.name);
    String? selectedCategoryId = item.categoryId;
    XFile? selectedImage;
    bool removeBackground = false;
    Uint8List? previewBytes;
    
    // Load existing image if available
    if (item.imageUrl != null) {
      try {
        final response = await http.get(Uri.parse(item.imageUrl!));
        if (response.statusCode == 200) {
          previewBytes = response.bodyBytes;
        }
      } catch (e) {
        // Ignore
      }
    }
    
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('Edit Wardrobe Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    final image = await _imagePicker.pickImage(
                      source: ImageSource.gallery,
                      maxWidth: 800,
                      maxHeight: 800,
                      imageQuality: 85,
                    );
                    if (image != null) {
                      setDialogState(() {
                        selectedImage = image;
                        previewBytes = null;
                      });
                      final bytes = await image.readAsBytes();
                      setDialogState(() => previewBytes = bytes);
                    }
                  },
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: previewBytes != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              previewBytes!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo, size: 40, color: Colors.grey[500]),
                              const SizedBox(height: 8),
                              Text('Tap to change photo', style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                  ),
                ),
                if (selectedImage != null) ...[
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('Remove background', style: TextStyle(fontSize: 14)),
                    value: removeBackground,
                    onChanged: (value) {
                      setDialogState(() => removeBackground = value);
                    },
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Item name',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedCategoryId,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          const DropdownMenuItem(value: null, child: Text('No category')),
                          ..._categories.map((c) => DropdownMenuItem(
                            value: c.id,
                            child: Text(c.name),
                          )),
                        ],
                        onChanged: (value) {
                          setDialogState(() => selectedCategoryId = value);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: () async {
                        final newCatName = await _showQuickCategoryDialog();
                        if (newCatName != null) {
                          try {
                            final newCat = await _service.addCategory(newCatName);
                            await _loadData();
                            setDialogState(() {
                              selectedCategoryId = newCat.id;
                            });
                          } catch (e) {
                            // ignore
                          }
                        }
                      },
                      icon: const Icon(Icons.add),
                      tooltip: 'New category',
                    ),
                  ],
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
                if (nameController.text.trim().isNotEmpty) {
                  Navigator.pop(context, {
                    'name': nameController.text.trim(),
                    'categoryId': selectedCategoryId,
                    'image': selectedImage,
                    'removeBackground': removeBackground,
                  });
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      try {
        // If new image provided, delete and recreate with new image
        if (result['image'] != null) {
          // Delete old item
          await _service.deleteWardrobeItem(item.id);
          
          // Process new image
          final XFile image = result['image'];
          Uint8List bytes = await image.readAsBytes();
          String imageName = image.name;
          
          if (result['removeBackground'] == true) {
            try {
              bytes = await BackgroundRemovalService.removeBackground(bytes, imageName);
              imageName = '${imageName.split('.').first}.png';
            } catch (e) {
              // Use original if background removal fails
            }
          }
          
          // Create new item with updated data
          await _service.addWardrobeItem(
            name: result['name'],
            categoryId: result['categoryId'],
            imageBytes: bytes,
            imageName: imageName,
          );
        } else {
          // Just update name and category
          await _service.updateWardrobeItem(
            item.id,
            name: result['name'],
            categoryId: result['categoryId'],
          );
        }
        
        _loadData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item updated')),
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

  Future<void> _deleteItem(WardrobeItem item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Delete "${item.name}"?'),
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
      await _service.deleteWardrobeItem(item.id);
      _loadData();
    }
  }

  Future<void> _editCategory(ItemCategory category) async {
    final controller = TextEditingController(text: category.name);
    
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Category'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Category name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              Navigator.pop(context, value.trim());
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(context, controller.text.trim());
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (newName != null && newName != category.name) {
      try {
        // Note: PocketBase doesn't have a direct update for categories in our current setup
        // We'll need to add that to the repository
        await _service.updateCategory(category.id, newName);
        _loadData();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wardrobe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: _showAddCategoryDialog,
            tooltip: 'Add Category',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Category filter chips
                if (_categories.isNotEmpty)
                  Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: const Text('All'),
                            selected: _selectedCategoryId == null,
                            onSelected: (_) {
                              setState(() => _selectedCategoryId = null);
                            },
                          ),
                        ),
                        ..._categories.map((category) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category.name),
                            selected: _selectedCategoryId == category.id,
                            onSelected: (_) {
                              setState(() => _selectedCategoryId = category.id);
                            },
                            deleteIcon: Icon(Icons.edit, size: 14),
                            onDeleted: () => _editCategory(category),
                            showCheckmark: false,
                          ),
                        )),
                      ],
                    ),
                  ),
                // Items grid
                Expanded(
                  child: _filteredItems.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.checkroom, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                _selectedCategoryId != null
                                    ? 'No items in this category'
                                    : 'No items yet',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap + to add your first item',
                                style: TextStyle(color: Colors.grey[500], fontSize: 12),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(8),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6,
                          ),
                          itemCount: _filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = _filteredItems[index];
                            final category = _categories.where((c) => c.id == item.categoryId).firstOrNull;
                            
                            return Card(
                              clipBehavior: Clip.antiAlias,
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Stack(
                                children: [
                                  InkWell(
                                    onTap: () => _editItem(item),
                                    borderRadius: BorderRadius.circular(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: ClipRRect(
                                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                            child: Container(
                                              color: Colors.grey[100],
                                              child: item.imageUrl != null
                                                  ? Image.network(
                                                      item.imageUrl!,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (_, __, ___) => Center(
                                                        child: Icon(Icons.checkroom, size: 24, color: Colors.grey[400]),
                                                      ),
                                                    )
                                                  : Center(
                                                      child: Icon(Icons.checkroom, size: 24, color: Colors.grey[400]),
                                                    ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                item.name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              if (category != null)
                                                Text(
                                                  category.name,
                                                  style: TextStyle(
                                                    fontSize: 8,
                                                    color: Colors.grey[600],
                                                  ),
                                                  maxLines: 1,
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: PopupMenuButton<String>(
                                      icon: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.9),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.more_vert, size: 14, color: Colors.grey[700]),
                                      ),
                                      padding: EdgeInsets.zero,
                                      onSelected: (value) {
                                        if (value == 'edit') {
                                          _editItem(item);
                                        } else if (value == 'delete') {
                                          _deleteItem(item);
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 'edit',
                                          child: Row(
                                            children: [
                                              Icon(Icons.edit, size: 18),
                                              SizedBox(width: 8),
                                              Text('Edit'),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'delete',
                                          child: Row(
                                            children: [
                                              Icon(Icons.delete_outline, size: 18, color: Colors.red),
                                              SizedBox(width: 8),
                                              Text('Delete', style: TextStyle(color: Colors.red)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddItemDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
    );
  }
}
