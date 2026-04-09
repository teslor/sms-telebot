import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state.dart';
import 'connections/registry.dart';

class RuleConnectionPage extends StatelessWidget {
  const RuleConnectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.select<AppState, String?>(
      (state) => state.selectedRule?['provider'] as String?,
    ) ?? 'telegram_bot';

    final builder = connectionProviders[provider];
    if (builder == null) {
      return Center(child: Text('Unknown provider: $provider'));
    }

    return builder();
  }
}
