import 'package:flutter/material.dart';

/// تبدیل نام آیکون ذخیره‌شده به IconData
IconData categoryIconFromName(String iconName) {
  return switch (iconName) {
    'restaurant' => Icons.restaurant,
    'place' => Icons.place,
    'sports_soccer' => Icons.sports_soccer,
    'category' => Icons.category,
    'movie' => Icons.movie,
    'palette' => Icons.palette,
    'star' => Icons.star,
    'pets' => Icons.pets,
    'location_city' => Icons.location_city,
    'public' => Icons.public,
    'shopping_bag' => Icons.shopping_bag,
    'work' => Icons.work,
    'sports_esports' => Icons.sports_esports,
    'devices' => Icons.devices,
    'build' => Icons.build,
    'directions_car' => Icons.directions_car,
    'animation' => Icons.animation,
    _ => Icons.extension,
  };
}
