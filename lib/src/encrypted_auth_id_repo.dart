
import 'dart:async';

import 'package:auth_id/auth_id.dart';
import 'package:encrypted_auth_id/encrypted_auth_id.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptedAuthIdRepo {

  final controller = StreamController<EncryptedAuthIdState>.broadcast()..add(const EncryptedAuthIdState.none());
  final storage = const FlutterSecureStorage();



  Stream<EncryptedAuthIdState> get items => controller.stream.asBroadcastStream();

  Future<void> restore({required String key, required String password}) async {
    final id = await storage.read(key: key);
    if (id == null) {
      controller.sink.add(const EncryptedAuthIdState.some(null));
    } else {
      try {
        final encryptedAuthId = await EncryptedAuthId.import(id, password);
        controller.sink.add(EncryptedAuthIdState.some(encryptedAuthId));
      } catch (e) {
        controller.sink.add(const EncryptedAuthIdState.some(null));
      }
    }
  }

  Future<void> makeNew({required String key, required String password, required AuthId authId}) async {
    final encryptedAuthId = await EncryptedAuthId.export(authId,password);
    await storage.write(
        key: key, value: encryptedAuthId.encryptedAuthId);
    controller.sink.add(EncryptedAuthIdState.some(encryptedAuthId));
  }

  // EncryptedAuthId? get(){
  //   return state.map(none: (none)=> null, loading: (loading)=>null, some: (some) => some.encryptedAuthId);
  // }

  // Future<EncryptedAuthId?> restore(String key, String password) async {
  //   emit(const EncryptedAuthIdState.loading());
  //   const storage = FlutterSecureStorage();
  //   final id = await storage.read(key: key);
  //   if (id == null) {
  //     emit(const EncryptedAuthIdState.some(null));
  //     return null;
  //   } else {
  //     try {
  //       final encryptedAuthId = await EncryptedAuthId.import(id, password);
  //       emit(EncryptedAuthIdState.some(encryptedAuthId));
  //       return encryptedAuthId;
  //     } catch (e) {
  //       emit(const EncryptedAuthIdState.some(null));
  //       return null;
  //     }
  //   }
  //
  // }
  //
  // Future<EncryptedAuthId> makeNew(String key, String password, AuthId authId) async {
  //   final encryptedAuthId = await EncryptedAuthId.export(authId,password);
  //   const storage = FlutterSecureStorage();
  //   await storage.write(
  //       key: key, value: encryptedAuthId.encryptedAuthId);
  //   emit(EncryptedAuthIdState.some(encryptedAuthId));
  //   return encryptedAuthId;
  // }
}

