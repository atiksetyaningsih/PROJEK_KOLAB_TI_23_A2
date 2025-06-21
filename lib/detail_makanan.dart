import 'package:flutter/material.dart';

class DetailMakananPage extends StatefulWidget {
  final String nama;
  final String harga;
  final String gambar;

  const DetailMakananPage({
    super.key,
    required this.nama,
    required this.harga,
    required this.gambar,
  });

  @override
  State<DetailMakananPage> createState() => _DetailMakananPageState();
}

class _DetailMakananPageState extends State<DetailMakananPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  DateTime? tanggalPembelian;
  TimeOfDay? waktuPembelian;

  @override
  void initState() {
    super.initState();
    namaController.text = widget.nama;
    hargaController.text = widget.harga;
  }

  Future<void> _selectTanggal(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tanggalPembelian ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        tanggalPembelian = picked;
      });
    }
  }

  Future<void> _selectWaktu(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: waktuPembelian ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        waktuPembelian = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFD6AF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: const Color(0xFFB2846B),
                child: const Text(
                  'Detail Makanan',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Info Makanan
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.nama,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text("Harga ${widget.harga}"),
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.gambar,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                "Masukan Data Makanan",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: namaController,
                      decoration: const InputDecoration(
                        labelText: "Nama Makanan",
                      ),
                    ),
                    TextField(
                      controller: hargaController,
                      decoration: const InputDecoration(
                        labelText: "Harga Makanan",
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            tanggalPembelian != null
                                ? "Tanggal: ${tanggalPembelian!.toLocal().toString().split(' ')[0]}"
                                : "Tanggal Pembelian: -",
                          ),
                        ),
                        TextButton(
                          onPressed: () => _selectTanggal(context),
                          child: const Text("Pilih Tanggal"),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            waktuPembelian != null
                                ? "Waktu: ${waktuPembelian!.format(context)}"
                                : "Waktu Pembelian: -",
                          ),
                        ),
                        TextButton(
                          onPressed: () => _selectWaktu(context),
                          child: const Text("Pilih Waktu"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // aksi simpan
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB2846B),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text("Simpan"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        namaController.clear();
                        hargaController.clear();
                        tanggalPembelian = null;
                        waktuPembelian = null;
                      });
                      // aksi batal
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown.shade200,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text("Batal"),
                  ),
                ],
              ),

              const Spacer(),
              Align(
                alignment: Alignment.bottomLeft,
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
      ),
    );
  }
}
