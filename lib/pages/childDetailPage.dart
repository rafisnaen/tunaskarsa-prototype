import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tunaskarsa/providers/userProvider.dart';

class ChildDetailPage extends StatefulWidget {
  final String childId;

  const ChildDetailPage({super.key, required this.childId});

  @override
  State<ChildDetailPage> createState() => _ChildDetailPageState();
}

class _ChildDetailPageState extends State<ChildDetailPage> {
  int? _screenTime;
  final _screenTimeController = TextEditingController();

  @override
  void dispose() {
    _screenTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final child = userProvider.getChildById(widget.childId);

    if (child == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Anak'),
        ),
        body: const Center(
          child: Text('Anak tidak ditemukan atau Anda tidak memiliki akses.'),
        ),
      );
    }

    // Hanya orang tua yang bisa mengatur screen time
    if (userProvider.loggedInUser?.role != 'Orang Tua') {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Anak'),
        ),
        body: const Center(
          child: Text('Hanya orang tua yang dapat mengatur screen time.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Anak: ${child.username}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Nama: ${child.username}'),
            Text('Email: ${child.email}'),
            Text('Grade: ${child.grade ?? 'N/A'}'),
            const SizedBox(height: 20),
            if (child.screenTime != null)
              Text('Screen Time Tersisa: ${child.screenTime} menit'),
            const SizedBox(height: 20),
            if (userProvider.loggedInUser?.role == 'Orang Tua') ...[
              TextField(
                controller: _screenTimeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Set Screen Time (menit)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _screenTime = int.tryParse(value);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_screenTime != null) {
                    userProvider.saveScreenTime(child.id, _screenTime!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Screen time berhasil diperbarui')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Masukkan waktu layar yang valid')),
                    );
                  }
                },
                child: const Text('Simpan Screen Time'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
