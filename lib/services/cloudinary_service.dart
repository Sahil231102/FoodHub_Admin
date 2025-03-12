import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String cloudName = "dh8y6kjeg";
  static const String apiKey = "957497136749269";
  static const String apiSecret = "qEq8SCxF_bnjv4HOerDB7K_yjAQ";
  static const String uploadUrl =
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload";

  static Future<String?> uploadImage(Uint8List fileBytes) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse(uploadUrl));
      request.fields['upload_preset'] = "food_image";
      request.files.add(http.MultipartFile.fromBytes('file', fileBytes,
          filename: "food_image.jpg"));
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonData = json.decode(responseData);

      if (response.statusCode == 200) {
        return jsonData["secure_url"];
      } else {
        print(
            "Cloudinary Error: ${jsonData['error']?['message'] ?? 'Unknown error'}");
        return null;
      }
    } catch (e) {
      print("Cloudinary Upload Error: $e");
      return null;
    }
  }
}
