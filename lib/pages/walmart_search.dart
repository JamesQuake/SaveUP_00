import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/walmart_product.dart';
import '../providers/walmart_provider.dart';
import '../element/walmart_bar.dart';
import 'walmart_product_detail.dart';

class WalmartSearch extends StatefulWidget {
  final String uid;
  final String initialQuery;
  final String categoryId;

  WalmartSearch({
    @required this.uid,
    this.initialQuery = '',
    this.categoryId,
  });

  @override
  _WalmartSearchState createState() => _WalmartSearchState();
}

class _WalmartSearchState extends State<WalmartSearch> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _selectedSort = 'relevance';
  bool _isLoading = false;
  Timer _debounce;
  final Map<String, Set<String>> _selectedFilters = {};
  RangeValues _priceRange = RangeValues(0, 1000);
  Set<String> _selectedBrands = {};
  bool _showOnlyAvailable = false;
  bool _showFreeShipping = false;
  Set<int> _selectedRatings = {};

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialQuery;
    _scrollController.addListener(_onScroll);
    if (widget.initialQuery.isNotEmpty) {
      _performSearch();
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      Provider.of<WalmartProvider>(context, listen: false).loadMoreSearchResults();
    }
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Consumer<WalmartProvider>(
          builder: (context, provider, child) {
            final facets = provider.facets;
            
            // Filter out empty facets and sort by count
            final validFacets = facets.where((facet) {
              final values = facet['facetValues'] ?? [];
              return values.isNotEmpty;
            }).toList();

            return StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Column(
                    children: [
                      // Header
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey[300]),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Filters',
                              style: TextStyle(
                                fontSize: 20.h,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _selectedFilters.clear();
                                  _priceRange = RangeValues(0, 1000);
                                });
                                provider.resetSearch().then((_) => _performSearch());
                                Navigator.pop(context);
                              },
                              child: Text('Reset All'),
                            ),
                          ],
                        ),
                      ),
                      // Filter content
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: validFacets.length,
                          itemBuilder: (context, index) {
                            final facet = validFacets[index];
                            final facetName = facet['name'] as String;
                            final displayName = facet['displayName'] as String;
                            final values = facet['facetValues'] as List;

                            // Skip sort-related and system facets
                            if ([
                              'cat_id',
                              'relevance',
                              'price_asc',
                              'price_desc',
                              'title',
                              'bestseller',
                              'customerRating',
                              'new',
                              'sort',
                              'order'
                            ].contains(facetName)) return SizedBox.shrink();

                            // Handle price range separately
                            if (facetName == 'price') {
                              return _buildPriceRangeFilter(facet, setState);
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayName,
                                  style: TextStyle(
                                    fontSize: 16.h,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                ...values.map((value) {
                                  final isSelected = _selectedFilters[facetName]?.contains(value['name']);
                                  return CheckboxListTile(
                                    title: Row(
                                      children: [
                                        Expanded(
                                          child: Text(value['name'].toString()),
                                        ),
                                        Text(
                                          '(${value['count']})',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14.h,
                                          ),
                                        ),
                                      ],
                                    ),
                                    value: isSelected ?? false,
                                    onChanged: (checked) {
                                      setState(() {
                                        if (_selectedFilters[facetName] == null) {
                                          _selectedFilters[facetName] = {};
                                        }
                                        if (checked) {
                                          _selectedFilters[facetName].add(value['name'].toString());
                                        } else {
                                          _selectedFilters[facetName].remove(value['name'].toString());
                                        }
                                      });
                                    },
                                  );
                                }).toList(),
                                Divider(height: 32),
                              ],
                            );
                          },
                        ),
                      ),
                      // Apply button
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.grey[300]),
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            // Build facet filters
                            List<String> filters = [];
                            
                            _selectedFilters.forEach((facetName, values) {
                              if (values.isNotEmpty) {
                                filters.add('$facetName:${values.join(",")}');
                              }
                            });
                            
                            // Apply filters and search
                            provider.resetSearch().then((_) {
                              _performSearch(
                                facetFilter: filters.isEmpty ? null : filters.join(';'),
                                facetRange: _priceRange.start > 0 || _priceRange.end < 1000
                                    ? 'price:[${_priceRange.start.round()} TO ${_priceRange.end.round()}]'
                                    : null,
                              );
                            });
                            Navigator.pop(context);
                          },
                          child: Text('Apply Filters'),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xff0070c0),
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _performSearch({String facetFilter, String facetRange}) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(Duration(milliseconds: 500), () async {
      if (_searchController.text.isNotEmpty) {
        setState(() => _isLoading = true);
        try {
          await Provider.of<WalmartProvider>(context, listen: false)
              .searchProducts(
                query: _searchController.text,
                categoryId: widget.categoryId,
                sort: _selectedSort,
                facetFilter: facetFilter,
                facetRange: facetRange,
              );
        } finally {
          if (mounted) {
            setState(() => _isLoading = false);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          WalmartBar(
            cpage: "search",
            showtitle: true,
            uid: widget.uid,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.h),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _performSearch();
                              },
                            )
                          : null,
                    ),
                    onChanged: (_) => _performSearch(),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSortDropdown(),
                      ),
                      SizedBox(width: 16.w),
                      Container(
                        height: 48.h,
                        child: Stack(
                          children: [
                            OutlinedButton.icon(
                              onPressed: _isLoading ? null : _showFilterSheet,
                              icon: Icon(Icons.filter_list),
                              label: Text('Filter'),
                              style: OutlinedButton.styleFrom(
                                primary: Color(0xff0070c0),
                                side: BorderSide(color: Color(0xff0070c0)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            if (_hasActiveFilters)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Color(0xff0070c0),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '•',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.h,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  _buildResultsCounter(Provider.of<WalmartProvider>(context, listen: false)),
                ],
              ),
            ),
          ),
          Consumer<WalmartProvider>(
            builder: (context, provider, child) {
              if (_isLoading && provider.searchResults.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (provider.searchResults.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text('No products found'),
                  ),
                );
              }

              return SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    mainAxisSpacing: 16.h,
                    crossAxisSpacing: 16.w,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = provider.searchResults[index];
                      return _buildProductCard(product);
                    },
                    childCount: provider.searchResults.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSortDropdown() {
    final sortFacet = Provider.of<WalmartProvider>(context, listen: false)
        .facets
        .firstWhere((f) => f['name'] == 'sort', orElse: () => null);

    final List<DropdownMenuItem<String>> sortItems = [
      DropdownMenuItem(value: 'relevance', child: Text('Best Match')), // Default option
    ];

    if (sortFacet != null && sortFacet['facetValues'] != null) {
      for (var value in sortFacet['facetValues']) {
        String sortValue = value['name'].toString();
        String displayName = value['displayName'] ?? sortValue;
        
        // Skip if it's already the default option
        if (sortValue == 'relevance') continue;

        // Handle price sort specially
        if (sortValue == 'price') {
          sortItems.addAll([
            DropdownMenuItem(value: 'price_asc', child: Text('Price: Low to High')),
            DropdownMenuItem(value: 'price_desc', child: Text('Price: High to Low')),
          ]);
          continue;
        }

        // Map API sort values to display names
        String displayText = _getSortDisplayText(sortValue, displayName);

        sortItems.add(DropdownMenuItem(
          value: sortValue,
          child: Text(displayText),
        ));
      }
    }

    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xff0070c0)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButton<String>(
        value: _selectedSort,
        isExpanded: true,
        icon: Icon(Icons.sort, color: Color(0xff0070c0)),
        underline: SizedBox(),
        items: sortItems,
        onChanged: _isLoading 
          ? null 
          : (value) {
              setState(() {
                _selectedSort = value;
                _isLoading = true;
              });
              
              // Keep existing filters when sorting
              List<String> filters = [];
              _selectedFilters.forEach((facetName, values) {
                if (values.isNotEmpty) {
                  filters.add('$facetName:${values.join(",")}');
                }
              });
              
              Provider.of<WalmartProvider>(context, listen: false)
                  .resetSearch()
                  .then((_) => _performSearch(
                    facetFilter: filters.isEmpty ? null : filters.join(';'),
                    facetRange: _priceRange.start > 0 || _priceRange.end < 1000
                        ? 'price:[${_priceRange.start.round()} TO ${_priceRange.end.round()}]'
                        : null,
                  ));
            },
      ),
    );
  }

  Widget _buildProductCard(WalmartProduct product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WalmartProductDetail(
              uid: widget.uid,
              product: product,
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xff0070c0)),
                        ),
                      ),
                      Image.network(
                        product.largeImage ?? '',
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name ?? 'Unknown Product',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.h,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product.salePrice != null)
                          Text(
                            '\$${product.salePrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18.h,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff0070c0),
                            ),
                          )
                        else
                          Text(
                            'Price not available',
                            style: TextStyle(
                              fontSize: 14.h,
                              color: Colors.grey,
                            ),
                          ),
                        if (product.msrp != null &&
                            product.salePrice != null &&
                            product.msrp > product.salePrice)
                          Text(
                            'MSRP: \$${product.msrp.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 12.h,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsCounter(WalmartProvider provider) {
    if (provider.searchResults.isEmpty) return SizedBox.shrink();
    
    final start = provider.searchStart - provider.searchResults.length;
    final end = provider.searchStart - 1;
    final total = provider.totalSearchResults;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing total ${NumberFormat.compact().format(total)} results',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14.h,
            ),
          ),
          // if (provider.hasMoreSearchResults)
          //   TextButton(
          //     onPressed: () => provider.loadMoreSearchResults(),
          //     child: Text(
          //       'Load More',
          //       style: TextStyle(
          //         color: Color(0xff0070c0),
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }

  bool get _hasActiveFilters => 
      _selectedFilters.values.any((values) => values.isNotEmpty) ||
      (_priceRange.start > 0 || _priceRange.end < 1000);

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Widget _buildPriceRangeFilter(Map<String, dynamic> facet, StateSetter setState) {
    final minPrice = 0.0;
    final maxPrice = 1000.0; // You might want to get this from facet data

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Range',
          style: TextStyle(
            fontSize: 16.h,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        RangeSlider(
          values: _priceRange,
          min: minPrice,
          max: maxPrice,
          divisions: 100,
          labels: RangeLabels(
            '\$${_priceRange.start.round()}',
            '\$${_priceRange.end.round()}',
          ),
          onChanged: (values) {
            setState(() => _priceRange = values);
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('\$${_priceRange.start.round()}'),
            Text('\$${_priceRange.end.round()}'),
          ],
        ),
        Divider(height: 32),
      ],
    );
  }

  String _getSortDisplayText(String sortValue, String displayName) {
    if (sortValue == 'title') return 'Name: A to Z';
    if (sortValue == 'bestseller') return 'Best Sellers';
    if (sortValue == 'customerRating') return 'Customer Rating';
    if (sortValue == 'new') return 'New Arrivals';
    return displayName;
  }
} 