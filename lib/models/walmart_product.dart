class WalmartProductResponse {
  final String category;
  final String format;
  final String nextPage;
  final String totalPages;
  final List<WalmartProduct> items;

  WalmartProductResponse({
    this.category,
    this.format,
    this.nextPage,
    this.totalPages,
    this.items,
  });

  factory WalmartProductResponse.fromJson(Map<String, dynamic> json) {
    print('Parsing response: $json');
    return WalmartProductResponse(
      category: json['category']?.toString(),
      format: json['format']?.toString(),
      nextPage: json['nextPage']?.toString(),
      totalPages: json['totalPages']?.toString(),
      items: (json['items'] as List)
          ?.map((item) => WalmartProduct.fromJson(item))
          ?.toList() ?? [],
    );
  }
}

class WalmartProduct {
  final int itemId;
  final int parentItemId;
  final String name;
  final double msrp;
  final double salePrice;
  final String upc;
  final String categoryPath;
  final String shortDescription;
  final String longDescription;
  final String brandName;
  final String thumbnailImage;
  final String mediumImage;
  final String largeImage;
  final String productTrackingUrl;
  final double standardShipRate;
  final String size;
  final String color;
  final bool marketplace;
  final String modelNumber;
  final String sellerInfo;
  final String categoryNode;
  final String rhid;
  final bool bundle;
  final bool clearance;
  final bool preOrder;
  final String stock;
  final Map<String, dynamic> attributes;
  final String affiliateAddToCartUrl;
  final bool freeShippingOver35Dollars;
  final bool availableOnline;
  final String offerId;

  WalmartProduct({
    this.itemId,
    this.parentItemId,
    this.name,
    this.msrp,
    this.salePrice,
    this.upc,
    this.categoryPath,
    this.shortDescription,
    this.longDescription,
    this.brandName,
    this.thumbnailImage,
    this.mediumImage,
    this.largeImage,
    this.productTrackingUrl,
    this.standardShipRate,
    this.size,
    this.color,
    this.marketplace,
    this.modelNumber,
    this.sellerInfo,
    this.categoryNode,
    this.rhid,
    this.bundle,
    this.clearance,
    this.preOrder,
    this.stock,
    this.attributes,
    this.affiliateAddToCartUrl,
    this.freeShippingOver35Dollars,
    this.availableOnline,
    this.offerId,
  });

  factory WalmartProduct.fromJson(Map<String, dynamic> json) {
    // Helper function to safely convert to double
    double parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    // Helper function to safely convert to int
    int parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return WalmartProduct(
      itemId: parseInt(json['itemId']),
      parentItemId: parseInt(json['parentItemId']),
      name: json['name']?.toString(),
      msrp: parseDouble(json['msrp']),
      salePrice: parseDouble(json['salePrice']),
      upc: json['upc']?.toString(),
      categoryPath: json['categoryPath']?.toString(),
      shortDescription: json['shortDescription']?.toString(),
      longDescription: json['longDescription']?.toString(),
      brandName: json['brandName']?.toString(),
      thumbnailImage: json['thumbnailImage']?.toString(),
      mediumImage: json['mediumImage']?.toString(),
      largeImage: json['largeImage']?.toString(),
      productTrackingUrl: json['productTrackingUrl']?.toString(),
      standardShipRate: parseDouble(json['standardShipRate']),
      size: json['size']?.toString(),
      color: json['color']?.toString(),
      marketplace: json['marketplace'] as bool ?? false,
      modelNumber: json['modelNumber']?.toString(),
      sellerInfo: json['sellerInfo']?.toString(),
      categoryNode: json['categoryNode']?.toString(),
      rhid: json['rhid']?.toString(),
      bundle: json['bundle'] as bool ?? false,
      clearance: json['clearance'] as bool ?? false,
      preOrder: json['preOrder'] as bool ?? false,
      stock: json['stock']?.toString(),
      attributes: json['attributes'] as Map<String, dynamic> ?? {},
      affiliateAddToCartUrl: json['affiliateAddToCartUrl']?.toString(),
      freeShippingOver35Dollars: json['freeShippingOver35Dollars'] as bool ?? false,
      availableOnline: json['availableOnline'] as bool ?? false,
      offerId: json['offerId']?.toString(),
    );
  }

  // Add a debug method to help track issues
  void debugPrint() {
    print('Product Details:');
    print('ID: $itemId');
    print('Name: $name');
    print('MSRP: $msrp');
    print('Sale Price: $salePrice');
    print('Image URL: $largeImage');
  }
} 