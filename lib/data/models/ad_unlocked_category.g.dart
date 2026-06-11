// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad_unlocked_category.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAdUnlockedCategoryCollection on Isar {
  IsarCollection<AdUnlockedCategory> get adUnlockedCategorys =>
      this.collection();
}

const AdUnlockedCategorySchema = CollectionSchema(
  name: r'AdUnlockedCategory',
  id: -1602647587719245764,
  properties: {
    r'categorySlug': PropertySchema(
      id: 0,
      name: r'categorySlug',
      type: IsarType.string,
    ),
    r'unlockedAt': PropertySchema(
      id: 1,
      name: r'unlockedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _adUnlockedCategoryEstimateSize,
  serialize: _adUnlockedCategorySerialize,
  deserialize: _adUnlockedCategoryDeserialize,
  deserializeProp: _adUnlockedCategoryDeserializeProp,
  idName: r'id',
  indexes: {
    r'categorySlug': IndexSchema(
      id: 6271815339910983316,
      name: r'categorySlug',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'categorySlug',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _adUnlockedCategoryGetId,
  getLinks: _adUnlockedCategoryGetLinks,
  attach: _adUnlockedCategoryAttach,
  version: '3.3.2',
);

int _adUnlockedCategoryEstimateSize(
  AdUnlockedCategory object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.categorySlug.length * 3;
  return bytesCount;
}

void _adUnlockedCategorySerialize(
  AdUnlockedCategory object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.categorySlug);
  writer.writeDateTime(offsets[1], object.unlockedAt);
}

AdUnlockedCategory _adUnlockedCategoryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AdUnlockedCategory();
  object.categorySlug = reader.readString(offsets[0]);
  object.id = id;
  object.unlockedAt = reader.readDateTime(offsets[1]);
  return object;
}

P _adUnlockedCategoryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _adUnlockedCategoryGetId(AdUnlockedCategory object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _adUnlockedCategoryGetLinks(
  AdUnlockedCategory object,
) {
  return [];
}

void _adUnlockedCategoryAttach(
  IsarCollection<dynamic> col,
  Id id,
  AdUnlockedCategory object,
) {
  object.id = id;
}

extension AdUnlockedCategoryByIndex on IsarCollection<AdUnlockedCategory> {
  Future<AdUnlockedCategory?> getByCategorySlug(String categorySlug) {
    return getByIndex(r'categorySlug', [categorySlug]);
  }

  AdUnlockedCategory? getByCategorySlugSync(String categorySlug) {
    return getByIndexSync(r'categorySlug', [categorySlug]);
  }

  Future<bool> deleteByCategorySlug(String categorySlug) {
    return deleteByIndex(r'categorySlug', [categorySlug]);
  }

  bool deleteByCategorySlugSync(String categorySlug) {
    return deleteByIndexSync(r'categorySlug', [categorySlug]);
  }

  Future<List<AdUnlockedCategory?>> getAllByCategorySlug(
    List<String> categorySlugValues,
  ) {
    final values = categorySlugValues.map((e) => [e]).toList();
    return getAllByIndex(r'categorySlug', values);
  }

  List<AdUnlockedCategory?> getAllByCategorySlugSync(
    List<String> categorySlugValues,
  ) {
    final values = categorySlugValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'categorySlug', values);
  }

  Future<int> deleteAllByCategorySlug(List<String> categorySlugValues) {
    final values = categorySlugValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'categorySlug', values);
  }

  int deleteAllByCategorySlugSync(List<String> categorySlugValues) {
    final values = categorySlugValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'categorySlug', values);
  }

  Future<Id> putByCategorySlug(AdUnlockedCategory object) {
    return putByIndex(r'categorySlug', object);
  }

  Id putByCategorySlugSync(AdUnlockedCategory object, {bool saveLinks = true}) {
    return putByIndexSync(r'categorySlug', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCategorySlug(List<AdUnlockedCategory> objects) {
    return putAllByIndex(r'categorySlug', objects);
  }

  List<Id> putAllByCategorySlugSync(
    List<AdUnlockedCategory> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'categorySlug', objects, saveLinks: saveLinks);
  }
}

extension AdUnlockedCategoryQueryWhereSort
    on QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QWhere> {
  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AdUnlockedCategoryQueryWhere
    on QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QWhereClause> {
  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterWhereClause>
  idNotEqualTo(Id id) {
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

  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterWhereClause>
  idBetween(
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

  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterWhereClause>
  categorySlugEqualTo(String categorySlug) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'categorySlug',
          value: [categorySlug],
        ),
      );
    });
  }

  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterWhereClause>
  categorySlugNotEqualTo(String categorySlug) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'categorySlug',
                lower: [],
                upper: [categorySlug],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'categorySlug',
                lower: [categorySlug],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'categorySlug',
                lower: [categorySlug],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'categorySlug',
                lower: [],
                upper: [categorySlug],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension AdUnlockedCategoryQueryFilter
    on QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QFilterCondition> {
  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterFilterCondition>
  categorySlugEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'categorySlug',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterFilterCondition>
  categorySlugGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'categorySlug',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterFilterCondition>
  categorySlugLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'categorySlug',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterFilterCondition>
  categorySlugBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'categorySlug',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterFilterCondition>
  categorySlugStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'categorySlug',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterFilterCondition>
  categorySlugEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'categorySlug',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterFilterCondition>
  categorySlugContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'categorySlug',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterFilterCondition>
  categorySlugMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'categorySlug',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterFilterCondition>
  categorySlugIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'categorySlug', value: ''),
      );
    });
  }

  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterFilterCondition>
  categorySlugIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'categorySlug', value: ''),
      );
    });
  }

  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterFilterCondition>
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

  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
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

  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterFilterCondition>
  idBetween(
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

  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterFilterCondition>
  unlockedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'unlockedAt', value: value),
      );
    });
  }

  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterFilterCondition>
  unlockedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'unlockedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterFilterCondition>
  unlockedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'unlockedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterFilterCondition>
  unlockedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'unlockedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension AdUnlockedCategoryQueryObject
    on QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QFilterCondition> {}

extension AdUnlockedCategoryQueryLinks
    on QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QFilterCondition> {}

extension AdUnlockedCategoryQuerySortBy
    on QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QSortBy> {
  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterSortBy>
  sortByCategorySlug() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categorySlug', Sort.asc);
    });
  }

  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterSortBy>
  sortByCategorySlugDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categorySlug', Sort.desc);
    });
  }

  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterSortBy>
  sortByUnlockedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockedAt', Sort.asc);
    });
  }

  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterSortBy>
  sortByUnlockedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockedAt', Sort.desc);
    });
  }
}

extension AdUnlockedCategoryQuerySortThenBy
    on QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QSortThenBy> {
  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterSortBy>
  thenByCategorySlug() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categorySlug', Sort.asc);
    });
  }

  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterSortBy>
  thenByCategorySlugDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categorySlug', Sort.desc);
    });
  }

  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterSortBy>
  thenByUnlockedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockedAt', Sort.asc);
    });
  }

  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QAfterSortBy>
  thenByUnlockedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockedAt', Sort.desc);
    });
  }
}

extension AdUnlockedCategoryQueryWhereDistinct
    on QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QDistinct> {
  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QDistinct>
  distinctByCategorySlug({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categorySlug', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QDistinct>
  distinctByUnlockedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unlockedAt');
    });
  }
}

extension AdUnlockedCategoryQueryProperty
    on QueryBuilder<AdUnlockedCategory, AdUnlockedCategory, QQueryProperty> {
  QueryBuilder<AdUnlockedCategory, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AdUnlockedCategory, String, QQueryOperations>
  categorySlugProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categorySlug');
    });
  }

  QueryBuilder<AdUnlockedCategory, DateTime, QQueryOperations>
  unlockedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unlockedAt');
    });
  }
}
