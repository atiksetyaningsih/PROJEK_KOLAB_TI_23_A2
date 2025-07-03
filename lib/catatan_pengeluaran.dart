import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class CatatanPengeluaranPage extends StatefulWidget {
  const CatatanPengeluaranPage({super.key});

  @override
  State<CatatanPengeluaranPage> createState() => _CatatanPengeluaranPageState();
}

class _CatatanPengeluaranPageState extends State<CatatanPengeluaranPage> {
  List<dynamic> pengeluaran = [];
  DateTime? selectedDate;

  final formatRupiah = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _loadPengeluaran();
  }

  Future<void> _loadPengeluaran() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) return;

    var query = supabase.from('pengeluaran').select().eq('user_id', user.id);

    if (selectedDate != null) {
      final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate!);
      query = query.eq('tanggal_beli', dateStr);
    }

    final data = await query.order('tanggal_beli', ascending: false).order('waktu_beli');

    if (!mounted) return; // Cegah error setState setelah dispose
    setState(() {
      pengeluaran = data;
    });
  }

  Future<void> _hapusPengeluaran(String id) async {
    final supabase = Supabase.instance.client;

    final response = await supabase
        .from('pengeluaran')
        .delete()
        .eq('id', id);

    // Cek respon, dan reload jika berhasil
    if (!mounted) return;
    _loadPengeluaran();
  }

  void _editPengeluaran(Map item) {
    final nama = item['nama_makanan'];
    final harga = item['harga_beli'].toString();

    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController namaController = TextEditingController(text: nama);
        final TextEditingController hargaController = TextEditingController(text: harga);
        return AlertDialog(
          title: const Text("Edit Pengeluaran"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: namaController, decoration: const InputDecoration(labelText: 'Nama')),
              TextField(controller: hargaController, decoration: const InputDecoration(labelText: 'Harga'), keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final supabase = Supabase.instance.client;
                await supabase.from('pengeluaran').update({
                  'nama_makanan': namaController.text,
                  'harga_beli': int.tryParse(hargaController.text) ?? 0,
                }).eq('id', item['id']);
                if (!mounted) return;
                Navigator.of(context).pop();
                _loadPengeluaran();
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      _loadPengeluaran();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFD6AF),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: const Color(0xFFB2846B),
              child: const Text(
                'Catatan Pengeluaran\nBulanan',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: _selectDate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB2846B),
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    ),
                    child: Text(
                      selectedDate == null
                          ? "Pilih Tanggal"
                          : DateFormat('yyyy-MM-dd').format(selectedDate!),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (selectedDate != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          selectedDate = null;
                        });
                        _loadPengeluaran();
                      },
                    )
                ],
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: pengeluaran.isEmpty
                    ? const Center(child: Text("Belum ada pengeluaran."))
                    : ListView(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDF1E7),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (pengeluaran.isNotEmpty)
                                  Text(
                                    pengeluaran.first['tanggal_beli'] ?? '',
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                const SizedBox(height: 12),

                                ...pengeluaran.map((item) {
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('${item['waktu_beli']}\n${item['nama_makanan']}'),
                                          Row(
                                            children: [
                                              Text(formatRupiah.format(item['harga_beli'])),
                                              IconButton(
                                                icon: const Icon(Icons.edit, size: 18),
                                                onPressed: () => _editPengeluaran(item),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete, size: 18),
                                                onPressed: () async {
                                                  final confirm = await showDialog<bool>(
                                                    context: context,
                                                    builder: (ctx) => AlertDialog(
                                                      title: const Text('Konfirmasi'),
                                                      content: const Text('Yakin ingin menghapus data ini?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () => Navigator.pop(ctx, false),
                                                          child: const Text('Batal'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () => Navigator.pop(ctx, true),
                                                          child: const Text('Hapus'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                  if (confirm == true) {
                                                    await _hapusPengeluaran(item['id'].toString());
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                    ],
                                  );
                                }).toList(),

                                const Divider(height: 24, color: Colors.black54),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total Pengeluaran',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      formatRupiah.format(
                                        pengeluaran.fold<int>(0, (sum, item) => sum + (item['harga_beli'] as int)),
                                      ),
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB2846B),
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text(
                'BACK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}