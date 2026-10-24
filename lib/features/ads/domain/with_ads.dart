/// Items with an ad (its turn number) after every [every] items. A list
/// shorter than that still gets one ad, at the end. Used by the event list
/// and the carousels on top of it; [firstTurn] makes each carousel start at
/// a different own ad.
List<({T? item, int? ad})> withAds<T>(
  List<T> items,
  int every, {
  int firstTurn = 0,
}) {
  if (items.isEmpty || every <= 0) {
    return [for (final item in items) (item: item, ad: null)];
  }
  final result = <({T? item, int? ad})>[];
  var turn = firstTurn;
  for (final (i, item) in items.indexed) {
    result.add((item: item, ad: null));
    if ((i + 1) % every == 0) result.add((item: null, ad: turn++));
  }
  if (turn == firstTurn) result.add((item: null, ad: turn));
  return result;
}
