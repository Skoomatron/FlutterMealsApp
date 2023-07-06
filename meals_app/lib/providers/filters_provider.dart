import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/meals_provider.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegan,
  vegetarian,
}

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier() : super({
    Filter.glutenFree: false,
    Filter.lactoseFree: false,
    Filter.vegetarian: false,
    Filter.vegan: false,
  });

  void setFilter(Filter filter, bool isActive) {
    state = {
      ...state,
      filter: isActive,
    };
  }

  void setFilters(Map<Filter, bool> choseFilters) {
    state = choseFilters;
  }
}

final filtersProvider = StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>((ref) {
  return FiltersNotifier();
});

final filteredMealsProvider = Provider((ref) {

  final filterWatch = ref.watch(filtersProvider);
  final mealsWatch = ref.watch(mealsProvider);

  return mealsWatch.where((meal) {
    if (filterWatch[Filter.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (filterWatch[Filter.vegan]! && !meal.isVegan) {
      return false;
    }
    if (filterWatch[Filter.vegetarian]! && !meal.isVegetarian) {
      return false;
    }
    if (filterWatch[Filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    return true;
  }).toList();
});