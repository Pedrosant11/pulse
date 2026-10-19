import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/errors/app_failure_message.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/admin_web/domain/admin_console_models.dart';
import 'package:pulse/features/admin_web/presentation/admin_console_providers.dart';
import 'package:pulse/features/events/domain/featured.dart';

/// App settings that used to need SQL, and the highlight prices.
class AdminSettingsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final settings = ref.watch(adminSettingsProvider);
    final prices = ref.watch(adminFeaturedPricesProvider);
    ref.listen(adminSettingsEditorProvider, (_, next) {
      final messenger = ScaffoldMessenger.of(context);
      switch (next) {
        case AsyncError(:final error):
          messenger.showSnackBar(
            SnackBar(content: Text(friendlyErrorMessage(error, l10n))),
          );
        case AsyncData() when next.hasValue:
          messenger.showSnackBar(SnackBar(content: Text(l10n.savedMessage)));
        default:
      }
    });
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(l10n.consoleSettings.toUpperCase())),
      body: ListView(
        padding: EdgeInsets.all(spacing.md),
        children: [
          Text(l10n.consoleSettingsHint, style: context.textTheme.bodySmall),
          SizedBox(height: spacing.md),
          AsyncValueView(
            value: settings,
            onRetry: () => ref.invalidate(adminSettingsProvider),
            data: (settings) => Column(
              children: [
                for (final setting in settings)
                  if (int.tryParse(setting.value) != null)
                    _SettingRow(setting: setting),
              ],
            ),
          ),
          SizedBox(height: spacing.lg),
          Text(
            l10n.consoleFeaturedPrices.toUpperCase(),
            style: context.textTheme.titleLarge,
          ),
          SizedBox(height: spacing.xs),
          Text(
            l10n.consoleFeaturedPricesHint,
            style: context.textTheme.bodySmall,
          ),
          SizedBox(height: spacing.sm),
          AsyncValueView(
            value: prices,
            onRetry: () => ref.invalidate(adminFeaturedPricesProvider),
            data: (prices) =>
                Column(children: [for (final p in prices) _PriceRow(price: p)]),
          ),
        ],
      ),
    );
  }
}

/// One setting: what it does, and a number to change.
class _SettingRow extends ConsumerStatefulWidget {
  const new({required this.setting});

  final AppSetting setting;

  @override
  ConsumerState<_SettingRow> createState() => _SettingRowState();
}

class _SettingRowState extends ConsumerState<_SettingRow> {
  late final _value = TextEditingController(text: widget.setting.value);

  @override
  void didUpdateWidget(_SettingRow old) {
    super.didUpdateWidget(old);
    if (old.setting.value != widget.setting.value) {
      _value.text = widget.setting.value;
    }
  }

  @override
  void dispose() {
    _value.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final key = widget.setting.key;
    final changed = _value.text != widget.setting.value;
    final busy = ref.watch(adminSettingsEditorProvider).isLoading;
    return Padding(
      padding: EdgeInsets.only(bottom: context.spacing.sm),
      child: GlassCard(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.consoleSettingName(key),
                    style: context.textTheme.titleSmall,
                  ),
                  Text(key, style: context.textTheme.labelSmall),
                ],
              ),
            ),
            SizedBox(
              width: 96,
              child: TextField(
                controller: _value,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textAlign: TextAlign.end,
                onChanged: (_) => setState(() {}),
              ),
            ),
            SizedBox(width: context.spacing.sm),
            FilledButton(
              onPressed: !changed || busy
                  ? null
                  : () => ref
                        .read(adminSettingsEditorProvider.notifier)
                        .setSetting(key, int.parse(_value.text)),
              child: Text(l10n.saveButton),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceRow extends ConsumerStatefulWidget {
  const new({required this.price});

  final FeaturedPrice price;

  @override
  ConsumerState<_PriceRow> createState() => _PriceRowState();
}

class _PriceRowState extends ConsumerState<_PriceRow> {
  late final _reais = TextEditingController(
    text: (widget.price.priceCents / 100)
        .toStringAsFixed(2)
        .replaceAll('.', ','),
  );

  @override
  void dispose() {
    _reais.dispose();
    super.dispose();
  }

  int? get _cents {
    final value = double.tryParse(_reais.text.replaceAll(',', '.'));
    return value == null || value <= 0 ? null : (value * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final price = widget.price;
    final cents = _cents;
    final busy = ref.watch(adminSettingsEditorProvider).isLoading;
    final perDay = cents == null ? null : cents / 100 / price.days;
    return Padding(
      padding: EdgeInsets.only(bottom: context.spacing.sm),
      child: GlassCard(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.featuredDays(price.days),
                    style: context.textTheme.titleSmall,
                  ),
                  Text(
                    [
                      price.storeProductId,
                      if (perDay != null)
                        l10n.featuredPerDay(
                          NumberFormat.simpleCurrency(locale: 'pt_BR')
                              .format(perDay),
                        ),
                    ].join(' · '),
                    style: context.textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 120,
              child: TextField(
                controller: _reais,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textAlign: TextAlign.end,
                decoration: const InputDecoration(prefixText: r'R$ '),
                onChanged: (_) => setState(() {}),
              ),
            ),
            SizedBox(width: context.spacing.sm),
            FilledButton(
              onPressed: cents == null || cents == price.priceCents || busy
                  ? null
                  : () => ref
                        .read(adminSettingsEditorProvider.notifier)
                        .setFeaturedPrice(price.days, cents),
              child: Text(l10n.saveButton),
            ),
          ],
        ),
      ),
    );
  }
}
