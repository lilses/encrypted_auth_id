
import 'package:auth_id/auth_id_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
import 'package:solana/base58.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'encrypted_auth_id_model.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class EncryptedAuthId {
  String encryptedAuthId;

  EncryptedAuthId({required this.encryptedAuthId});

  static Future<EncryptedAuthId> export(AuthId authId, String password) async {
    final authIdJson = authId.toJson();
    final encrypted = await AuthId.encrypt(utf8.encode(jsonEncode(authIdJson)), password);
    final base58Encrypted = base58encode(encrypted);
    return EncryptedAuthId(encryptedAuthId: base58Encrypted);
  }

  static Future<EncryptedAuthId> import(String encryptedAuthId, String password) async {
    await AuthId.restore(
        EncryptedAuthId(encryptedAuthId: encryptedAuthId), password);
    return EncryptedAuthId(encryptedAuthId: encryptedAuthId);
  }

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory EncryptedAuthId.fromJson(Map<String, dynamic> json) =>
      _$EncryptedAuthIdFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$EncryptedAuthIdToJson(this);
}
