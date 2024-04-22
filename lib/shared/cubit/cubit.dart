import 'package:bloc/bloc.dart';
import 'package:shop_app_api_2/shared/cubit/states.dart';
import 'package:shop_app_api_2/shared/network/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';





class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  // List<Widget> screen = [
  //   NewTaskes(),
  //   DoneTaskes(),
  //   ArchivedTaskes(),
  // ];
  List<String> title = [
    "NewTaskes",
    "DoneTaskes",
    "ArchivedTaskes",
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      //id intger
      // title String
      //date String
      //time String
      //status String

      print("database created");
      database
          .execute(
              "CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT,date TEXT,time TEXT,status TEXT)")
          .then((value) {})
          .catchError((error) {
        print("Error when creating table${error.toString()}");
      });
    }, onOpen: (database) {
      getDataFromDataBase(database);

      print("database opened");
    }).then((value) {
      database = value;
      emit(AppCreateDataBaseState());
    });
  }

  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES("${title}","${date}","${time}","new" )')
          .then((value) {
        print('$value inserted scucessfully');
        emit(AppInsertDataBaseState());
        getDataFromDataBase(database);
      }).catchError((error) {
        print('error when inserting new record ${error.toString()}');
      });

      return null;
    });
  }

  void getDataFromDataBase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];

    emit(AppGetDataBaseLoadingState());

    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archiveTasks.add(element);
      });

      emit(AppGetDataBaseState());
    });
  }

  void updateData({
    required String status,
    required int id,
  }) async {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDataFromDataBase(database);
      emit(AppUpdateDataBaseState());
    });
  }

  void deleteData({
    required int id,
  }) async {
    database.rawDelete(
      'DELETE FROM Tasks WHERE id = ?',
      [id],
    ).then((value) {
      getDataFromDataBase(database);
      emit(AppDeleteDataBaseState());
    });
  }

  bool isBotttomSheet = false;
  IconData facIcon = Icons.edit;

  void changeBotomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBotttomSheet = isShow;
    facIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  bool isDark = false;

  void changeAppMode({bool? fromShared}) {
    if (fromShared != null)
    {
      isDark = fromShared;
      emit(AppChangeModeState());
    } else {
      isDark = !isDark;
      CacheHelper.putBool(key: 'isDark', value: isDark).then((value) {
        emit(AppChangeModeState());
      });
    }
  }
}
