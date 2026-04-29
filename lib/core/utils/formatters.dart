import 'package:intl/intl.dart';

/// Number and date formatting helpers.
class Formatters {
  Formatters._();

  /// Formats an amount in Ugandan Shillings.
  /// e.g. `1400000` → `UGX 1,400,000`
  static String formatUGX(num amount) {
    final formatter = NumberFormat('#,###', 'en_UG');
    return 'UGX ${formatter.format(amount)}';
  }

  /// Compact UGX for hostel cards.
  /// e.g. `1400000` → `1.4M`, `280000` → `280k`
  static String formatUGXCompact(num amount) {
    if (amount >= 1000000) {
      final millions = amount / 1000000;
      return '${millions.toStringAsFixed(millions.truncateToDouble() == millions ? 0 : 1)}M';
    } else if (amount >= 1000) {
      final thousands = amount / 1000;
      return '${thousands.toStringAsFixed(thousands.truncateToDouble() == thousands ? 0 : 0)}k';
    }
    return amount.toString();
  }

  /// Compact UGX with prefix.
  /// e.g. `280000` → `280k`
  static String formatPriceTag(num amount) {
    return '${formatUGXCompact(amount)}/semester';
  }

  /// Format date as "12 Apr 2026".
  static String formatDate(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }

  /// Format date as "Apr 12, 2026".
  static String formatDateFull(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  /// Relative time (e.g. "2 min ago", "1 hr ago").
  static String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    if (diff.inDays < 7) {
      return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
    }
    return formatDate(date);
  }

  /// Format phone for display: "0701 234 567".
  static String formatPhone(String raw) {
    final digits = raw.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length == 9) {
      return '0${digits.substring(0, 3)} ${digits.substring(3, 6)} ${digits.substring(6)}';
    }
    if (digits.length == 10) {
      return '${digits.substring(0, 4)} ${digits.substring(4, 7)} ${digits.substring(7)}';
    }
    return raw;
  }
}
