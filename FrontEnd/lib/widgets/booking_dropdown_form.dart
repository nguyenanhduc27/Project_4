import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class BookingDropdownForm extends StatefulWidget {
  const BookingDropdownForm({super.key});

  @override
  State<BookingDropdownForm> createState() => _BookingDropdownFormState();
}

class _BookingDropdownFormState extends State<BookingDropdownForm> {
  final dateFormat = DateFormat('dd/MM/yyyy');

  DateTime checkInDate = DateTime.now();
  DateTime checkOutDate = DateTime.now().add(const Duration(days: 1));
  int roomCount = 1;
  int adultCount = 1;
  int childCount = 0;

  final LayerLink _checkInLink = LayerLink();
  final LayerLink _checkOutLink = LayerLink();
  final LayerLink _roomLink = LayerLink();
  final LayerLink _guestLink = LayerLink();

  OverlayEntry? _dropdownOverlay;

  void _removeOverlay() {
    _dropdownOverlay?.remove();
    _dropdownOverlay = null;
  }

  void _showOverlay({
    required BuildContext context,
    required LayerLink link,
    required Widget child,
  }) {
    _removeOverlay();

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _dropdownOverlay = OverlayEntry(
      builder: (_) => GestureDetector(
        onTap: _removeOverlay,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height,
              width: size.width,
              child: CompositedTransformFollower(
                link: link,
                offset: const Offset(0, 0),
                showWhenUnlinked: false,
                child: Material(
                  color: Colors.transparent,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_dropdownOverlay!);
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required VoidCallback onTap,
    required LayerLink link,
  }) {
    return CompositedTransformTarget(
      link: link,
      child: GestureDetector(
        onTap: () {
          _removeOverlay();
          onTap();
        },
        child: AbsorbPointer(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: label,
              suffixIcon: const Icon(Icons.arrow_drop_down),
            ),
            controller: TextEditingController(text: value),
          ),
        ),
      ),
    );
  }

  void _onBookingPressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Booked $roomCount room(s), $adultCount adult(s), $childCount child(ren)\n'
          '${dateFormat.format(checkInDate)} - ${dateFormat.format(checkOutDate)}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _removeOverlay,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDropdownField(
              label: 'Check-in Date',
              value: dateFormat.format(checkInDate),
              link: _checkInLink,
              onTap: () {
                _showOverlay(
                  context: context,
                  link: _checkInLink,
                  child: SizedBox(
                    height: 300,
                    child: SfDateRangePicker(
                      initialSelectedDate: checkInDate,
                      onSelectionChanged: (args) {
                        DateTime selected = args.value;
                        setState(() {
                          checkInDate = selected;
                          if (!checkOutDate.isAfter(selected)) {
                            checkOutDate = selected.add(const Duration(days: 1));
                          }
                        });
                        _removeOverlay();
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              label: 'Check-out Date',
              value: dateFormat.format(checkOutDate),
              link: _checkOutLink,
              onTap: () {
                _showOverlay(
                  context: context,
                  link: _checkOutLink,
                  child: SizedBox(
                    height: 300,
                    child: SfDateRangePicker(
                      initialSelectedDate: checkOutDate,
                      minDate: checkInDate.add(const Duration(days: 1)),
                      onSelectionChanged: (args) {
                        DateTime selected = args.value;
                        if (selected.isAfter(checkInDate)) {
                          setState(() {
                            checkOutDate = selected;
                          });
                          _removeOverlay();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Check-out phải sau Check-in"),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              label: 'Rooms',
              value: '$roomCount room(s)',
              link: _roomLink,
              onTap: () {
                _showOverlay(
                  context: context,
                  link: _roomLink,
                  child: StatefulBuilder(
                    builder: (context, setInnerState) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Rooms"),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => setInnerState(() {
                            if (roomCount > 1) roomCount--;
                            setState(() {});
                          }),
                        ),
                        Text(roomCount.toString()),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => setInnerState(() {
                            roomCount++;
                            setState(() {});
                          }),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              label: 'Guests',
              value: '$adultCount Adults, $childCount Children',
              link: _guestLink,
              onTap: () {
                _showOverlay(
                  context: context,
                  link: _guestLink,
                  child: StatefulBuilder(
                    builder: (context, setInnerState) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Expanded(child: Text("Adults")),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => setInnerState(() {
                                if (adultCount > 1) adultCount--;
                                setState(() {});
                              }),
                            ),
                            Text(adultCount.toString()),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () => setInnerState(() {
                                adultCount++;
                                setState(() {});
                              }),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Expanded(child: Text("Children")),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => setInnerState(() {
                                if (childCount > 0) childCount--;
                                setState(() {});
                              }),
                            ),
                            Text(childCount.toString()),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () => setInnerState(() {
                                childCount++;
                                setState(() {});
                              }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _onBookingPressed,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Booking',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
