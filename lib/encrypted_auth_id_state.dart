
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:encrypted_auth_id/encrypted_auth_id.dart';

part 'encrypted_auth_id_state.freezed.dart';

@freezed
class EncryptedAuthIdState with _$EncryptedAuthIdState {
  const factory EncryptedAuthIdState.none() = _None;
  const factory EncryptedAuthIdState.loading() = _Loading;
  const factory EncryptedAuthIdState.some(EncryptedAuthId? encryptedAuthId) =
  _Some;
}
