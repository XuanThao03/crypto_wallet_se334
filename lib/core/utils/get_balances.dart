import 'package:http/http.dart' as http;

Future<String> getNativeBalances(String address, String chain) async {
  final url = Uri.http('192.168.1.8:5002', '/get_token_balance', {
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

Future<String> getERCBalances(String address, String chain) async {
  final url = Uri.http('192.168.1.8:5002', '/get_erc_balance', {
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
