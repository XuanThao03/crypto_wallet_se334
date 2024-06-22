import 'dart:ffi';

import 'package:bip32/bip32.dart';
import 'package:wallet/core/common/const/networks.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter/foundation.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:hex/hex.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class WalletAddressService {
  String generateMnemonic();
  Future<String> getPrivateKey(
      String mnemonic, String network, bool isAccessed);
  Future<EthereumAddress> getPublicKey(String privateKey);
}

class WalletProvider extends ChangeNotifier implements WalletAddressService {
  // Variable to store the private key
  String? privateKey;
  String? mnemonicStr;

  // Load the private key from the shared preferences
  Future<void> loadPrivateKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    privateKey = prefs.getString('privateKey');
  }

  // set the private key in the shared preferences
  Future<void> setPrivateKey(String privateKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('privateKey', privateKey);
    this.privateKey = privateKey;
    notifyListeners();
  }

  Future<void> setMnemonic(String str) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('mnemonicStr', str);
    this.mnemonicStr = mnemonicStr;
    notifyListeners();
  }

  @override
  String generateMnemonic() {
    return bip39.generateMnemonic();
  }

  @override
  Future<String> getPrivateKey(
      String mnemonic, String network, bool isAccessed) async {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final privateKey;
    if (network == Networks.sepolia) {
      final master = await ED25519_HD_KEY.getMasterKeyFromSeed(seed);
      privateKey = HEX.encode(master.key);
    } else {
      final node = BIP32.fromSeed(seed);
      final child = node.derivePath("m/44'/60'/0'/0/0");
      privateKey = HEX.encode(child.privateKey!);
    }

    // Set the private key in the shared preferences
    isAccessed ? await setPrivateKey(privateKey) : null;
    return privateKey;
  }

  @override
  Future<EthereumAddress> getPublicKey(String privateKey) async {
    final private = EthPrivateKey.fromHex(privateKey);
    final address = await private.address;
    return address;
  }
}
