import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageRepo {
  final SupabaseClient client = Supabase.instance.client;

  Future<List<String>> uploadImages(List<File> images) async {
    List<String> imageUrls = [];
    try {
      final storage = client.storage;
      for (int i = 0; i < images.length; i++) {
        final fileName =
            'attachments/${DateTime.now().millisecondsSinceEpoch}_image$i.jpg';
        await storage.from('attachments').upload(fileName, images[i]);

        // Get the public URL of the uploaded image
        final fileUrl = storage.from('attachments').getPublicUrl(fileName);
        imageUrls.add(fileUrl);
      }
    } catch (e) {
      throw Exception("Error uploading images: $e");
    }
    return imageUrls;
  }
}
