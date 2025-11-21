// screens/device_details_screen.dart
import 'package:flutter/material.dart';
import '../models/device_model.dart';

class DeviceDetailsScreen extends StatefulWidget {
  final Device device;
  final VoidCallback onToggle;
  final Function(double) onValueChanged;

  const DeviceDetailsScreen({
    super.key,
    required this.device,
    required this.onToggle,
    required this.onValueChanged,
  });

  @override
  State<DeviceDetailsScreen> createState() => _DeviceDetailsScreenState();
}

class _DeviceDetailsScreenState extends State<DeviceDetailsScreen>
    with SingleTickerProviderStateMixin {
  late double _currentValue;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.device.value;

    // Pulse animation for the device icon
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.device.color.withValues(alpha: 0.05),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back, color: Color(0xFF6C63FF)),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Device Control',
          style: TextStyle(color: Color(0xFF2D3436)),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Device Icon with Hero Animation and Pulse
              Hero(
                tag: 'device_${widget.device.id}',
                child: ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: widget.device.isOn
                          ? widget.device.color.withOpacity(0.2)
                          : Colors.grey[200],
                      shape: BoxShape.circle,
                      boxShadow: widget.device.isOn
                          ? [
                        BoxShadow(
                          color: widget.device.color.withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ]
                          : [],
                    ),
                    child: Icon(
                      widget.device.icon,
                      size: 100,
                      color: widget.device.isOn
                          ? widget.device.color
                          : Colors.grey,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Device Name
              Text(
                widget.device.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // Room and Type
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.room, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.device.room} • ${widget.device.typeName}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Status Card
              _buildStatusCard(),

              const SizedBox(height: 30),

              // Control Slider
              if (widget.device.type != DeviceType.camera)
                _buildControlSlider(),

              const SizedBox(height: 30),

              // Toggle Button
              _buildToggleButton(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedCrossFade(
                  firstChild: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: widget.device.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Active',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3436),
                        ),
                      ),
                    ],
                  ),
                  secondChild: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Inactive',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  crossFadeState: widget.device.isOn
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 300),
                ),
              ],
            ),
          ),
          Icon(
            widget.device.isOn ? Icons.check_circle : Icons.cancel,
            size: 50,
            color: widget.device.isOn ? widget.device.color : Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildControlSlider() {
    String unit = widget.device.type == DeviceType.ac ? '°C' : '%';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.device.controlLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3436),
                ),
              ),
              Text(
                '${_currentValue.toInt()}$unit',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: widget.device.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: widget.device.color,
              inactiveTrackColor: widget.device.color.withValues(alpha: 0.2),
              thumbColor: widget.device.color,
              overlayColor: widget.device.color.withValues(alpha: 0.2),
              trackHeight: 8,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            ),
            child: Slider(
              value: _currentValue,
              min: widget.device.type == DeviceType.ac ? 16.0 : 0.0,
              max: widget.device.type == DeviceType.ac ? 30.0 : 100.0,
              divisions: widget.device.type == DeviceType.ac ? 14 : 10,
              onChanged: widget.device.isOn
                  ? (value) {
                setState(() {
                  _currentValue = value;
                });
                widget.onValueChanged(value);
              }
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          widget.onToggle();
          setState(() {});
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.device.isOn
              ? widget.device.color
              : Colors.grey[300],
          foregroundColor: widget.device.isOn ? Colors.white : Colors.grey[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: widget.device.isOn ? 8 : 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.device.isOn ? Icons.power_settings_new : Icons.power_off,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              widget.device.isOn ? 'Turn OFF' : 'Turn ON',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}