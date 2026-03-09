import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final listingRepositoryProvider = Provider<ListingRepository>((ref) {
  return ListingRepository(FirebaseFirestore.instance);
});

class Listing {
  Listing({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.contactNumber,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.createdBy,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String category;
  final String address;
  final String contactNumber;
  final String description;
  final double latitude;
  final double longitude;
  final String createdBy;
  final DateTime createdAt;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'address': address,
      'contactNumber': contactNumber,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  static Listing fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Listing(
      id: doc.id,
      name: data['name'] as String,
      category: data['category'] as String,
      address: data['address'] as String,
      contactNumber: data['contactNumber'] as String,
      description: data['description'] as String,
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),
      createdBy: data['createdBy'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}

class ListingRepository {
  ListingRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _ref =>
      _firestore.collection('listings');

  Stream<List<Listing>> watchAll() {
    return _ref.orderBy('createdAt', descending: true).snapshots().map(
          (snap) => snap.docs.map(Listing.fromDoc).toList(),
        );
  }

  Stream<List<Listing>> watchForUser(String uid) {
    return _ref
        .where('createdBy', isEqualTo: uid)
        .snapshots()
        .map((snap) => snap.docs.map(Listing.fromDoc).toList());
  }

  Future<void> create(Listing listing) async {
    await _ref.add(listing.toMap());
  }

  Future<void> update(Listing listing) async {
    await _ref.doc(listing.id).update(listing.toMap());
  }

  Future<void> delete(String id) async {
    await _ref.doc(id).delete();
  }
}

class ListingsFilterState {
  ListingsFilterState({
    this.searchQuery = '',
    this.category = 'All',
  });

  final String searchQuery;
  final String category;

  ListingsFilterState copyWith({
    String? searchQuery,
    String? category,
  }) {
    return ListingsFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      category: category ?? this.category,
    );
  }
}

final listingsFilterProvider =
    StateNotifierProvider<ListingsFilterController, ListingsFilterState>((ref) {
  return ListingsFilterController();
});

class ListingsFilterController extends StateNotifier<ListingsFilterState> {
  ListingsFilterController() : super(ListingsFilterState());

  void setSearch(String value) {
    state = state.copyWith(searchQuery: value);
  }

  void setCategory(String value) {
    state = state.copyWith(category: value);
  }
}

final listingsStreamProvider = StreamProvider<List<Listing>>((ref) {
  final repo = ref.watch(listingRepositoryProvider);
  return repo.watchAll();
});

final filteredListingsProvider = Provider<List<Listing>>((ref) {
  final listingsAsync = ref.watch(listingsStreamProvider);
  final filter = ref.watch(listingsFilterProvider);

  return listingsAsync.maybeWhen(
    data: (listings) {
      return listings.where((l) {
        final matchesCategory =
            filter.category == 'All' || l.category == filter.category;
        final matchesSearch = filter.searchQuery.isEmpty ||
            l.name.toLowerCase().contains(filter.searchQuery.toLowerCase());
        return matchesCategory && matchesSearch;
      }).toList();
    },
    orElse: () => const [],
  );
});

final myListingsStreamProvider = StreamProvider<List<Listing>>((ref) {
  final repo = ref.watch(listingRepositoryProvider);
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return const Stream.empty();
  }
  return repo.watchForUser(user.uid);
});

