import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'login.dart';
import 'profil_page.dart';
import 'rekomendasi.dart';
import 'catatan_pengeluaran.dart'; // Pastikan file ini sudah ada

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int totalPengeluaran = 0;

  @override
  void initState() {
    super.initState();
    _loadTotalPengeluaran();
  }

  Future<void> _loadTotalPengeluaran() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) return;

    final now = DateTime.now();
    final awalBulan = DateTime(now.year, now.month, 1);
    final akhirBulan = DateTime(now.year, now.month + 1, 0);

    final response = await supabase
        .from('pengeluaran')
        .select('harga_beli')
        .eq('user_id', user.id)
        .gte('tanggal_beli', awalBulan.toIso8601String())
        .lte('tanggal_beli', akhirBulan.toIso8601String());

    int total = 0;
    for (var item in response) {
      total += (item['harga_beli'] ?? 0) as int;
    }

    setState(() {
      totalPengeluaran = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: const Color(0xFF8B5E3C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Kotak atas: Pengeluaran dan Profil
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBox(
                  context: context,
                  icon: Icons.monetization_on,
                  title: NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(totalPengeluaran),
                  subtitle: 'Bulan ini',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CatatanPengeluaranPage()),
                    );
                  },
                ),
                _buildBox(
                  context: context,
                  icon: Icons.person,
                  title: 'Profil',
                  subtitle: '',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfilePage()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 25),

            // Kotak tengah: Makan apa hari ini
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RekomendasiMakananPage(),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE0B2),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Mau makan apa hari ini?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Tombol Logout
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Supabase.instance.client.auth.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        },
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.logout),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildBox({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 130,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3E0),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Colors.brown),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle.isNotEmpty)
                Text(subtitle, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}
