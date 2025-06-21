import 'package:flutter/material.dart';
import 'package:flutter_supabase_crud/detail_makanan.dart';

class RekomendasiMakananPage extends StatefulWidget {
  const RekomendasiMakananPage({super.key});

  @override
  State<RekomendasiMakananPage> createState() => _RekomendasiMakananPageState();
}

class _RekomendasiMakananPageState extends State<RekomendasiMakananPage> {
  String _rangeHarga = 'Rp. 10.000 - Rp. 20.000';

  final List<String> _rangePilihan = [
    'Rp. 5.000 - Rp. 10.000',
    'Rp. 10.000 - Rp. 20.000',
    'Rp. 20.000 - Rp. 30.000',
    'Rp. 30.000 - Rp. 50.000',
    'Rp. 50.000+',
  ];

  final List<MakananData> semuaMakanan = [
    // Rp. 5.000 - Rp. 10.000
    MakananData(
      'Bakso',
      5000,
      8000,
      'https://cdn-icons-png.flaticon.com/512/616/616408.png',
    ),
    MakananData(
      'Tahu Isi',
      6000,
      9000,
      'https://cdn-icons-png.flaticon.com/512/677/677745.png',
    ),
    MakananData(
      'Tempe Goreng',
      5000,
      7000,
      'https://cdn-icons-png.flaticon.com/512/3173/3173800.png',
    ),
    MakananData(
      'Es Teh Manis',
      3000,
      6000,
      'https://cdn-icons-png.flaticon.com/512/1046/1046784.png',
    ),
    MakananData(
      'Pisang Goreng',
      4000,
      9000,
      'https://cdn-icons-png.flaticon.com/512/5766/5766167.png',
    ),

    // Rp. 10.000 - Rp. 20.000
    MakananData(
      'Bubur Ayam',
      10000,
      15000,
      'https://cdn-icons-png.flaticon.com/512/5787/5787179.png',
    ),
    MakananData(
      'Nasi Goreng',
      10000,
      20000,
      'https://cdn-icons-png.flaticon.com/512/3173/3173844.png',
    ),
    MakananData(
      'Ayam Geprek',
      15000,
      20000,
      'https://cdn-icons-png.flaticon.com/512/1046/1046784.png',
    ),
    MakananData(
      'Mie Ayam',
      12000,
      18000,
      'https://cdn-icons-png.flaticon.com/512/5787/5787198.png',
    ),
    MakananData(
      'Nasi Uduk',
      10000,
      15000,
      'https://cdn-icons-png.flaticon.com/512/685/685352.png',
    ),

    // Rp. 20.000 - Rp. 30.000
    MakananData(
      'Sate Ayam',
      25000,
      30000,
      'https://cdn-icons-png.flaticon.com/512/2706/2706952.png',
    ),
    MakananData(
      'Ikan Bakar',
      20000,
      28000,
      'https://cdn-icons-png.flaticon.com/512/1046/1046797.png',
    ),
    MakananData(
      'Sop Buntut',
      22000,
      29000,
      'https://cdn-icons-png.flaticon.com/512/5787/5787192.png',
    ),
    MakananData(
      'Soto Betawi',
      22000,
      30000,
      'https://cdn-icons-png.flaticon.com/512/3173/3173801.png',
    ),
    MakananData(
      'Nasi Kuning Komplit',
      23000,
      30000,
      'https://cdn-icons-png.flaticon.com/512/3523/3523071.png',
    ),

    // Rp. 30.000 - Rp. 50.000
    MakananData(
      'Steak Ayam',
      35000,
      40000,
      'https://cdn-icons-png.flaticon.com/512/3523/3523063.png',
    ),
    MakananData(
      'Pizza Mini',
      30000,
      45000,
      'https://cdn-icons-png.flaticon.com/512/3132/3132693.png',
    ),
    MakananData(
      'Burger Besar',
      32000,
      42000,
      'https://cdn-icons-png.flaticon.com/512/3075/3075977.png',
    ),
    MakananData(
      'Spaghetti',
      30000,
      40000,
      'https://cdn-icons-png.flaticon.com/512/3173/3173850.png',
    ),
    MakananData(
      'Ayam Bakar Komplit',
      35000,
      50000,
      'https://cdn-icons-png.flaticon.com/512/1046/1046787.png',
    ),

    // Rp. 50.000+
    MakananData(
      'Steak Daging',
      55000,
      80000,
      'https://cdn-icons-png.flaticon.com/512/3523/3523063.png',
    ),
    MakananData(
      'Salmon Panggang',
      60000,
      75000,
      'https://cdn-icons-png.flaticon.com/512/1046/1046816.png',
    ),
    MakananData(
      'Lobster Bakar',
      70000,
      100000,
      'https://cdn-icons-png.flaticon.com/512/5787/5787173.png',
    ),
    MakananData(
      'Iga Bakar',
      60000,
      90000,
      'https://cdn-icons-png.flaticon.com/512/1046/1046785.png',
    ),
    MakananData(
      'Sushi Set',
      65000,
      85000,
      'https://cdn-icons-png.flaticon.com/512/1046/1046789.png',
    ),
  ];

  List<MakananData> makananDitampilkan = [];

  @override
  void initState() {
    super.initState();
    _filterMakanan();
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
          children:
              _rangePilihan.map((range) {
                return ListTile(
                  title: Text(range),
                  trailing:
                      _rangeHarga == range
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
      makananDitampilkan =
          semuaMakanan
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
            // Header tengah
            Container(
              width: double.infinity,
              color: const Color(0xFFB2846B),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              alignment: Alignment.center,
              child: const Text(
                'Mau Makan Apa Hari Ini?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            // Konten
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
                          children: [Text(_rangeHarga), const Icon(Icons.tune)],
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
                      child:
                          makananDitampilkan.isEmpty
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

            // Tombol kembali
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
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => DetailMakananPage(
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
