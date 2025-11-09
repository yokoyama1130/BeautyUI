import 'package:flutter/material.dart';
import 'screens/home/home_page.dart';
import 'screens/patients/patients_page.dart';
import 'screens/scan/scan_home_page.dart';
import 'screens/appointments/add_appointment_page.dart';
import 'screens/patients/add_patient_page.dart';
import 'screens/profile/counselor_profile_page.dart';

void main() {
  runApp(const CounselorApp());
}

class CounselorApp extends StatelessWidget {
  const CounselorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '美容外科カウンセラー補助',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFF18CB8), // 柔らかいピンク系
        scaffoldBackgroundColor: const Color(0xFFFDF7FA),
        fontFamily: 'Roboto',
      ),
      home: const RootTabPage(),
    );
  }
}

class RootTabPage extends StatefulWidget {
  const RootTabPage({super.key});

  @override
  State<RootTabPage> createState() => _RootTabPageState();
}

class _RootTabPageState extends State<RootTabPage> {
  int _currentIndex = 0;

  final _pages = const [
    HomePage(),
    PatientsPage(),
    ScanHomePage(),
    AddAppointmentPage(),
    AddPatientPage(),
    CounselorProfilePage(), // ★ プロフィール追加
  ];

  final _titles = const [
    'ホーム',
    '患者一覧',
    '顔スキャン',
    '予約追加',
    '患者追加',
    'プロフィール', // ★ タイトル追加
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        centerTitle: true,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'ホーム',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: '患者',
          ),
          NavigationDestination(
            icon: Icon(Icons.camera_alt_outlined),
            selectedIcon: Icon(Icons.camera_alt),
            label: 'スキャン',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_available_outlined),
            selectedIcon: Icon(Icons.event_available),
            label: '予約追加',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_add_alt_outlined),
            selectedIcon: Icon(Icons.person_add_alt_1),
            label: '患者追加',
          ),
          NavigationDestination(
            icon: Icon(Icons.badge_outlined),
            selectedIcon: Icon(Icons.badge),
            label: 'プロフィール',
          ),
        ],
      ),
    );
  }
}
