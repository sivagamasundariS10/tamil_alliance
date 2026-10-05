import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Formatter that automatically places slashes (' / ') as the user types digits.
/// The user only types numbers (DDMMYYYY), and slashes are inserted automatically.
class DateSlashFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // If deleting with backspace
    if (oldValue.text.length > newValue.text.length) {
      String clean = newValue.text.replaceAll(RegExp(r'\D'), '');
      if (oldValue.text.endsWith('/ ') ||
          oldValue.text.endsWith(' / ') ||
          oldValue.text.endsWith('/')) {
        if (clean.isNotEmpty) {
          clean = clean.substring(0, clean.length - 1);
        }
      }
      return _formatDigits(clean);
    }

    final clean = newValue.text.replaceAll(RegExp(r'\D'), '');
    return _formatDigits(clean);
  }

  TextEditingValue _formatDigits(String digits) {
    final max = digits.length > 8 ? digits.substring(0, 8) : digits;
    final b = StringBuffer();
    for (int i = 0; i < max.length; i++) {
      b.write(max[i]);
      if (i == 1 || i == 3) {
        b.write(' / ');
      }
    }
    final str = b.toString();
    return TextEditingValue(
      text: str,
      selection: TextSelection.collapsed(offset: str.length),
    );
  }
}

/// Parses date from slash-separated string 'DD / MM / YYYY' or 'DD/MM/YYYY'.
DateTime? parseDateFromSlashString(String text) {
  final clean = text.replaceAll(' ', '');
  final parts = clean.split('/');
  if (parts.length != 3) return null;
  final d = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  final y = int.tryParse(parts[2]);
  if (d == null || m == null || y == null) return null;
  if (parts[2].length != 4) return null;

  // Day must be between 1 and 31
  if (d < 1 || d > 31) return null;
  // Month must be between 1 and 12
  if (m < 1 || m > 12) return null;
  if (y < 1900 || y > DateTime.now().year + 5) return null;

  final daysInMonth = DateTime(y, m + 1, 0).day;
  if (d > daysInMonth) return null;
  return DateTime(y, m, d);
}

/// Shows a custom date picker that supports both Calendar & Manual Input with automatic slashes.
Future<DateTime?> showAppDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
}) {
  return showDialog<DateTime>(
    context: context,
    builder: (context) => CustomDatePickerDialog(
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      initialEntryMode: initialEntryMode,
    ),
  );
}

class CustomDatePickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final DatePickerEntryMode initialEntryMode;

  const CustomDatePickerDialog({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.initialEntryMode = DatePickerEntryMode.calendar,
  });

  @override
  State<CustomDatePickerDialog> createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  late bool _isCalendarMode;
  late DateTime _selectedDate;
  late TextEditingController _manualController;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _isCalendarMode = widget.initialEntryMode == DatePickerEntryMode.calendar;
    _selectedDate = widget.initialDate;
    final dd = _selectedDate.day.toString().padLeft(2, '0');
    final mm = _selectedDate.month.toString().padLeft(2, '0');
    final yyyy = _selectedDate.year.toString();
    _manualController = TextEditingController(text: '$dd / $mm / $yyyy');
  }

  @override
  void dispose() {
    _manualController.dispose();
    super.dispose();
  }

  String _formatHeaderDate(DateTime date) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];
    return '$weekday, $month ${date.day}';
  }

  void _validateManualInput(String val) {
    final clean = val.replaceAll(' ', '');
    final parts = clean.split('/');

    String? err;
    DateTime? validDate;

    // 1. Day Validation (01 to 31)
    if (parts.isNotEmpty && parts[0].isNotEmpty) {
      final d = int.tryParse(parts[0]);
      if (d == null || (parts[0].length >= 2 && (d < 1 || d > 31))) {
        err = 'Day "${parts[0]}" is invalid (Must be between 01 and 31)';
      }
    }

    // 2. Month Validation (01 to 12)
    if (err == null && parts.length >= 2 && parts[1].isNotEmpty) {
      final m = int.tryParse(parts[1]);
      if (m == null || (parts[1].length >= 2 && (m < 1 || m > 12))) {
        err = 'Month "${parts[1]}" is invalid (Must be between 01 and 12)';
      }
    }

    // 3. Year Validation
    if (err == null && parts.length >= 3 && parts[2].isNotEmpty) {
      final y = int.tryParse(parts[2]);
      if (parts[2].length == 4) {
        if (y == null) {
          err = 'Invalid 4-digit year';
        } else if (y > widget.lastDate.year) {
          err =
              'Year "$y" is in future (Max year: ${widget.lastDate.year}, age >= 18)';
        } else if (y < widget.firstDate.year) {
          err = 'Year "$y" is invalid (Must be after ${widget.firstDate.year})';
        }
      } else if (parts[2].isNotEmpty) {
        final firstChar = parts[2][0];
        if (firstChar != '1' && firstChar != '2') {
          err = 'Year must start with 19xx or 20xx';
        }
      }
    }

    // 4. Calendar date validation
    if (err == null && parts.length == 3 && parts[2].length == 4) {
      final parsed = parseDateFromSlashString(val);
      if (parsed == null) {
        err = 'Invalid date (Please check days in that month)';
      } else if (parsed.isBefore(widget.firstDate) ||
          parsed.isAfter(widget.lastDate)) {
        err =
            'Must be between ${widget.firstDate.year} and ${widget.lastDate.year} (Min 18 yrs)';
      } else {
        validDate = parsed;
      }
    }

    setState(() {
      _errorMessage = err;
      if (validDate != null) {
        _selectedDate = validDate;
      }
    });
  }

  void _onOkPressed() {
    if (_isCalendarMode) {
      Navigator.of(context).pop(_selectedDate);
      return;
    }

    _validateManualInput(_manualController.text);
    if (_errorMessage != null) {
      return;
    }

    final parsed = parseDateFromSlashString(_manualController.text);
    if (parsed == null ||
        parsed.isBefore(widget.firstDate) ||
        parsed.isAfter(widget.lastDate)) {
      setState(() {
        _errorMessage =
            'Date must be between ${widget.firstDate.year} and ${widget.lastDate.year}';
      });
      return;
    }

    Navigator.of(context).pop(parsed);
  }

  @override
  Widget build(BuildContext context) {
    final hasManualError = !_isCalendarMode && _errorMessage != null;
    final digitsOnly =
        _manualController.text.replaceAll(RegExp(r'\D'), '');
    final isManualComplete = !_isCalendarMode &&
        digitsOnly.length == 8 &&
        _errorMessage == null;
    final canSubmit = _isCalendarMode || isManualComplete;

    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select date',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          hasManualError
                              ? 'Invalid Date'
                              : _formatHeaderDate(_selectedDate),
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: hasManualError
                                ? const Color(0xFFDC2626)
                                : const Color(0xFF1E293B),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isCalendarMode
                                ? Icons.edit_outlined
                                : Icons.calendar_month_outlined,
                            color: const Color(0xFF475569),
                            size: 24,
                          ),
                          tooltip: _isCalendarMode
                              ? 'Switch to manual input'
                              : 'Switch to calendar',
                          onPressed: () {
                            setState(() {
                              _isCalendarMode = !_isCalendarMode;
                              _errorMessage = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, color: Color(0xFFE2E8F0)),

              // Content Section
              if (_isCalendarMode)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Color(0xFF701A33),
                        onPrimary: Colors.white,
                        onSurface: Color(0xFF1E293B),
                      ),
                    ),
                    child: CalendarDatePicker(
                      initialDate: _selectedDate,
                      firstDate: widget.firstDate,
                      lastDate: widget.lastDate,
                      onDateChanged: (newDate) {
                        setState(() {
                          _selectedDate = newDate;
                          final dd = newDate.day.toString().padLeft(2, '0');
                          final mm = newDate.month.toString().padLeft(2, '0');
                          final yyyy = newDate.year.toString();
                          _manualController.text = '$dd / $mm / $yyyy';
                          _errorMessage = null;
                        });
                      },
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _manualController,
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        inputFormatters: [
                          DateSlashFormatter(),
                        ],
                        onChanged: (val) {
                          _validateManualInput(val);
                        },
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: hasManualError
                              ? const Color(0xFF991B1B)
                              : const Color(0xFF1E293B),
                          letterSpacing: 1.0,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Enter Date',
                          labelStyle: TextStyle(
                            color: hasManualError
                                ? const Color(0xFFDC2626)
                                : const Color(0xFF701A33),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          hintText: 'DD / MM / YYYY',
                          hintStyle: const TextStyle(
                            color: Color(0xFF94A3B8),
                            letterSpacing: 1.0,
                          ),
                          errorText: _errorMessage,
                          errorStyle: const TextStyle(
                            color: Color(0xFFDC2626),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          errorMaxLines: 2,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: hasManualError
                                  ? const Color(0xFFDC2626)
                                  : const Color(0xFF701A33),
                              width: hasManualError ? 2.0 : 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: hasManualError
                                  ? const Color(0xFFDC2626)
                                  : const Color(0xFF701A33),
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: hasManualError
                                  ? const Color(0xFFDC2626)
                                  : const Color(0xFF701A33),
                              width: hasManualError ? 2.0 : 1.5,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFDC2626),
                              width: 2.0,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFDC2626),
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Bottom Action Buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF701A33),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: canSubmit ? _onOkPressed : null,
                      style: TextButton.styleFrom(
                        foregroundColor: canSubmit
                            ? const Color(0xFF701A33)
                            : const Color(0xFF94A3B8),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
