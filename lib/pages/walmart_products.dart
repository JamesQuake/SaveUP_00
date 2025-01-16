import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:pay_or_save/element/walmart_bar.dart';
import 'package:provider/provider.dart';
import '../providers/walmart_provider.dart';
import '../pages/walmart_product_detail.dart';

class WalmartProducts extends StatefulWidget {
  final String uid;
  final String categoryId;
  final String categoryName;
  final List<String> path;

  WalmartProducts({
    @required this.uid,
    @required this.categoryId,
    @required this.categoryName,
    @required this.path,
  });

  @override
  _WalmartProductsState createState() => _WalmartProductsState();
}

class _WalmartProductsState extends State<WalmartProducts> {
  final ScrollController _scrollController = ScrollController();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      Future.microtask(() =>
          Provider.of<WalmartProvider>(context, listen: false)
              .fetchProducts(widget.categoryId, refresh: true));
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      Provider.of<WalmartProvider>(context, listen: false)
          .fetchProducts(widget.categoryId);
    }
  }

  Widget _buildProductsGrid(WalmartProvider provider) {
    if (provider.isLoadingProducts && provider.products.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff0070c0)),
              ),
              SizedBox(height: 16.h),
              Text(
                'Loading products...',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16.h,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.productsError != null && provider.products.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48.h,
                  color: Colors.red[300],
                ),
                SizedBox(height: 16.h),
                Text(
                  'Error loading products',
                  style: TextStyle(
                    color: Colors.red[400],
                    fontSize: 18.h,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  provider.productsError,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.h,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 24.h),
                ElevatedButton.icon(
                  onPressed: () => provider.fetchProducts(widget.categoryId, refresh: true),
                  icon: Icon(Icons.refresh),
                  label: Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff0070c0),
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (provider.products.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Text('No products available in this category'),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.all(8.0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= provider.products.length) {
              if (provider.hasMoreProducts) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xff0070c0)),
                    ),
                  ),
                );
              }
              return null;
            }

            final product = provider.products[index];
            return GestureDetector(
              onTap: () {
                print('product.largeImage: '+product.largeImage);
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
          },
          childCount: provider.hasMoreProducts
              ? provider.products.length + 1
              : provider.products.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: MainDrawer(uid: widget.uid),
      body: Consumer<WalmartProvider>(
        builder: (context, provider, child) {
          return CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              WalmartBar(
                cpage: "products",
                showtitle: true,
                uid: widget.uid,
              ),
              if (!provider.isLoadingProducts || provider.products.isNotEmpty)
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Breadcrumb navigation
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: widget.path.asMap().entries.map((entry) {
                              final isLast = entry.key == widget.path.length - 1;
                              return Row(
                                children: [
                                  Text(
                                    entry.value,
                                    style: TextStyle(
                                      fontSize: 14.h,
                                      color: isLast ? Color(0xff0070c0) : Colors.grey[600],
                                      fontWeight: isLast ? FontWeight.w600 : FontWeight.normal,
                                    ),
                                  ),
                                  if (!isLast)
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                                      child: Icon(
                                        Icons.chevron_right,
                                        size: 16,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        // Category title and product count
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.categoryName,
                                style: TextStyle(
                                  fontSize: 24.h,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xff0070c0).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${NumberFormat.compact(
                                  locale: 'en-us',
                                ).format(
                                  int.parse(provider.totalProducts.toString()),
                                )} items',
                                style: TextStyle(
                                  fontSize: 14.h,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff0070c0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                sliver: _buildProductsGrid(provider),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
