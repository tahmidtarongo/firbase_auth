import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/model/sms_model.dart';
import 'package:mobile_pos/repository/sms_repo.dart';

SmsRepo smsRepo = SmsRepo();
final smsHistoryProvider = FutureProvider.autoDispose<List<SmsModel>>((ref) => smsRepo.getAllSms());
