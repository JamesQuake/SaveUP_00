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

  // Add these properties
  List<WalmartProduct> _filteredProducts = [];
  RangeValues _currentPriceRange;
  Set<String> _currentBrands = {};
  bool _showOnlyAvailable = false;
  bool _showOnlyFreeShipping = false;
  bool _showOnlyClearance = false;
  String _currentSort;

  // Add to WalmartProvider
  List<WalmartProduct> _searchResults = [];
  int _searchStart = 1;
  String _currentQuery;
  bool _hasMoreSearchResults = true;

  // Add these properties
  List<dynamic> _facets = [];
  String _currentFacetFilter;
  String _currentFacetRange;

  // Add these properties
  int _totalSearchResults = 0;

  // Getters
  bool get isLoading => _isLoading;
  String get error => _error;
  Map<String, dynamic> get taxonomyData => _taxonomyData;
  List<dynamic> get subCategories => _subCategories;
  List<dynamic> get categories => _taxonomyData['categories'] ?? [];
  bool get isLoadingProducts => _isLoadingProducts;
  String get productsError => _productsError;
  List<WalmartProduct> get products => _filteredProducts.isEmpty 
    ? _productsData?.items ?? []
    : _filteredProducts;
  bool get hasMoreProducts => _nextPage != null;
  int get totalProducts => _productsData != null ? 
      (int.tryParse(_productsData.totalPages ?? '0') ?? 0) * 20 : 0; 

  List<WalmartProduct> get searchResults => _searchResults;

  // Add getter for facets
  List<dynamic> get facets => _facets;

  // Add getters
  int get totalSearchResults => _totalSearchResults;
  int get searchStart => _searchStart;

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
  Future<void> fetchProducts(String categoryId, {
    bool refresh = false,
    String sort,
  }) async {
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
        sortBy: sort ?? _currentSort,
      );
      
      print('Products API Response: $result');

      if (result == null) {
        throw Exception('No data received from API');
      }

      final response = WalmartProductResponse.fromJson(result);
      
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
      
      // Apply any existing filters to the new data
      if (_currentPriceRange != null || 
          _currentBrands.isNotEmpty || 
          _showOnlyAvailable ||
          _showOnlyFreeShipping ||
          _showOnlyClearance) {
        applyFilters(
          priceRange: _currentPriceRange,
          brands: _currentBrands,
          onlyAvailable: _showOnlyAvailable,
          onlyFreeShipping: _showOnlyFreeShipping,
          onlyClearance: _showOnlyClearance,
        );
      }

    } catch (e) {
      print('Error fetching products: $e');
      _productsError = e.toString();
    } finally {
      _isLoadingProducts = false;
      notifyListeners();
    }
  }

  Future<void> sortProducts(String sortBy, String categoryId) async {
    _currentSort = sortBy;
    
    // Clear existing data
    _nextPage = null;
    _productsData = null;
    _filteredProducts = [];
    notifyListeners();  // Notify to show loading state

    try {
      // Use the provided categoryId instead of trying to get it from cleared data
      await fetchProducts(
        categoryId,  // Use the passed categoryId
        refresh: true,
        sort: sortBy,
      );
    } catch (e) {
      print('Error sorting products: $e');
      _productsError = e.toString();
      notifyListeners();
    }
  }

  void applyFilters({
    RangeValues priceRange,
    Set<String> brands,
    bool onlyAvailable,
    bool onlyFreeShipping,
    bool onlyClearance,
  }) {
    _currentPriceRange = priceRange;
    _currentBrands = brands;
    _showOnlyAvailable = onlyAvailable;
    _showOnlyFreeShipping = onlyFreeShipping;
    _showOnlyClearance = onlyClearance;

    _filteredProducts = _productsData?.items?.where((product) {
      if (product.salePrice == null) return false;
      
      if (product.salePrice < priceRange.start || 
          product.salePrice > priceRange.end) return false;
      
      if (brands.isNotEmpty && !brands.contains(product.brandName)) return false;
      
      if (onlyAvailable && product.stock != "Available") return false;
      
      if (onlyFreeShipping && !product.freeShippingOver35Dollars) return false;
      
      if (onlyClearance && !product.clearance) return false;
      
      return true;
    })?.toList() ?? [];

    notifyListeners();
  }

  void resetFilters() {
    _filteredProducts = [];
    _currentPriceRange = null;
    _currentBrands = {};
    _showOnlyAvailable = false;
    _showOnlyFreeShipping = false;
    _showOnlyClearance = false;
    notifyListeners();
  }

  // Add this method to reset search state
  Future<void> resetSearch() async {
    _searchResults = [];
    _searchStart = 1;
    _hasMoreSearchResults = true;
    _facets = [];
    _totalSearchResults = 0;
    notifyListeners();
  }

  Future<void> searchProducts({
    String query,
    String categoryId,
    String sort,
    String facetFilter,
    String facetRange,
  }) async {
    try {
      if (query != _currentQuery) {
        await resetSearch();
        // Update filter tracking only when query changes
        _currentFacetFilter = facetFilter;
        _currentFacetRange = facetRange;
      }
      
      _currentQuery = query;
      _currentSort = sort;
      
      // Use tracked filters if none provided
      facetFilter = facetFilter ?? _currentFacetFilter;
      facetRange = facetRange ?? _currentFacetRange;
      
      // Determine order based on selected sort
      String order;
      String apiSort = sort;
      
      if (sort == 'price_asc') {
        apiSort = 'price';
        order = 'ascending';
      } else if (sort == 'price_desc') {
        apiSort = 'price';
        order = 'descending';
      }
      
      final result = await _walmartService.searchProducts(
        query: query,
        categoryId: categoryId,
        start: _searchStart,
        sort: apiSort,
        order: order,
        facetFilter: facetFilter,
        facetRange: facetRange,
      );
      
      // Store total results and facets
      _totalSearchResults = result['totalResults'] as int ?? 0;
      _facets = result['facets'] as List<dynamic> ?? [];
      
      final response = WalmartProductResponse.fromJson(result);
      
      if (_searchStart == 1) {
        _searchResults = response.items;
      } else {
        _searchResults.addAll(response.items);
      }
      
      _searchStart += response.items.length;
      _hasMoreSearchResults = _searchStart <= _totalSearchResults;
      
      notifyListeners();
    } catch (e) {
      print('Error searching products: $e');
      rethrow;
    }
  }

  Future<void> loadMoreSearchResults() async {
    if (!_hasMoreSearchResults || _currentQuery == null) return;
    
    await searchProducts(
      query: _currentQuery,
      categoryId: null, // Assuming _currentCategory is not defined and should be null
      sort: _currentSort,
      facetFilter: _currentFacetFilter,
      facetRange: _currentFacetRange,
    );
  }
} 