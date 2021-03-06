import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shortly/app/data/datasources/datasources.dart';
import 'package:shortly/app/data/models/models.dart';
import 'package:shortly/app/data/repositories/shorten_repository_impl.dart';
import 'package:shortly/app/domain/repositories/shorten_repository.dart';
import 'package:shortly/app/domain/usecases/usecases.dart';
import 'package:shortly/app/view/bloc/blocs.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final appDir = await getApplicationDocumentsDirectory();

  // Initialize Hive
  Hive.init(appDir.path);
  // Register ShortenModelAdapter
  Hive.registerAdapter(ShortenModelAdapter(), 0);

  // Open ShortenModel Box
  final box = await Hive.openBox(shortenModelHiveName);

  // Hive
  sl.registerLazySingleton<Box>(() => box);

  // Bloc
  sl.registerFactory<ShortenBloc>(() =>
      ShortenBloc(
        addShorten: sl(),
        getShortenList: sl(),
        deleteShorten: sl(),
        toggleFavShorten: sl(),
        syncShorten: sl(),
      ));

  sl.registerFactory<TabBloc>(() => TabBloc());
  sl.registerFactory<FavBloc>(() => FavBloc(getFavShortenList: sl()));

  // Use cases
  sl.registerLazySingleton(() => AddShortenUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetShortenListUseCase(repository: sl()));
  sl.registerLazySingleton(() => ToggleFavShortenUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteShortenUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetFavShortenListUseCase(repository: sl()));
  sl.registerLazySingleton(() => SyncShortenUseCase(repository: sl()));

  // Repositories
  sl.registerLazySingleton<ShortenRepository>(() =>
      ShortenRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()));

  // Data Sources
  sl.registerLazySingleton<ShortenLocalDataSource>(
          () => ShortenLocalDataSourceImpl(shortenBox: sl()));
  sl.registerLazySingleton<ShortenRemoteDataSource>(
          () => ShortenRemoteDataSourceImpl(client: sl()));

  // Http Client
  sl.registerLazySingleton(() => http.Client());
}
