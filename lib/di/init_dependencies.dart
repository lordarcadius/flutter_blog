import 'package:blog_app/core/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/env/supabase_env.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:blog_app/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_app/feature/auth/domain/repositories/auth_repository.dart';
import 'package:blog_app/feature/auth/domain/usecases/current_user.dart';
import 'package:blog_app/feature/auth/domain/usecases/user_login.dart';
import 'package:blog_app/feature/auth/domain/usecases/user_signup.dart';
import 'package:blog_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/feature/blog/data/datasources/blog_local_data_source.dart';
import 'package:blog_app/feature/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app/feature/blog/data/repositories/blog_repository_impl.dart';
import 'package:blog_app/feature/blog/domain/repositories/blog_repository.dart';
import 'package:blog_app/feature/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/feature/blog/domain/usecases/upload_blog.dart';
import 'package:blog_app/feature/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();

  final supabase = await Supabase.initialize(
    url: SupabaseEnv.supabaseUrl,
    anonKey: SupabaseEnv.supabaseKey,
  );
  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerLazySingleton(
    () => Hive.box(name: "blogs"),
  );

  serviceLocator.registerFactory(() => InternetConnection());

  //Dependencies for Core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      internetConnection: serviceLocator(),
    ),
  );
}

void _initAuth() {
  serviceLocator
    //Data Source
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        supabaseClient: serviceLocator(),
      ),
    )
    ..registerFactory<BlogLocalDataSource>(
        () => BlogLocalDataSourceImpl(box: serviceLocator()))
    //Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: serviceLocator(),
        connectionChecker: serviceLocator(),
      ),
    )
    //Signup Usecase
    ..registerFactory(
      () => UserSignUp(
        authRepository: serviceLocator(),
      ),
    )
    //Login Usecase
    ..registerFactory(
      () => UserLogin(
        authRepository: serviceLocator(),
      ),
    )

    //Current user Usecase
    ..registerFactory(
      () => CurrentUser(
        authRepository: serviceLocator(),
      ),
    )
    //Auth Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initBlog() {
  //Data source
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(
        supabaseClient: serviceLocator(),
      ),
    )

    //Repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        blogRemoteDataSource: serviceLocator(),
        blogLocalDataSource: serviceLocator(),
        connectionChecker: serviceLocator(),
      ),
    )

    //Upload Usecase
    ..registerFactory(
      () => UploadBlog(
        blogRepository: serviceLocator(),
      ),
    )

    //Fetch blogs Usecase
    ..registerFactory(
      () => GetAllBlogs(
        blogRepository: serviceLocator(),
      ),
    )

    //Bloc
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
        getAllBlogs: serviceLocator(),
      ),
    );
}
