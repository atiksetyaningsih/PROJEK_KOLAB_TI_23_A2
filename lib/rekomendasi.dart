import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_supabase_crud/detail_makanan.dart';

class RekomendasiMakananPage extends StatefulWidget {
  const RekomendasiMakananPage({super.key});

  @override
  State<RekomendasiMakananPage> createState() => _RekomendasiMakananPageState();
}

class _RekomendasiMakananPageState extends State<RekomendasiMakananPage> {
  final supabase = Supabase.instance.client;

  String _rangeHarga = 'Rp. 10.000 - Rp. 20.000';
  final List<String> _rangePilihan = [
    'Rp. 5.000 - Rp. 10.000',
    'Rp. 10.000 - Rp. 20.000',
    'Rp. 20.000 - Rp. 30.000',
    'Rp. 30.000 - Rp. 50.000',
    'Rp. 50.000+',
  ];

  List<MakananData> semuaMakanan = [];
  List<MakananData> makananDitampilkan = [];

  @override
  void initState() {
    super.initState();
    _loadMakananDariSupabase();
  }

  void _loadMakananDariSupabase() async {
    final response = await supabase.from('makanan').select();

    setState(() {
      semuaMakanan = response.map<MakananData>((data) {
        return MakananData(
          data['nama'],
          data['harga_min'],
          data['harga_max'],
          data['gambar_url'],
        );
      }).toList();

      _filterMakanan();
    });
  }

  void _ubahRangeHarga() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: _rangePilihan.map((range) {
            return ListTile(
              title: Text(range),
              trailing: _rangeHarga == range
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () {
                setState(() {
                  _rangeHarga = range;
                  _filterMakanan();
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _filterMakanan() {
    int min = 0;
    int max = 9999999;

    if (_rangeHarga.contains('Rp.') && _rangeHarga.contains('-')) {
      final parts = _rangeHarga.replaceAll('Rp.', '').split('-');
      min = int.parse(parts[0].replaceAll('.', '').trim());
      max = int.parse(parts[1].replaceAll('.', '').trim());
    } else if (_rangeHarga.contains('+')) {
      min = int.parse(_rangeHarga.replaceAll(RegExp(r'[^\d]'), ''));
    }

    setState(() {
      makananDitampilkan = semuaMakanan
          .where((m) => m.hargaMin >= min && m.hargaMax <= max)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFD6AF),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: const Color(0xFFB2846B),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              alignment: Alignment.center,
              child: const Text(
                'Mau Makan Apa Hari Ini?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Range Harga',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _ubahRangeHarga,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_rangeHarga),
                            const Icon(Icons.tune)
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Rekomendasi\nMakanan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: makananDitampilkan.isEmpty
                          ? const Center(
                              child: Text(
                                'Tidak ada makanan ditemukan.',
                                style: TextStyle(color: Colors.black54),
                              ),
                            )
                          : ListView.builder(
                              itemCount: makananDitampilkan.length,
                              itemBuilder: (context, index) {
                                final m = makananDitampilkan[index];
                                return MakananItem(
                                  nama: m.nama,
                                  harga:
                                      'Rp. ${m.hargaMin} - Rp. ${m.hargaMax}',
                                  gambar: m.gambar,
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 12),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.blue),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MakananData {
  final String nama;
  final int hargaMin;
  final int hargaMax;
  final String gambar;

  MakananData(this.nama, this.hargaMin, this.hargaMax, this.gambar);
}

class MakananItem extends StatelessWidget {
  final String nama, harga, gambar;

  const MakananItem({
    super.key,
    required this.nama,
    required this.harga,
    required this.gambar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(harga),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              gambar,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 50),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailMakananPage(
                    nama: nama,
                    harga: harga,
                    gambar: gambar,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB2846B),
              shape: const StadiumBorder(),
            ),
            child: const Text("Pilih"),
          ),
        ],
      ),
    );
  }
}