import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiGamesHiggs {
  Future<String> getUsername(String userId) async {
    const String baseUrl = 'https://v1.apigames.id/merchant/M240201QYUF6479QY/cek-username/higgs';
    final Uri uri = Uri.parse('$baseUrl?user_id=$userId&signature=26f88aca3e2cff5d4b6246a40a51aebb');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 1 && responseData['rc'] == 0) {
        return responseData['data']['username'];
      } else {
       
        return '';
      }
    } else {
      return '';
    }
  }
}
