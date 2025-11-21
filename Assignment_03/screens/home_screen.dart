// screens/home_screen.dart
import 'package:flutter/material.dart';
import '../models/device_model.dart';
import '../widgets/device_card.dart';
import 'device_details_screen.dart';
import 'add_device_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  // Sample initial devices
  List<Device> devices = [
    Device(
      id: '1',
      name: 'Living Room Light',
      type: DeviceType.light,
      room: 'Living Room',
      isOn: true,
      value: 75.0,
    ),
    Device(
      id: '2',
      name: 'Bedroom Fan',
      type: DeviceType.fan,
      room: 'Bedroom',
      isOn: false,
      value: 50.0,
    ),
    Device(
      id: '3',
      name: 'Kitchen AC',
      type: DeviceType.ac,
      room: 'Kitchen',
      isOn: true,
      value: 22.0,
    ),
    Device(
      id: '4',
      name: 'Front Door Camera',
      type: DeviceType.camera,
      room: 'Entrance',
      isOn: true,
      value: 100.0,
    ),
  ];

  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize FAB animation
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fabAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    );

    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  /// Toggle device on/off status
  void _toggleDevice(String deviceId) {
    setState(() {
      final index = devices.indexWhere((d) => d.id == deviceId);
      if (index != -1) {
        devices[index] = devices[index].copyWith(isOn: !devices[index].isOn);
      }
    });
  }

  /// Update device value (brightness, speed, etc.)
  void _updateDeviceValue(String deviceId, double newValue) {
    setState(() {
      final index = devices.indexWhere((d) => d.id == deviceId);
      if (index != -1) {
        devices[index] = devices[index].copyWith(value: newValue);
      }
    });
  }

  /// Navigate to device details
  void _navigateToDetails(Device device) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeviceDetailsScreen(
          device: device,
          onToggle: () => _toggleDevice(device.id),
          onValueChanged: (value) => _updateDeviceValue(device.id, value),
        ),
      ),
    );
  }

  /// Add new device
  void _addDevice(Device newDevice) {
    setState(() {
      devices.add(newDevice);
    });
  }

  /// Show add device screen
  void _showAddDeviceScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddDeviceScreen(onDeviceAdded: _addDevice),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('Smart Home Dashboard'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: SafeArea(
        child: devices.isEmpty ? _buildEmptyState() : _buildDeviceGrid(),
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton.extended(
          onPressed: _showAddDeviceScreen,
          icon: const Icon(Icons.add),
          label: const Text('Add Device'),
          heroTag: 'addDeviceFAB',
        ),
      ),
    );
  }

  /// Build device grid layout
  Widget _buildDeviceGrid() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          Text(
            'My Devices',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '${devices.where((d) => d.isOn).length} of ${devices.length} devices are ON',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),

          // Device grid
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: devices.length,
              itemBuilder: (context, index) {
                return DeviceCard(
                  device: devices[index],
                  onToggle: () => _toggleDevice(devices[index].id),
                  onTap: () => _navigateToDetails(devices[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }


  /// Build empty state when no devices
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.devices_other,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 20),
          Text(
            'No Devices Added',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Tap the button below to add your first device',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build navigation drawer
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 35, color: Color(0xFF6C63FF)),
                ),
                SizedBox(height: 10),
                Text(
                  'Smart Home',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Control your devices',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Dashboard'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.devices),
            title: const Text('All Devices'),
            trailing: Chip(
              label: Text('${devices.length}'),
              backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            ),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.room),
            title: const Text('Rooms'),
            onTap: () => Navigator.pop(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Support'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}