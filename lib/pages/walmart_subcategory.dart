import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:pay_or_save/element/walmart_bar.dart';
import 'package:provider/provider.dart';
import '../providers/walmart_provider.dart';
import 'walmart_products.dart';

class WalmartSubcategory extends StatefulWidget {
  final String uid;
  final String categoryId;
  final String categoryName;
  final List<String> path;

  WalmartSubcategory({
    @required this.uid,
    @required this.categoryId,
    @required this.categoryName,
    @required this.path,
  });

  @override
  _WalmartSubcategoryState createState() => _WalmartSubcategoryState();
}

class _WalmartSubcategoryState extends State<WalmartSubcategory> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => 
      Provider.of<WalmartProvider>(context, listen: false)
        .loadSubCategories(widget.categoryId)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: MainDrawer(uid: widget.uid),
      body: CustomScrollView(
        slivers: <Widget>[
          WalmartBar(
            cpage: "subcategory",
            showtitle: true,
            uid: widget.uid,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.path.join(' > '),
                    style: TextStyle(
                      fontSize: 14.h,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    widget.categoryName,
                    style: TextStyle(
                      fontSize: 24.h,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _buildContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Consumer<WalmartProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff0070c0)),
              ),
            ),
          );
        }

        if (provider.error != null) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error loading subcategories',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16.h,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    provider.error,
                    style: TextStyle(fontSize: 14.h),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () => provider.loadSubCategories(widget.categoryId),
                    child: Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff0070c0),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (provider.subCategories.isEmpty) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Center(
              child: Text('No subcategories available'),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: provider.subCategories.length,
          itemBuilder: (context, index) {
            final subCategory = provider.subCategories[index];
            final hasChildren = (subCategory['children'] ?? []).isNotEmpty;

            return Card(
              margin: EdgeInsets.only(bottom: 8.h),
              child: ListTile(
                title: Text(
                  subCategory['name'] ?? 'Unknown Subcategory',
                  style: TextStyle(
                    fontSize: 16.h,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'ID: ${subCategory['id'] ?? 'N/A'}',
                  style: TextStyle(fontSize: 12.h),
                ),
                trailing: hasChildren ? Icon(Icons.chevron_right) : null,
                onTap: () {
                  if (hasChildren) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WalmartSubcategory(
                          uid: widget.uid,
                          categoryId: subCategory['id'],
                          categoryName: subCategory['name'],
                          path: [...widget.path, subCategory['name']],
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WalmartProducts(
                          uid: widget.uid,
                          categoryId: subCategory['id'],
                          categoryName: subCategory['name'],
                          path: [...widget.path, subCategory['name']],
                        ),
                      ),
                    );
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
} 