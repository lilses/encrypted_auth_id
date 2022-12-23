
import 'package:auth_id/auth_id_model.dart';
import 'package:encrypted_auth_id/encrypted_auth_id.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BlocEncryptedAuthId extends Cubit<EncryptedAuthIdState> {
  BlocEncryptedAuthId() : super(const EncryptedAuthIdState.none());

  EncryptedAuthId? get(){
    return state.map(none: (none)=> null, loading: (loading)=>null, some: (some) => some.encryptedAuthId);
  }

  Future<EncryptedAuthId?> restore(String key, String password) async {
    emit(const EncryptedAuthIdState.loading());
    const storage = FlutterSecureStorage();
    final id = await storage.read(key: key);
    if (id == null) {
      emit(const EncryptedAuthIdState.some(null));
      return null;
    } else {
      try {
        final encryptedAuthId = await EncryptedAuthId.import(id, password);
        emit(EncryptedAuthIdState.some(encryptedAuthId));
        return encryptedAuthId;
      } catch (e) {
        emit(const EncryptedAuthIdState.some(null));
        return null;
      }
    }

  }

  Future<EncryptedAuthId> makeNew(String key, String password, AuthId authId) async {
    final encryptedAuthId = await EncryptedAuthId.export(authId,password);
    const storage = FlutterSecureStorage();
    await storage.write(
        key: key, value: encryptedAuthId.encryptedAuthId);
    emit(EncryptedAuthIdState.some(encryptedAuthId));
    return encryptedAuthId;
  }
}

