import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/localization/app_language_provider.dart';
import 'package:physioghar/core/theme/app_colors.dart';
import 'package:physioghar/features/dashboard/presentation/dashboard_screen.dart';
import 'package:physioghar/features/patients/presentation/patients_screen.dart';
import 'package:physioghar/features/profile/presentation/account_screen.dart';
import 'package:physioghar/features/schedule/presentation/schedule_screen.dart';
import 'package:physioghar/features/sessions/presentation/sessions_screen.dart';
import 'package:physioghar/features/sessions/providers/sessions_provider.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _currentIndex = 0;

  void _onSelectTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pendingRequestsCount = ref.watch(pendingRequestsCountProvider);

    final screens = [
      DashboardScreen(
        onNavigateTab: _onSelectTab,
        onProfileTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AccountScreen()),
          );
        },
      ),
      const ScheduleScreen(),
      const SessionsScreen(),
      const PatientsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: PhysioColors.white,
          border: Border(
            top: BorderSide(color: PhysioColors.mist, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0x0A1E2A2E),
              blurRadius: 10,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onSelectTab,
          type: BottomNavigationBarType.fixed,
          backgroundColor: PhysioColors.white,
          selectedItemColor: PhysioColors.pine,
          unselectedItemColor: PhysioColors.inkMute,
          selectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined, size: 22),
              activeIcon: Icon(Icons.dashboard_rounded, size: 22),
              label: context.tr('nav_dashboard'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined, size: 22),
              activeIcon: Icon(Icons.calendar_month_rounded, size: 22),
              label: context.tr('nav_schedule'),
            ),
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(Icons.healing_outlined, size: 22),
                  if (pendingRequestsCount > 0)
                    Positioned(
                      top: -4,
                      right: -6,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: PhysioColors.amber,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$pendingRequestsCount',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              activeIcon: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(Icons.healing_rounded, size: 22),
                  if (pendingRequestsCount > 0)
                    Positioned(
                      top: -4,
                      right: -6,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: PhysioColors.amber,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$pendingRequestsCount',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              label: context.tr('nav_sessions'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline_rounded, size: 22),
              activeIcon: Icon(Icons.people_rounded, size: 22),
              label: context.tr('nav_patients'),
            ),
          ],
        ),
      ),
    );
  }
}
