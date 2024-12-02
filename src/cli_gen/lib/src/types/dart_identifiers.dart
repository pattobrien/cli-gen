import 'models/identifier_part.dart';

/// Identifiers for the `dart:core` library.
class DartCoreIdentifiers {
  const DartCoreIdentifiers();

  static final Uri _uri = Uri.parse('dart:core');
  // Uri get uri => _uri;

  IdentifierPart get map => IdentifierPart('Map', _uri);
  IdentifierPart get string => IdentifierPart('String', _uri);
  IdentifierPart get dynamic => IdentifierPart('dynamic', _uri);
  IdentifierPart get object => IdentifierPart('Object', _uri);
  IdentifierPart get bool => IdentifierPart('bool', _uri);
  IdentifierPart get int => IdentifierPart('int', _uri);
  IdentifierPart get double => IdentifierPart('double', _uri);
  IdentifierPart get num => IdentifierPart('num', _uri);
  IdentifierPart get bigInt => IdentifierPart('BigInt', _uri);
  IdentifierPart get dateTime => IdentifierPart('DateTime', _uri);
  IdentifierPart get uri => IdentifierPart('Uri', _uri);
  IdentifierPart get list => IdentifierPart('List', _uri);
  IdentifierPart get set => IdentifierPart('Set', _uri);
  IdentifierPart get iterable => IdentifierPart('Iterable', _uri);
  IdentifierPart get future => IdentifierPart('Future', _uri);
  IdentifierPart get futureOr => IdentifierPart('FutureOr', _uri);
  IdentifierPart get stream => IdentifierPart('Stream', _uri);
  IdentifierPart get symbol => IdentifierPart('Symbol', _uri);
  IdentifierPart get type => IdentifierPart('Type', _uri);
  IdentifierPart get void_ => IdentifierPart('void', _uri);

  IdentifierPart get print => IdentifierPart('print', _uri);

  IdentifierPart get override => IdentifierPart('override', _uri);
}
