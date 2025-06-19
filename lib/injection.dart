// lib/injection.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

// This is the generated file that injectable will create.
// We need to import it, even if it doesn't exist yet.
// The build_runner will generate it.
import 'injection.config.dart'; // Assuming this will be the generated file name

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt', // default initializer name
  preferRelativeImports: true, // default
  asExtension: false, // default, or true if you prefer extension methods
)
Future<void> configureDependencies() async => $initGetIt(getIt);
