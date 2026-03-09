import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/listing_repository.dart';
import 'directory_screen.dart';

class EditListingScreen extends ConsumerStatefulWidget {
  const EditListingScreen({super.key, this.existing});

  final Listing? existing;

  @override
  ConsumerState<EditListingScreen> createState() => _EditListingScreenState();
}

class _EditListingScreenState extends ConsumerState<EditListingScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _address;
  late final TextEditingController _contact;
  late final TextEditingController _description;
  late final TextEditingController _lat;
  late final TextEditingController _lng;
  String _category = DirectoryScreen.categories[1];

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _name = TextEditingController(text: e?.name ?? '');
    _address = TextEditingController(text: e?.address ?? '');
    _contact = TextEditingController(text: e?.contactNumber ?? '');
    _description = TextEditingController(text: e?.description ?? '');
    _lat = TextEditingController(
        text: e != null ? e.latitude.toStringAsFixed(6) : '');
    _lng = TextEditingController(
        text: e != null ? e.longitude.toStringAsFixed(6) : '');
    _category = e?.category ?? DirectoryScreen.categories[1];
  }

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _contact.dispose();
    _description.dispose();
    _lat.dispose();
    _lng.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final lat = double.tryParse(_lat.text.trim());
    final lng = double.tryParse(_lng.text.trim());
    if (lat == null || lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid numeric latitude and longitude.'),
        ),
      );
      return;
    }

    final repo = ref.read(listingRepositoryProvider);
    final messenger = ScaffoldMessenger.of(context);

    try {
      final now = DateTime.now();
      if (widget.existing == null) {
        final listing = Listing(
          id: '',
          name: _name.text.trim(),
          category: _category,
          address: _address.text.trim(),
          contactNumber: _contact.text.trim(),
          description: _description.text.trim(),
          latitude: lat,
          longitude: lng,
          createdBy: user.uid,
          createdAt: now,
        );
        await repo.create(listing);
      } else {
        final listing = Listing(
          id: widget.existing!.id,
          name: _name.text.trim(),
          category: _category,
          address: _address.text.trim(),
          contactNumber: _contact.text.trim(),
          description: _description.text.trim(),
          latitude: lat,
          longitude: lng,
          createdBy: widget.existing!.createdBy,
          createdAt: widget.existing!.createdAt,
        );
        await repo.update(listing);
      }

      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(widget.existing == null
              ? 'Listing created'
              : 'Listing updated'),
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('Failed to save listing: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Listing' : 'New Listing'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                  labelText: 'Place or Service Name',
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _category,
                items: DirectoryScreen.categories
                    .where((c) => c != 'All')
                    .map(
                      (c) => DropdownMenuItem(
                        value: c,
                        child: Text(c),
                      ),
                    )
                    .toList(),
                decoration: const InputDecoration(labelText: 'Category'),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _category = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _address,
                decoration: const InputDecoration(
                  labelText: 'Address',
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Address is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contact,
                decoration: const InputDecoration(
                  labelText: 'Contact Number',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _description,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _lat,
                      decoration: const InputDecoration(
                        labelText: 'Latitude',
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _lng,
                      decoration: const InputDecoration(
                        labelText: 'Longitude',
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: Text(isEditing ? 'Save changes' : 'Create listing'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

