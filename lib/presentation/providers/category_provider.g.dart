// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// بارگذاری دسته‌های یک حالت (کلاسیک / خانوادگی)

@ProviderFor(categoriesByType)
final categoriesByTypeProvider = CategoriesByTypeFamily._();

/// بارگذاری دسته‌های یک حالت (کلاسیک / خانوادگی)

final class CategoriesByTypeProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WordCategory>>,
          List<WordCategory>,
          FutureOr<List<WordCategory>>
        >
    with
        $FutureModifier<List<WordCategory>>,
        $FutureProvider<List<WordCategory>> {
  /// بارگذاری دسته‌های یک حالت (کلاسیک / خانوادگی)
  CategoriesByTypeProvider._({
    required CategoriesByTypeFamily super.from,
    required CategoryType super.argument,
  }) : super(
         retry: null,
         name: r'categoriesByTypeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$categoriesByTypeHash();

  @override
  String toString() {
    return r'categoriesByTypeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<WordCategory>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<WordCategory>> create(Ref ref) {
    final argument = this.argument as CategoryType;
    return categoriesByType(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoriesByTypeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$categoriesByTypeHash() => r'676342fad88a6dfa520fb2063fe86c487c975ab1';

/// بارگذاری دسته‌های یک حالت (کلاسیک / خانوادگی)

final class CategoriesByTypeFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<WordCategory>>, CategoryType> {
  CategoriesByTypeFamily._()
    : super(
        retry: null,
        name: r'categoriesByTypeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// بارگذاری دسته‌های یک حالت (کلاسیک / خانوادگی)

  CategoriesByTypeProvider call(CategoryType type) =>
      CategoriesByTypeProvider._(argument: type, from: this);

  @override
  String toString() => r'categoriesByTypeProvider';
}
