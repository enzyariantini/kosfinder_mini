import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KosFinder Mini',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const KosFinderHome(),
    );
  }
}

class Kost {
  const Kost({
    required this.name,
    required this.location,
    required this.pricePerMonth,
    required this.description,
    this.isFavorite = false,
  });

  final String name;
  final String location;
  final int pricePerMonth;
  final String description;
  final bool isFavorite;
}

class KosFinderHome extends StatefulWidget {
  const KosFinderHome({super.key});

  @override
  State<KosFinderHome> createState() => _KosFinderHomeState();
}

class _KosFinderHomeState extends State<KosFinderHome> {
  final List<Kost> _kosts = [
    const Kost(
      name: 'Kos Melati',
      location: 'Jl. Melati No. 12, Sleman',
      pricePerMonth: 850000,
      description: 'Kamar nyaman, Wi-Fi, kamar mandi dalam.',
    ),
    const Kost(
      name: 'Kos Mawar Putih',
      location: 'Jl. Mawar No. 8, Depok',
      pricePerMonth: 1100000,
      description: 'Lokasi strategis dekat kampus dan minimarket.',
    ),
    const Kost(
      name: 'Kos Anggrek',
      location: 'Jl. Anggrek Raya, Condongcatur',
      pricePerMonth: 950000,
      description: 'Lingkungan tenang dengan dapur bersama.',
    ),
    const Kost(
      name: 'Kos Griya Sejahtera',
      location: 'Jl. Kaliurang Km. 5, Yogyakarta',
      pricePerMonth: 1250000,
      description: 'Fasilitas lengkap, keamanan 24 jam, dan parkir.',
    ),
    const Kost(
      name: 'Kos Dahlia',
      location: 'Jl. Dahlia No. 21, Karangmalang',
      pricePerMonth: 800000,
      description: 'Dekat halte dan area kuliner mahasiswa.',
    ),
    const Kost(
      name: 'Kos Cendana',
      location: 'Jl. Cendana 7, Babarsari',
      pricePerMonth: 1000000,
      description: 'Kamar bersih, laundry bulanan, dan air panas.',
    ),
  ];

  String _searchQuery = '';

  void _toggleFavorite(int index) {
    setState(() {
      final kost = _kosts[index];
      _kosts[index] = Kost(
        name: kost.name,
        location: kost.location,
        pricePerMonth: kost.pricePerMonth,
        description: kost.description,
        isFavorite: !kost.isFavorite,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchQuery.toLowerCase();
    final filteredKosts = _kosts.where((kost) {
      return kost.name.toLowerCase().contains(query) ||
          kost.location.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('KosFinder Mini'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari nama atau lokasi kos',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${filteredKosts.length} kos ditemukan',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: filteredKosts.isEmpty
                  ? const Center(child: Text('Kos tidak ditemukan'))
                  : ListView.builder(
                      itemCount: filteredKosts.length,
                      itemBuilder: (context, index) {
                        final kost = filteredKosts[index];
                        final originalIndex = _kosts.indexOf(kost);
                        return KostCard(
                          kost: kost,
                          onFavoritePressed: () {
                            _toggleFavorite(originalIndex);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class KostCard extends StatelessWidget {
  const KostCard({
    super.key,
    required this.kost,
    required this.onFavoritePressed,
  });

  final Kost kost;
  final VoidCallback onFavoritePressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    kost.name,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: onFavoritePressed,
                  icon: Icon(
                    kost.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: kost.isFavorite ? Colors.red : Colors.grey,
                  ),
                  tooltip: kost.isFavorite
                      ? 'Hapus dari favorit'
                      : 'Tambah ke favorit',
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 18),
                const SizedBox(width: 4),
                Expanded(child: Text(kost.location)),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Rp ${_formatPrice(kost.pricePerMonth)} / bulan',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(kost.description),
          ],
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    final value = price.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < value.length; i++) {
      final positionFromEnd = value.length - i;
      buffer.write(value[i]);
      if (positionFromEnd > 1 && positionFromEnd % 3 == 1) {
        buffer.write('.');
      }
    }

    return buffer.toString();
  }
}
