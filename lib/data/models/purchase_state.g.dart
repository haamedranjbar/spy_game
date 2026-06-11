// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_state.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPurchaseStateCollection on Isar {
  IsarCollection<PurchaseState> get purchaseStates => this.collection();
}

const PurchaseStateSchema = CollectionSchema(
  name: r'PurchaseState',
  id: -7811638884700737030,
  properties: {
    r'isGoldenUser': PropertySchema(
      id: 0,
      name: r'isGoldenUser',
      type: IsarType.bool,
    ),
    r'purchaseDate': PropertySchema(
      id: 1,
      name: r'purchaseDate',
      type: IsarType.dateTime,
    ),
    r'purchaseToken': PropertySchema(
      id: 2,
      name: r'purchaseToken',
      type: IsarType.string,
    ),
  },

  estimateSize: _purchaseStateEstimateSize,
  serialize: _purchaseStateSerialize,
  deserialize: _purchaseStateDeserialize,
  deserializeProp: _purchaseStateDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _purchaseStateGetId,
  getLinks: _purchaseStateGetLinks,
  attach: _purchaseStateAttach,
  version: '3.3.2',
);

int _purchaseStateEstimateSize(
  PurchaseState object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.purchaseToken;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _purchaseStateSerialize(
  PurchaseState object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.isGoldenUser);
  writer.writeDateTime(offsets[1], object.purchaseDate);
  writer.writeString(offsets[2], object.purchaseToken);
}

PurchaseState _purchaseStateDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PurchaseState();
  object.id = id;
  object.isGoldenUser = reader.readBool(offsets[0]);
  object.purchaseDate = reader.readDateTimeOrNull(offsets[1]);
  object.purchaseToken = reader.readStringOrNull(offsets[2]);
  return object;
}

P _purchaseStateDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _purchaseStateGetId(PurchaseState object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _purchaseStateGetLinks(PurchaseState object) {
  return [];
}

void _purchaseStateAttach(
  IsarCollection<dynamic> col,
  Id id,
  PurchaseState object,
) {
  object.id = id;
}

extension PurchaseStateQueryWhereSort
    on QueryBuilder<PurchaseState, PurchaseState, QWhere> {
  QueryBuilder<PurchaseState, PurchaseState, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PurchaseStateQueryWhere
    on QueryBuilder<PurchaseState, PurchaseState, QWhereClause> {
  QueryBuilder<PurchaseState, PurchaseState, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension PurchaseStateQueryFilter
    on QueryBuilder<PurchaseState, PurchaseState, QFilterCondition> {
  QueryBuilder<PurchaseState, PurchaseState, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterFilterCondition>
  isGoldenUserEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isGoldenUser', value: value),
      );
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterFilterCondition>
  purchaseDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'purchaseDate'),
      );
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterFilterCondition>
  purchaseDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'purchaseDate'),
      );
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterFilterCondition>
  purchaseDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'purchaseDate', value: value),
      );
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterFilterCondition>
  purchaseDateGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'purchaseDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterFilterCondition>
  purchaseDateLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'purchaseDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterFilterCondition>
  purchaseDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'purchaseDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterFilterCondition>
  purchaseTokenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'purchaseToken'),
      );
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterFilterCondition>
  purchaseTokenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'purchaseToken'),
      );
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterFilterCondition>
  purchaseTokenEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'purchaseToken',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterFilterCondition>
  purchaseTokenGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'purchaseToken',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterFilterCondition>
  purchaseTokenLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'purchaseToken',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterFilterCondition>
  purchaseTokenBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'purchaseToken',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterFilterCondition>
  purchaseTokenStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'purchaseToken',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterFilterCondition>
  purchaseTokenEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'purchaseToken',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterFilterCondition>
  purchaseTokenContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'purchaseToken',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterFilterCondition>
  purchaseTokenMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'purchaseToken',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterFilterCondition>
  purchaseTokenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'purchaseToken', value: ''),
      );
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterFilterCondition>
  purchaseTokenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'purchaseToken', value: ''),
      );
    });
  }
}

extension PurchaseStateQueryObject
    on QueryBuilder<PurchaseState, PurchaseState, QFilterCondition> {}

extension PurchaseStateQueryLinks
    on QueryBuilder<PurchaseState, PurchaseState, QFilterCondition> {}

extension PurchaseStateQuerySortBy
    on QueryBuilder<PurchaseState, PurchaseState, QSortBy> {
  QueryBuilder<PurchaseState, PurchaseState, QAfterSortBy>
  sortByIsGoldenUser() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGoldenUser', Sort.asc);
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterSortBy>
  sortByIsGoldenUserDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGoldenUser', Sort.desc);
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterSortBy>
  sortByPurchaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseDate', Sort.asc);
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterSortBy>
  sortByPurchaseDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseDate', Sort.desc);
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterSortBy>
  sortByPurchaseToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseToken', Sort.asc);
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterSortBy>
  sortByPurchaseTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseToken', Sort.desc);
    });
  }
}

extension PurchaseStateQuerySortThenBy
    on QueryBuilder<PurchaseState, PurchaseState, QSortThenBy> {
  QueryBuilder<PurchaseState, PurchaseState, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterSortBy>
  thenByIsGoldenUser() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGoldenUser', Sort.asc);
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterSortBy>
  thenByIsGoldenUserDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGoldenUser', Sort.desc);
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterSortBy>
  thenByPurchaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseDate', Sort.asc);
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterSortBy>
  thenByPurchaseDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseDate', Sort.desc);
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterSortBy>
  thenByPurchaseToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseToken', Sort.asc);
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QAfterSortBy>
  thenByPurchaseTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseToken', Sort.desc);
    });
  }
}

extension PurchaseStateQueryWhereDistinct
    on QueryBuilder<PurchaseState, PurchaseState, QDistinct> {
  QueryBuilder<PurchaseState, PurchaseState, QDistinct>
  distinctByIsGoldenUser() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isGoldenUser');
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QDistinct>
  distinctByPurchaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'purchaseDate');
    });
  }

  QueryBuilder<PurchaseState, PurchaseState, QDistinct>
  distinctByPurchaseToken({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'purchaseToken',
        caseSensitive: caseSensitive,
      );
    });
  }
}

extension PurchaseStateQueryProperty
    on QueryBuilder<PurchaseState, PurchaseState, QQueryProperty> {
  QueryBuilder<PurchaseState, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PurchaseState, bool, QQueryOperations> isGoldenUserProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isGoldenUser');
    });
  }

  QueryBuilder<PurchaseState, DateTime?, QQueryOperations>
  purchaseDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'purchaseDate');
    });
  }

  QueryBuilder<PurchaseState, String?, QQueryOperations>
  purchaseTokenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'purchaseToken');
    });
  }
}
