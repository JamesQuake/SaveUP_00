import 'package:flutter/material.dart';
import '../services/walmart_service.dart';
import '../models/walmart_product.dart';

class WalmartProvider with ChangeNotifier {
  final WalmartService _walmartService = WalmartService();
  
  bool _isLoading = false;
  String _error;
  Map<String, dynamic> _taxonomyData;
  List<dynamic> _subCategories = [];
  bool _isLoadingProducts = false;
  String _productsError;
  WalmartProductResponse _productsData;
  String _nextPage;

  // Getters
  bool get isLoading => _isLoading;
  String get error => _error;
  Map<String, dynamic> get taxonomyData => _taxonomyData;
  List<dynamic> get subCategories => _subCategories;
  List<dynamic> get categories => _taxonomyData['categories'] ?? [];
  bool get isLoadingProducts => _isLoadingProducts;
  String get productsError => _productsError;
  List<WalmartProduct> get products => _productsData?.items ?? [];
  bool get hasMoreProducts => _nextPage != null;
  int get totalProducts => _productsData != null ? 
      (int.tryParse(_productsData.totalPages ?? '0') ?? 0) * 20 : 0;

  // Fetch main taxonomy
  Future<void> fetchTaxonomy() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final taxonomy = await _walmartService.getTaxonomy();
      _taxonomyData = taxonomy;
      _error = null;
    } catch (e) {
      _error = e.toString();
      _taxonomyData = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Helper method to find category by ID in the taxonomy tree
  Map<String, dynamic> _findCategoryById(List<dynamic> categories, String categoryId) {
    for (var category in categories) {
      if (category['id'] == categoryId) {
        return category;
      }
      if (category['children'] != null && category['children'].isNotEmpty) {
        final result = _findCategoryById(category['children'], categoryId);
        if (result != null) {
          return result;
        }
      }
    }
    return null;
  }

  // Load subcategories for a specific category
  Future<void> loadSubCategories(String categoryId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (_taxonomyData == null) {
        await fetchTaxonomy();
      }

      // Find category anywhere in the taxonomy tree
      final category = _findCategoryById(_taxonomyData['categories'], categoryId);
      
      print('Found category: $category');

      if (category != null) {
        _subCategories = category['children'] ?? [];
        _error = null;
      } else {
        _error = 'Category not found';
        _subCategories = [];
      }
    } catch (e) {
      print('Error loading subcategories: $e');
      _error = e.toString();
      _subCategories = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Add this method to fetch products
  Future<void> fetchProducts(String categoryId, {bool refresh = false}) async {
    if (refresh) {
      _nextPage = null;
      _productsData = null;
    }

    if (_isLoadingProducts) return;
    if (!refresh && _nextPage == null && _productsData != null) return;

    _isLoadingProducts = true;
    _productsError = null;
    notifyListeners();

    try {
      final result = await _walmartService.getProducts(
        categoryId: categoryId,
        nextPage: _nextPage,
      );
      
      print('Products API Response: $result');

      if (result == null) {
        throw Exception('No data received from API');
      }

      final response = WalmartProductResponse.fromJson(result);
      print('Parsed response: ${response.items?.length} items');

      // Add debug logging for each product
      response.items?.forEach((product) {
        print('Processing product:');
        product.debugPrint();
      });

      if (_productsData == null) {
        _productsData = response;
      } else {
        _productsData = WalmartProductResponse(
          category: response.category,
          format: response.format,
          nextPage: response.nextPage,
          totalPages: response.totalPages,
          items: [..._productsData.items ?? [], ...response.items ?? []],
        );
      }

      _nextPage = response.nextPage;
      print('Next page: $_nextPage');
    } catch (e) {
      print('Error fetching products: $e');
      _productsError = e.toString();
    } finally {
      _isLoadingProducts = false;
      notifyListeners();
    }
  }
} 