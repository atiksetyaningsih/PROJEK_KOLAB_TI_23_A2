import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final supabase = Supabase.instance.client;
  String? email;
  String? username;
  String? avatarUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final data = await supabase
          .from('Users')
          .select('username, avatar_url')
          .eq('id', user.id)
          .single();

      setState(() {
        email = user.email;
        username = data['username'];
        avatarUrl = data['avatar_url'];
      });
    }
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final user = supabase.auth.currentUser!;
    final fileName = 'avatar_${user.id}.png';

    try {
      if (kIsWeb) {
        // Web pakai bytes
        final bytes = await picked.readAsBytes();
        await supabase.storage
            .from('avatars')
            .uploadBinary(fileName, bytes, fileOptions: const FileOptions(upsert: true));
      } else {
        // Mobile pakai path
        final fileBytes = await picked.readAsBytes();
        await supabase.storage
            .from('avatars')
            .uploadBinary(fileName, fileBytes, fileOptions: const FileOptions(upsert: true));
      }

      // Ambil URL publik file
      final publicUrl = supabase.storage.from('avatars').getPublicUrl(fileName);

      // Simpan ke tabel Users
      await supabase
          .from('Users')
          .update({'avatar_url': publicUrl})
          .eq('id', user.id);

      setState(() => avatarUrl = publicUrl);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto berhasil diunggah!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal upload: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5E4),
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: const Color(0xFF8B5E3C),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
              child: avatarUrl == null ? const Icon(Icons.person, size: 60) : null,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickAndUploadImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Ganti Foto Profil'),
            ),
            const SizedBox(height: 24),
            _infoTile('👤 Username', username ?? '-'),
            _infoTile('📧 Email', email ?? '-'),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String title, String value) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEFD5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(value),
          ],
        ),
      );
}
