import 'package:flutter/material.dart';

class AddAppointmentPage extends StatelessWidget {
  const AddAppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '患者',
                style: TextStyle(
                  fontSize: 13,
                  color: scheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 4),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: '患者名で検索、または新規入力',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                '日時',
                style: TextStyle(
                  fontSize: 13,
                  color: scheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: const InputDecoration(
                        hintText: '日付を選択',
                        prefixIcon: Icon(Icons.calendar_today_outlined),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      // TODO: 日付ピッカー
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 110,
                    child: TextFormField(
                      readOnly: true,
                      decoration: const InputDecoration(
                        hintText: '時間',
                        prefixIcon: Icon(Icons.schedule_outlined),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      // TODO: 時刻ピッカー
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                'メニュー',
                style: TextStyle(
                  fontSize: 13,
                  color: scheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 4),
              DropdownButtonFormField<String>(
                items: const [
                  DropdownMenuItem(
                    value: 'double',
                    child: Text('二重整形（埋没）'),
                  ),
                  DropdownMenuItem(
                    value: 'nose',
                    child: Text('鼻整形'),
                  ),
                  DropdownMenuItem(
                    value: 'contour',
                    child: Text('輪郭・骨切り'),
                  ),
                  DropdownMenuItem(
                    value: 'thread',
                    child: Text('糸リフト'),
                  ),
                ],
                onChanged: (_) {},
                decoration: const InputDecoration(
                  hintText: '施術メニューを選択',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'ステータス',
                style: TextStyle(
                  fontSize: 13,
                  color: scheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 4),
              DropdownButtonFormField<String>(
                items: const [
                  DropdownMenuItem(
                    value: 'counseling',
                    child: Text('カウンセリング'),
                  ),
                  DropdownMenuItem(
                    value: 'pre_op',
                    child: Text('手術前説明'),
                  ),
                  DropdownMenuItem(
                    value: 'operation',
                    child: Text('手術'),
                  ),
                  DropdownMenuItem(
                    value: 'follow',
                    child: Text('術後経過'),
                  ),
                ],
                onChanged: (_) {},
                decoration: const InputDecoration(
                  hintText: '予約の種類',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'メモ（希望・注意点など）',
                style: TextStyle(
                  fontSize: 13,
                  color: scheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 4),
              TextFormField(
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: '例）ダウンタイム1週間以内希望／インフルエンサー◯◯さんのような目になりたい',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    // TODO: Go/Python の API に POST して予約登録
                    FocusScope.of(context).unfocus();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('保存：予約を登録しました')),
                    );
                  },
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('予約を保存'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
