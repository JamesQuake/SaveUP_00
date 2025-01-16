import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:pointycastle/export.dart';
import 'package:basic_utils/basic_utils.dart';

class WalmartService {
  static const String baseUrl = 'https://developer.api.walmart.com/api-proxy/service/affil/product/v2/taxonomy';
  
  static const String consumerID = '6a706ded-9402-440e-afa3-b2215b51f63c';
  static const String keyVersion = '1';
  static const String privateKeyPEM = '''
-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDOx0I9d9FTjJ3o
GgjkXiV/7QEpY4b6+xlxC3IkoQDaKEK8L2TYr8U5ZKvZAak55SG/+yKwItONAi0z
5czdXlFgv7mtHktgSGQoq2S7UjvE6W7hMSGpdwNcqZpOPdH+Nef++wdrppLzJ4hD
7aNW+5nblkOPXPF6eewkkHu5pFNHOPp9vf6yoGFyFIzn/CTJGF6GUktAMhhzOa3U
+rxeV0rQJszdVf6Vq+JIC6IdZ4+vwTKFrrKW+IN9UUzamejoKB4G00yMyyJ06+w6
WkFUE1MH9lCYFyOxJyQU+yDM8lQveA+hyRrz12iNSevO+7ZEN6k/TxZF6yqcNNig
tZ/5ciXVAgMBAAECggEAJQNP3RbcdlseTNSUMOSVS8/NvG3fVH+r7ytAVEQpleNN
BshpAcx8vihCBocglodoQige7m5ddckk9Dw3Lozafjnzb4STs3lhzFHZpxoyLq4m
NdMIloACLw0A3O5970YQ7/hZPLDFbxbtclNQQJqq0L6V+0yEwQqf9W+TZgh/C6lZ
wDWxXUlmtJ3KnaHi/f4FeoQaW/BA2ikuJGxq2ioK9L/TaTnumzW1AUi1+sNk0Gcn
mSf2fx/XyY0MKuF85L4O7FWJsEfdxe34SMYT+c9FNLOs2VPQTk41W9gsN++UxLuu
krLpudWVpG14iZ1kGRYqJixDu+oSwWl5UaZvEIyUwQKBgQD3R2ncOmJF5xpDkfW3
WrckugvdCA0RZHOLSjAeXqK34uW5K8FYlmb44tTO6e35fwCnW02OTINCNnaojgw0
ltmAEIDjNVqv+bZP41KG7ByVNUNSUq4QRtyVO+BfQtvPBK+PNxP8dq4i1SDITd+V
PLOCyJSv7iIpY1Uk003d8D+bhQKBgQDWEi5NvoQodiBXAm8THELnbZMS7088pRCh
Yh+4EGbiFON/mtsd89PNBrqVaUJiinys8KWKhweqCcEuWZE5A+zsxs3iAJLRBVoB
iV3pJwO/VFPbWuQkG1kTyiqTcqerEORRk89+RgJJc2U9Gaw1I6laPcMnE1UGeIZu
qnkMMHEqEQKBgGeTbyEDB4TWL2ccLTsW8V2d3DhCFg8x7z/p3EvsQeYaUTUFwd/U
Z99aS987lyWJcAGpucuf+t7yJzOlBDHG+eWtg/8nqwvI4feGdVv0bGiHPeKupSBG
PkD4KpxcSevlv4+Sd3mpUHlgonGkRMGjAmIGmFk0uvRxGgnpxFTxPANtAoGAS3hz
bKNLMnya4DISeNlQ2QhvfpByDf5fw5W1ew4FR5V3sygkMgYhWLoTk9NdPSJ32/yn
UBRU5mSz/6RCJ6izobJhKVlsaVaKqdoFCsrfblfLjJ0Zq4UcvXZb1knoxM2awQvs
bic+bSjKu2TOqplc/lyh7afKJRLeyis9q8d0ThECgYEAolVeLulyxUC+9NNCRd6W
bjkBOonpVJYe7zRzRpcAyqgKmBazTl+XPZZ6qSWvEJV2ptm+Hv35BWincJyznYI/
Aub6hCcV5UrdyM5mrbKvNNMFrAgWyUpOAkgr+GsC001+JP47O6Nq6ou7WsqQVxRe
JW1bmFQ/Cd+zYrC46TqKdeU=
-----END PRIVATE KEY-----
''';

  String _canonicalize(Map<String, String> headers) {
    final sortedKeys = headers.keys.toList()..sort();
    final buffer = StringBuffer();
    
    for (var key in sortedKeys) {
      buffer.write(headers[key]?.trim());
      buffer.write('\n');
    }
    
    return buffer.toString();
  }

  String _generateSignature(String timestamp) {
    try {
      // Create headers map similar to Java implementation
      final headers = {
        'WM_CONSUMER.ID': consumerID,
        'WM_CONSUMER.INTIMESTAMP': timestamp,
        'WM_SEC.KEY_VERSION': keyVersion,
      };

      // Generate canonical string
      final stringToSign = _canonicalize(headers);
      print('String to sign: $stringToSign');

      // Parse private key
      final privateKey = CryptoUtils.rsaPrivateKeyFromPem(privateKeyPEM);
      
      // Create signer
      final signer = RSASigner(SHA256Digest(), '0609608648016503040201');
      signer.init(true, PrivateKeyParameter<RSAPrivateKey>(privateKey));
      
      // Sign the data
      final signatureBytes = signer.generateSignature(utf8.encode(stringToSign) as Uint8List);
      final signature = base64.encode(signatureBytes.bytes);
      
      print('Generated signature length: ${signature.length}');
      return signature;
    } catch (e) {
      print('Error generating signature: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getTaxonomy() async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final signature = _generateSignature(timestamp);

      print('Request details:');
      print('Timestamp: $timestamp');
      print('Consumer ID: $consumerID');
      print('Key Version: $keyVersion');
      print('Signature: $signature');
      
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'WM_SEC.KEY_VERSION': keyVersion,
          'WM_CONSUMER.ID': consumerID,
          'WM_CONSUMER.INTIMESTAMP': timestamp,
          'WM_SEC.AUTH_SIGNATURE': signature,
          'Accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load taxonomy: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getProducts({
    String categoryId,
    String nextPage,
  }) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final signature = _generateSignature(timestamp);
      
      Uri uri;
      if (nextPage != null) {
        uri = Uri.parse('https://developer.api.walmart.com$nextPage');
      } else {
        uri = Uri.parse('https://developer.api.walmart.com/api-proxy/service/affil/product/v2/paginated/items')
            .replace(queryParameters: {
          'category': categoryId,
          'count': '20',
          'shard': '0',
        });
      }

      print('Request URL: ${uri.toString()}');
      final response = await http.get(
        uri,
        headers: {
          'WM_SEC.KEY_VERSION': keyVersion,
          'WM_CONSUMER.ID': consumerID,
          'WM_CONSUMER.INTIMESTAMP': timestamp,
          'WM_SEC.AUTH_SIGNATURE': signature,
          'Accept': 'application/json',
        },
      );

      print('Products Response status: ${response.statusCode}');
      print('Products Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Decoded data: $data');
        return data;
      } else {
        throw Exception('Failed to load products: ${response.body}');
      }
    } catch (e) {
      print('Error fetching products: $e');
      rethrow;
    }
  }
} 