import 'package:http/http.dart' as http;

Future<String> getNativeTransaction(String address, String chain) async {
  final url = Uri.http('192.168.1.8:5002', '/get_native_transaction', {
    'address': address,
    'chain': chain,
  });

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to get balances');
  }
}

Future<String> getERCTransaction(String address, String chain) async {
  final url = Uri.http('192.168.1.8:5002', '/get_erc_transaction', {
    'address': address,
    'chain': chain,
  });

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to get balances');
  }
}

Future<String> getDecodedTransaction(String address, String chain) async {
  final url = Uri.http('192.168.1.8:5002', '/get_decode_transaction', {
    'address': address,
    'chain': chain,
  });

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to get balances');
  }
}
