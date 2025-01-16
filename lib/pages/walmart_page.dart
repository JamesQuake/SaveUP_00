import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:pay_or_save/element/walmart_bar.dart';
import '../services/walmart_service.dart';
import 'walmart_subcategory.dart';
import 'package:provider/provider.dart';
import '../providers/walmart_provider.dart';

class Walmart extends StatefulWidget {
  final String uid;

  Walmart({
    this.uid,
  });

  @override
  _WalmartState createState() => _WalmartState();
}

class _WalmartState extends State<Walmart> {
  @override
  void initState() {
    super.initState();
    // Fetch taxonomy when page loads
    Future.microtask(() => 
      Provider.of<WalmartProvider>(context, listen: false).fetchTaxonomy()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: MainDrawer(uid: widget.uid),
      body: CustomScrollView(
        slivers: <Widget>[
          WalmartBar(
            cpage: "main",
            showtitle: true,
            uid: widget.uid,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 0, bottom: 16.0),
              child: _buildContent(),
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
            height: MediaQuery.of(context).size.height * 0.7,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff0070c0)),
              ),
            ),
          );
        }

        if (provider.error != null) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error loading taxonomy data',
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
                    onPressed: () => provider.fetchTaxonomy(),
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

        final categories = provider.categories;
        if (categories.isEmpty) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Center(
              child: Text('No categories available'),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Card(
              margin: EdgeInsets.only(bottom: 8.h),
              child: ListTile(
                title: Text(
                  category['name'] ?? 'Unknown Category',
                  style: TextStyle(
                    fontSize: 16.h,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'ID: ${category['id'] ?? 'N/A'}',
                  style: TextStyle(fontSize: 12.h),
                ),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WalmartSubcategory(
                        uid: widget.uid,
                        categoryId: category['id'],
                        categoryName: category['name'],
                        path: [category['name']],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
