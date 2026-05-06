import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/pesapal_service.dart';

final pesapalServiceProvider = Provider<PesaPalService>((ref) {
  return PesaPalService();
});
