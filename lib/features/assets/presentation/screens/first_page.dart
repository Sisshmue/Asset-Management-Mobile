import '../../../../core/utils/navigation_provider.dart';
import 'profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dashboard_page.dart';

class FirstPage extends ConsumerStatefulWidget {
  const FirstPage({super.key});

  @override
  ConsumerState<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends ConsumerState<FirstPage> {
  void _showAddAssetSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        height: MediaQuery.of(context).size.height * 0.7,
        child: const Center(child: Text("Add Asset Form Goes Here")),
      ),
    );
  }

  final List<ScrollController> controllers = [
    ScrollController(),
    ScrollController(),
  ];

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(navigationProvider);
    final theme = Theme.of(context);
    final List<Widget> pages = [
      DashboardPage(scrollController: controllers[0]),
      const ProfilePage(),
    ];
    return Scaffold(
      // Extends the body behind the FAB/BottomBar if needed
      extendBody: true,
      body: IndexedStack(index: selectedIndex, children: pages),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAssetSheet(context),
        backgroundColor: theme.primaryColor, // Your Dark Blue
        shape: const CircleBorder(),
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Dashboard Tab
              _NavBarItem(
                icon: Icons.dashboard_customize_outlined,
                activeIcon: Icons.dashboard_customize,
                label: "Dashboard",
                isSelected: selectedIndex == 0,
                onTap: () {
                  if (selectedIndex == 0) {
                    controllers[selectedIndex].animateTo(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  } else {
                    ref.read(navigationProvider.notifier).state = 0;
                  }
                },
                theme: theme,
              ),

              // Spacer for the Floating Action Button
              const SizedBox(width: 40),

              // Profile Tab
              _NavBarItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: "Profile",
                isSelected: selectedIndex == 1,
                onTap: () => ref.read(navigationProvider.notifier).state = 1,
                theme: theme,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom widget for cleaner code
class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? theme.primaryColor : Colors.grey;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isSelected ? activeIcon : icon, color: color),
          Text(label, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}
