
import 'dart:async';

import 'package:auth_id/auth_id.dart';
import 'package:encrypted_auth_id/encrypted_auth_id.dart';
import 'package:encrypted_auth_id/src/encrypted_auth_id_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EncryptedAuthIdBloc extends Cubit<EncryptedAuthIdState> {

  final AuthIdRepo authIdRepo;
  final EncryptedAuthIdRepo encryptedAuthIdRepo;
  late final StreamSubscription encryptedAuthIdSubscription;
  late final StreamSubscription authIdSubscription;
  final String key;
  final String password;

  bool _authIdSome = false;
  bool _encryptedAuthIdSome = false;


  EncryptedAuthIdBloc({required this.encryptedAuthIdRepo, required this.key, required this.password, required this.authIdRepo}) :
        super(const EncryptedAuthIdState.none()){
    subscribe();
    restore();
  }

  EncryptedAuthId? get(){
    return state.map(none: (none)=> null, loading: (loading)=>null, some: (some) => some.encryptedAuthId);
  }

  @override
  Future<void> close() {
    encryptedAuthIdSubscription.cancel();
    authIdSubscription.cancel();
    return super.close();
  }

  void subscribe() {

    encryptedAuthIdSubscription = encryptedAuthIdRepo.items.listen(
          (items) {
            items.map(
                none: (none) => emit(const EncryptedAuthIdState.none()),
                loading: (loading) => emit(const EncryptedAuthIdState.none()),
                some: (some) {
                  if (some.encryptedAuthId != null){
                    _encryptedAuthIdSome = true;
                  }
                  emit(EncryptedAuthIdState.some(some.encryptedAuthId));
                });
      },
      onError: (error) => print("STREAM ERROR: $error"),
    );
    authIdSubscription = authIdRepo.items.listen((event) {
      event.map(
          none: (none){},
          some: (some){
            _authIdSome = true;
            if (_encryptedAuthIdSome == false){
              _encryptedAuthIdSome = true;
              encryptedAuthIdRepo.makeNew(key: key, password: password, authId: some.authId);
            }
          }
      );
    });
  }

  Future<void> restore() async {
    encryptedAuthIdRepo.restore(key: key, password: password);
  }
}

