import 'package:web3dart/web3dart.dart';

String GetEtherValue(String amount) {
  EtherAmount value =
      EtherAmount.fromBigInt(EtherUnit.wei, BigInt.parse(amount));
  String valueStr = value.getValueInUnit(EtherUnit.ether).toStringAsFixed(12);
  return valueStr;
}
