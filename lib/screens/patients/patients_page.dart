import 'package:flutter/material.dart';
import 'patient_detail_page.dart'; // ★ これで詳細画面に飛べる

class PatientsPage extends StatelessWidget {
  const PatientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final patients = [
      const _Patient(
        name: '山田 花子',
        tag: '初回 / 二重',
        lastVisit: '2025-11-05',
      ),
      const _Patient(
        name: '佐藤 太郎',
        tag: '手術前 / 鼻',
        lastVisit: '2025-11-02',
      ),
      const _Patient(
        name: '鈴木 一郎',
        tag: 'リピーター / 糸リフト',
        lastVisit: '2025-10-28',
      ),
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            decoration: InputDecoration(
              hintText: '名前や施術メニューで検索',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              isDense: true,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final p = patients[index];
              return _PatientCard(patient: p);
            },
          ),
        ),
      ],
    );
  }
}

class _Patient {
  final String name;
  final String tag;
  final String lastVisit;

  const _Patient({
    required this.name,
    required this.tag,
    required this.lastVisit,
  });
}

class _PatientCard extends StatelessWidget {
  final _Patient patient;

  const _PatientCard({required this.patient});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: scheme.secondaryContainer,
          child: Text(
            patient.name.substring(0, 1),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(patient.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              patient.tag,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 2),
            Text(
              '最終来院: ${patient.lastVisit}',
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // ★ タップで詳細画面へ遷移
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PatientDetailPage(
                name: patient.name,
                tag: patient.tag,
                lastVisit: patient.lastVisit,
              ),
            ),
          );
        },
      ),
    );
  }
}
