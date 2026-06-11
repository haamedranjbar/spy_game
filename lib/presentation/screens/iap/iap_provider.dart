import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spy_game/core/iap/iap_interface.dart';
import 'package:spy_game/presentation/providers/monetization_provider.dart';

part 'iap_provider.g.dart';

/// State محلی صفحه خرید
class IapUiState {
  const IapUiState({
    this.lastMessageKey,
  });

  final String? lastMessageKey;

  IapUiState copyWith({String? lastMessageKey}) {
    return IapUiState(lastMessageKey: lastMessageKey);
  }
}

@riverpod
class IapNotifier extends _$IapNotifier {
  @override
  IapUiState build() => const IapUiState();

  Future<IapPurchaseResult> purchase() {
    return ref.read(monetizationProvider.notifier).purchaseGolden();
  }

  Future<IapPurchaseResult> restore() {
    return ref.read(monetizationProvider.notifier).restorePurchases();
  }

  void setMessage(String? key) {
    state = state.copyWith(lastMessageKey: key);
  }
}
