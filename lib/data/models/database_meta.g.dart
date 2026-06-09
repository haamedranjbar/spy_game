// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_meta.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDatabaseMetaCollection on Isar {
  IsarCollection<DatabaseMeta> get databaseMetas => this.collection();
}

const DatabaseMetaSchema = CollectionSchema(
  name: r'DatabaseMeta',
  id: 5318614034276143204,
  properties: {
    r'version': PropertySchema(id: 0, name: r'version', type: IsarType.long),
  },

  estimateSize: _databaseMetaEstimateSize,
  serialize: _databaseMetaSerialize,
  deserialize: _databaseMetaDeserialize,
  deserializeProp: _databaseMetaDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _databaseMetaGetId,
  getLinks: _databaseMetaGetLinks,
  attach: _databaseMetaAttach,
  version: '3.3.2',
);

int _databaseMetaEstimateSize(
  DatabaseMeta object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _databaseMetaSerialize(
  DatabaseMeta object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.version);
}

DatabaseMeta _databaseMetaDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DatabaseMeta();
  object.id = id;
  object.version = reader.readLong(offsets[0]);
  return object;
}

P _databaseMetaDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _databaseMetaGetId(DatabaseMeta object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _databaseMetaGetLinks(DatabaseMeta object) {
  return [];
}

void _databaseMetaAttach(
  IsarCollection<dynamic> col,
  Id id,
  DatabaseMeta object,
) {
  object.id = id;
}

extension DatabaseMetaQueryWhereSort
    on QueryBuilder<DatabaseMeta, DatabaseMeta, QWhere> {
  QueryBuilder<DatabaseMeta, DatabaseMeta, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DatabaseMetaQueryWhere
    on QueryBuilder<DatabaseMeta, DatabaseMeta, QWhereClause> {
  QueryBuilder<DatabaseMeta, DatabaseMeta, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<DatabaseMeta, DatabaseMeta, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<DatabaseMeta, DatabaseMeta, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DatabaseMeta, DatabaseMeta, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DatabaseMeta, DatabaseMeta, QAfterWhereClause> idBetween(
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

extension DatabaseMetaQueryFilter
    on QueryBuilder<DatabaseMeta, DatabaseMeta, QFilterCondition> {
  QueryBuilder<DatabaseMeta, DatabaseMeta, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<DatabaseMeta, DatabaseMeta, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<DatabaseMeta, DatabaseMeta, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<DatabaseMeta, DatabaseMeta, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DatabaseMeta, DatabaseMeta, QAfterFilterCondition>
  versionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'version', value: value),
      );
    });
  }

  QueryBuilder<DatabaseMeta, DatabaseMeta, QAfterFilterCondition>
  versionGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'version',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DatabaseMeta, DatabaseMeta, QAfterFilterCondition>
  versionLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'version',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DatabaseMeta, DatabaseMeta, QAfterFilterCondition>
  versionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'version',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension DatabaseMetaQueryObject
    on QueryBuilder<DatabaseMeta, DatabaseMeta, QFilterCondition> {}

extension DatabaseMetaQueryLinks
    on QueryBuilder<DatabaseMeta, DatabaseMeta, QFilterCondition> {}

extension DatabaseMetaQuerySortBy
    on QueryBuilder<DatabaseMeta, DatabaseMeta, QSortBy> {
  QueryBuilder<DatabaseMeta, DatabaseMeta, QAfterSortBy> sortByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<DatabaseMeta, DatabaseMeta, QAfterSortBy> sortByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }
}

extension DatabaseMetaQuerySortThenBy
    on QueryBuilder<DatabaseMeta, DatabaseMeta, QSortThenBy> {
  QueryBuilder<DatabaseMeta, DatabaseMeta, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DatabaseMeta, DatabaseMeta, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DatabaseMeta, DatabaseMeta, QAfterSortBy> thenByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<DatabaseMeta, DatabaseMeta, QAfterSortBy> thenByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }
}

extension DatabaseMetaQueryWhereDistinct
    on QueryBuilder<DatabaseMeta, DatabaseMeta, QDistinct> {
  QueryBuilder<DatabaseMeta, DatabaseMeta, QDistinct> distinctByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'version');
    });
  }
}

extension DatabaseMetaQueryProperty
    on QueryBuilder<DatabaseMeta, DatabaseMeta, QQueryProperty> {
  QueryBuilder<DatabaseMeta, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DatabaseMeta, int, QQueryOperations> versionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'version');
    });
  }
}
