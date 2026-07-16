import 'package:go_router/go_router.dart';
import '../features/home/home_screen.dart';
import '../features/home/city_bus_screen.dart';
import '../features/explore/explore_screen.dart';
import '../features/saved/saved_screen.dart';
import '../features/search/location_picker_screen.dart';
import '../features/search/stop_list_screen.dart';
import '../features/search/bus_options_screen.dart';
import '../features/search/route_detail_screen.dart';
import '../features/search/route_preference_screen.dart';
import '../features/search/route_result_screen.dart';
import '../features/search/place_detail_screen.dart';
import '../features/operators/operators_list_screen.dart';
import '../features/splash/location_gate_screen.dart';
import '../features/system/no_internet_screen.dart';
import '../features/system/error_empty_screen.dart';
import '../models/search_data.dart';
import '../features/emergency/emergency_screen.dart';
import '../features/myplan/my_plan_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/auth/login_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/gate',  // ✅ App starts at Location Gate
  routes: [
    GoRoute(
      path: '/gate',
      name: 'gate',
      builder: (context, state) => const LocationGateScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/explore',
      name: 'explore',
      builder: (context, state) => const ExploreScreen(),
    ),
    GoRoute(
      path: '/saved',
      name: 'saved',
      builder: (context, state) => const SavedScreen(),
    ),
    GoRoute(
      path: '/city-bus',
      name: 'city-bus',
      builder: (context, state) => const CityBusScreen(),
    ),
    GoRoute(
      path: '/city-vehicles',
      name: 'city-vehicles',
      builder: (context, state) => const LocationPickerScreen(type: 'source'),
    ),
    GoRoute(
      path: '/operators',
      name: 'operators',
      builder: (context, state) => const OperatorsListScreen(),
    ),
    GoRoute(
      path: '/stop-list',
      name: 'stop-list',
      builder: (context, state) => const StopListScreen(),
    ),
    GoRoute(
      path: '/bus-options',
      name: 'bus-options',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return BusOptionsScreen(route: extra);
      },
    ),
    GoRoute(
      path: '/route-detail',
      name: 'route-detail',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return RouteDetailScreen(route: extra);
      },
    ),
    GoRoute(
      path: '/route-preference',
      name: 'route-preference',
      builder: (context, state) {
        final searchData = state.extra as SearchData? ?? SearchData.empty();
        return RoutePreferenceScreen(searchData: searchData);
      },
    ),
    GoRoute(
      path: '/route-result',
      name: 'route-result',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return RouteResultsScreen(
          searchData: extra['searchData'] ?? SearchData.empty(),
          preference: extra['preference'],
        );
      },
    ),
    GoRoute(
      path: '/place-detail',
      name: 'place-detail',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return PlaceDetailScreen(
          name: extra['name'] ?? 'Place',
          location: extra['location'] ?? 'Kathmandu',
          description: extra['description'] ?? 'A beautiful place to visit.',
          lat: extra['lat'] ?? 27.7172,
          lng: extra['lng'] ?? 85.3240,
          nearestStop: extra['nearestStop'] ?? 'Kathmandu',
        );
      },
    ),
    GoRoute(
      path: '/no-internet',
      name: 'no-internet',
      builder: (context, state) => const NoInternetScreen(),
    ),
    GoRoute(
      path: '/error-empty',
      name: 'error-empty',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return ErrorEmptyScreen(
          title: extra['title'] ?? 'Error',
          message: extra['message'] ?? 'Something went wrong',
          actionLabel: extra['actionLabel'] ?? 'Retry',
          onAction: extra['onAction'],
        );
      },
    ),
    GoRoute(
      path: '/emergency',
      name: 'emergency',
      builder: (context, state) => const EmergencyScreen(),
    ),
    GoRoute(
      path: '/myplan',
      name: 'myplan',
      builder: (context, state) => const MyPlanScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
        GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
  ],
);