import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shortly/app/data/datasources/shorten_local_datasource.dart';
import 'package:shortly/app/data/models/shorten_model.dart';
import 'package:shortly/app/data/repositories/shorten_repository_impl.dart';
import 'package:shortly/app/domain/repositories/shorten_repository.dart';
import 'package:shortly/app/domain/usecases/usecases.dart';
import 'package:shortly/app/view/bloc/shorten/shorten_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final appDir = await getApplicationDocumentsDirectory();

  // Initialize Hive
  Hive.init(appDir.path);
  // Register TodoModelAdapter
  //Hive.registerAdapter(ShortenModelAdapter(), 0);

  // Open TodoModel Box
  final box = await Hive.openBox(shortenModelHiveName);

  // Hive
  sl.registerLazySingleton<Box>(() => box);

  // Bloc
  sl.registerFactory<ShortenBloc>(() =>
      ShortenBloc(
        addShorten: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => AddShortenUseCase(repository: sl()));

  // Repositories
  sl.registerLazySingleton<ShortenRepository>(() =>
      ShortenRepositoryImpl(localDataSource: sl()));

  // Data Sources
  sl.registerLazySingleton<ShortenLocalDataSource>(() =>
      ShortenLocalDataSourceImpl(shortenBox: sl()));
}
