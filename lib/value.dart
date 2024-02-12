void someFunction({
  String value = referenceToValue,
}) {}

const _referenceToValue = value;
const referenceToValue = value;
const value = 'foo';

void someFunction2([
  // ignore: no_leading_underscores_for_local_identifiers
  String _privateValue = _referenceToValue,
]) {}
