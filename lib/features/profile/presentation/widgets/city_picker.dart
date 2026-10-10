import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/profile/data/location_repository.dart';
import 'package:pulse/features/profile/domain/city.dart';

/// Bottom sheet to choose the city from the IBGE list, or suggest it from
/// the approximate location (computed on device).
Future<City?> showCityPicker(BuildContext context) {
  return showModalBottomSheet<City>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: context.colors.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(context.radii.lg),
      ),
    ),
    builder: (_) => const _CityPickerSheet(),
  );
}

class _CityPickerSheet extends ConsumerStatefulWidget {
  const new();

  @override
  ConsumerState<_CityPickerSheet> createState() => _CityPickerSheetState();
}

class _CityPickerSheetState extends ConsumerState<_CityPickerSheet> {
  final _query = TextEditingController();
  bool _locating = false;
  String? _locationError;

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  Future<void> _useLocation(CityIndex index) async {
    final l10n = context.l10n;
    setState(() {
      _locating = true;
      _locationError = null;
    });
    try {
      final position = await ref
          .read(locationRepositoryProvider)
          .approximatePosition();
      if (!mounted) return;
      Navigator.of(context).pop(index.nearest(position.lat, position.lng));
    } on LocationUnavailable catch (e) {
      setState(
        () => _locationError = switch (e.reason) {
          LocationFailureReason.serviceDisabled => l10n.locationDisabled,
          LocationFailureReason.denied ||
          LocationFailureReason.deniedForever => l10n.locationDenied,
        },
      );
    } on Object {
      setState(() => _locationError = l10n.locationFailed);
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final index = ref.watch(cityIndexProvider);
    final locationError = _locationError;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Padding(
        padding: EdgeInsets.fromLTRB(spacing.md, spacing.md, spacing.md, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.cityPickerTitle, style: context.textTheme.titleLarge),
            SizedBox(height: spacing.md),
            TextField(
              controller: _query,
              autofocus: true,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: l10n.citySearchHint,
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            SizedBox(height: spacing.xs),
            if (index.value case final cities?)
              TextButton.icon(
                onPressed: _locating ? null : () => _useLocation(cities),
                icon: _locating
                    ? const SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.my_location),
                label: Text(l10n.useMyLocation),
              ),
            Text(
              locationError ?? l10n.locationPrivacyHint,
              style: context.textTheme.bodySmall?.copyWith(
                color: locationError == null ? null : context.colors.error,
              ),
            ),
            SizedBox(height: spacing.sm),
            Expanded(
              child: AsyncValueView(
                value: index,
                onRetry: () => ref.invalidate(cityIndexProvider),
                data: (cities) {
                  final results = cities.search(_query.text);
                  return ListView.builder(
                    controller: scrollController,
                    itemCount: results.length,
                    itemBuilder: (context, i) {
                      final city = results[i];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(city.name),
                        trailing: Text(
                          city.state,
                          style: context.textTheme.labelMedium,
                        ),
                        onTap: () => Navigator.of(context).pop(city),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
