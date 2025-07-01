import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final _formKey = GlobalKey<FormState>();

  DateTime checkInDate = DateTime.now();
  DateTime checkOutDate = DateTime.now().add(const Duration(days: 1));
  int roomCount = 1;
  int adults = 1;
  int children = 0;
  String location = '';

  final LayerLink _roomLink = LayerLink();
  final LayerLink _guestLink = LayerLink();
  final LayerLink _checkInLink = LayerLink();
  final LayerLink _checkOutLink = LayerLink();
  OverlayEntry? _roomOverlay;
  OverlayEntry? _guestOverlay;
  OverlayEntry? _checkInOverlay;
  OverlayEntry? _checkOutOverlay;

  String formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date).toUpperCase();
  }

  void _toggleOverlay({
    required LayerLink link,
    required Widget content,
    required OverlayEntry? currentOverlay,
    required void Function(OverlayEntry?) setOverlay,
  }) {
    if (currentOverlay != null) {
      currentOverlay.remove();
      setOverlay(null);
    } else {
      final overlay = Overlay.of(context);
      late OverlayEntry entry;

      entry = OverlayEntry(
        builder: (context) => Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  entry.remove();
                  setOverlay(null);
                },
                behavior: HitTestBehavior.translucent,
                child: Container(),
              ),
            ),
            Positioned(
              // width: 180,
              child: CompositedTransformFollower(
                link: link,
                offset: const Offset(0, 83),
                showWhenUnlinked: false,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(16),
                  child: content,
                ),
              ),
            ),
          ],
        ),
      );

      overlay.insert(entry);
      setOverlay(entry);
    }
  }

  void _handleSearch() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Searching for $roomCount rooms in $location from ${formatDate(checkInDate)} to ${formatDate(checkOutDate)} for $adults adults and $children children',
          ),
        ),
      );
    }
  }

  void _showRoomOverlay() {
    if (_roomOverlay != null) {
      _roomOverlay!.remove();
      setState(() => _roomOverlay = null);
    }
    _toggleOverlay(
      link: _roomLink,
      currentOverlay: _roomOverlay,
      setOverlay: (entry) => setState(() => _roomOverlay = entry),
      content: _buildRoomOverlay(),
    );
  }

  void _showGuestOverlay() {
    if (_guestOverlay != null) {
      _guestOverlay!.remove();
      setState(() => _guestOverlay = null);
    }
    _toggleOverlay(
      link: _guestLink,
      currentOverlay: _guestOverlay,
      setOverlay: (entry) => setState(() => _guestOverlay = entry),
      content: _buildGuestOverlay(),
    );
  }

  Widget _buildRoomOverlay() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setOverlayState) {
        return Container(
          width: 150,
          height: 95,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Rooms',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: roomCount > 1
                        ? () {
                            setState(() {
                              roomCount--;
                            });
                            setOverlayState(() {});
                          }
                        : null,
                  ),
                  Text('$roomCount'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        roomCount++;
                      });
                      setOverlayState(() {});
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGuestOverlay() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setOverlayState) {
        return Container(
          width: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCounter('Adults', adults, (v) {
                setState(() => adults = v);
                setOverlayState(() {});
              }, min: 1),
              const Divider(height: 1),
              _buildCounter('Children', children, (v) {
                setState(() => children = v);
                setOverlayState(() {});
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCounter(String label, int value, ValueChanged<int> onChanged,
      {int min = 0, int max = 10}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: value > min ? () => onChanged(value - 1) : null,
            ),
            Text('$value'),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: value < max ? () => onChanged(value + 1) : null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCheckInDatePickerOverlay() {
    return Container(
      width: 300,
      height: 265,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: SfDateRangePicker(
        selectionMode: DateRangePickerSelectionMode.single,
        initialSelectedDate: checkInDate,
        minDate: DateTime.now(),
        onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
          if (args.value is DateTime) {
            setState(() {
              checkInDate = args.value as DateTime;
              if (!checkOutDate.isAfter(checkInDate)) {
                checkOutDate = checkInDate.add(const Duration(days: 1));
              }
            });
            if (_checkInOverlay != null) {
              _checkInOverlay!.remove();
              setState(() => _checkInOverlay = null);
            }
          }
        },
      ),
    );
  }

  Widget _buildCheckOutDatePickerOverlay() {
    return Container(
      width: 300,
      height: 265,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: SfDateRangePicker(
        selectionMode: DateRangePickerSelectionMode.single,
        initialSelectedDate: checkOutDate,
        minDate: checkInDate.add(const Duration(days: 1)),
        onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
          if (args.value is DateTime) {
            setState(() {
              checkOutDate = args.value as DateTime;
            });
            if (_checkOutOverlay != null) {
              _checkOutOverlay!.remove();
              setState(() => _checkOutOverlay = null);
            }
          }
        },
      ),
    );
  }

  Widget _buildDropdownField(String label, String value, VoidCallback onTap,
      LayerLink link, IconData icon) {
    return CompositedTransformTarget(
      link: link,
      child: SizedBox(
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(value,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                    Icon(icon, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Wrap(
          spacing: 20,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: [
            SizedBox(
              width: 160,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Location',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 6),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Enter destination',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a destination'
                        : null,
                    onChanged: (val) => setState(() => location = val),
                  ),
                ],
              ),
            ),
            _buildDropdownField(
              'Check In',
              formatDate(checkInDate),
              () => _toggleOverlay(
                link: _checkInLink,
                content: _buildCheckInDatePickerOverlay(),
                currentOverlay: _checkInOverlay,
                setOverlay: (entry) => setState(() => _checkInOverlay = entry),
              ),
              _checkInLink,
              Icons.calendar_today,
            ),
            _buildDropdownField(
              'Check Out',
              formatDate(checkOutDate),
              () => _toggleOverlay(
                link: _checkOutLink,
                content: _buildCheckOutDatePickerOverlay(),
                currentOverlay: _checkOutOverlay,
                setOverlay: (entry) => setState(() => _checkOutOverlay = entry),
              ),
              _checkOutLink,
              Icons.calendar_today,
            ),
            _buildDropdownField(
              'Room',
              'Room: $roomCount',
              _showRoomOverlay,
              _roomLink,
              Icons.arrow_drop_down,
            ),
            SizedBox(
              width: 200,
              child: _buildDropdownField(
                'Guests',
                '$adults adults, $children children',
                _showGuestOverlay,
                _guestLink,
                Icons.arrow_drop_down,
              ),
            ),
            SizedBox(
              width: 160,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Search',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleSearch,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('SEARCH ROOM',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, letterSpacing: 1)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
