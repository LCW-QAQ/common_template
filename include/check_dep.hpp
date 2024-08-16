#pragma once

// #include <QCoreApplication>
// #include <QDebug>
// #include <QSql>
// #include <QSqlDatabase>
// #include <QSqlError>
// #include <QSqlQuery>
#include <bits/stdc++.h>
#include <boost/asio.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/type_index.hpp>
#include <cpr/cpr.h>
#include <json/json.h>
#include <range/v3/range.hpp>
#include <range/v3/view.hpp>
#include <rttr/registration>
#include <rttr/type>
#include <soci/odbc/soci-odbc.h>
#include <soci/soci.h>
#include <sqlext.h>
// #include <tbb/tbb.h>
#include <sonic/sonic.h>
#include <yaml-cpp/yaml.h>
#include <zmq.hpp>


using namespace std::literals;

#define DSNNAME "pg"

#define SQLOK(rc) ((SQL_SUCCESS == rc) || (SQL_SUCCESS_WITH_INFO == rc))

#define BUFF_LEN (512)
unsigned char szSQL[BUFF_LEN] = {0};
SQLHENV g_henv;   // Handle ODBC environment
SQLHSTMT g_hstmt; // Handle statement
SQLHDBC g_hdbc;   // Handle connection
SQLINTEGER value = 100;
SQLINTEGER V_OD_erg;

void tbb_test() {
  // tbb::concurrent_queue<int> q;
  // q.emplace(0);
}

void json_cpp_test() {
  Json::Value val;
  val["hello"] = 10;
  val["cc"];
  std::cout << val << "\n";
}

void range_v3_test() {
  std::vector<int> q;
  auto vec = std::vector<int>(q.begin(), q.end());
  vec | ranges::views::filter([](auto it) { return true; });
}

void yaml_cpp_test() {
  auto node = YAML::LoadFile("../../app.yaml");
  std::cout << node << "\n";
}

void cpr_test() {
  auto resp = cpr::Get(cpr::Url{"https://www.gitee.com"});
  std::cout << "status_code: " << resp.status_code << "\n";
}

void simple_boost_test() {
  std::cout << boost::typeindex::type_id<int>() << "\n";
  std::cout << boost::typeindex::type_id<std::vector<int>>().name() << "\n";
  std::cout << boost::typeindex::type_id<std::vector<int>>().pretty_name()
            << "\n";
}

void zmq_test() {
  zmq::context_t ctx;
  zmq::socket_t sock(ctx, zmq::socket_type::pull);
  sock.bind("tcp://localhost:8080");

  zmq::socket_t sock2(ctx, zmq::socket_type::push);
  sock2.connect("tcp://localhost:8080");
  sock2.send(zmq::message_t("cc main"sv), zmq::send_flags::dontwait);

  zmq::message_t recv_msg;
  sock.recv(recv_msg);
  std::cout << recv_msg << "\n";
}

void HandleSQLConnectError(SQLHENV envHandle, SQLHDBC dbcHandle) {
  SQLCHAR sqlState[SQL_SQLSTATE_SIZE + 1];
  SQLINTEGER nativeError;
  SQLCHAR message[SQL_MAX_MESSAGE_LENGTH + 1];
  SQLSMALLINT textLength;
  SQLRETURN retCode;

  // 获取错误描述
  retCode = SQLGetDiagRec(SQL_HANDLE_DBC, dbcHandle, 1, sqlState, &nativeError,
                          message, sizeof(message), &textLength);
  if (retCode == SQL_SUCCESS || retCode == SQL_SUCCESS_WITH_INFO) {
    // 打印错误信息
    printf("Error Code: %d\nSQLSTATE: %s\nMessage: %s\n", nativeError, sqlState,
           message);
  } else {
    printf("Error retrieving diagnostic information.\n");
  }
}

void odbc_test() {
  SQLRETURN retcode;
  retcode = SQLAllocHandle(SQL_HANDLE_ENV, SQL_NULL_HANDLE, &g_henv);
  if (!SQLOK(retcode)) {
    printf("%s, %d, SQLAllocHandle %d\n", __func__, __LINE__, retcode);
    exit(0);
  }
  SQLSetEnvAttr(g_henv, SQL_ATTR_ODBC_VERSION, (void *)SQL_OV_ODBC3, 0);

  retcode = SQLAllocHandle(SQL_HANDLE_DBC, g_henv, &g_hdbc);
  if (!SQLOK(retcode)) {
    SQLFreeHandle(SQL_HANDLE_ENV, g_henv);
    printf("%s, %d, SQLAllocHandle %d\n", __func__, __LINE__, retcode);
    exit(0);
  }

  SQLSetConnectAttr(g_hdbc, SQL_LOGIN_TIMEOUT, (SQLPOINTER)10, 0);
  SQLSetConnectAttr(g_hdbc, SQL_ATTR_AUTOCOMMIT, (SQLPOINTER)SQL_AUTOCOMMIT_OFF,
                    0);
  retcode = SQLConnect(g_hdbc, (SQLCHAR *)DSNNAME, SQL_NTS, NULL, SQL_NTS, NULL,
                       SQL_NTS);
  // SQLGetDiagRec(SQL_HANDLE_DBC, g_hdbc, )
  if (!SQLOK(retcode)) {
    printf("%s, %d, SQLConnect %d\n", __func__, __LINE__, retcode);

    HandleSQLConnectError(g_henv, g_hdbc);

    SQLFreeHandle(SQL_HANDLE_ENV, g_henv);
    exit(0);
  }
  printf("Connected !\n");

  retcode = SQLAllocHandle(SQL_HANDLE_STMT, g_hdbc, &g_hstmt);
  if (!SQLOK(retcode)) {
    SQLFreeHandle(SQL_HANDLE_ENV, g_henv);
    printf("%s, %d, SQLAllocHandle %d\n", __func__, __LINE__, retcode);
    exit(0);
  }
}

void soci_test() {
  soci::session sql{soci::odbc, "DSN=pg"};

  int count;
  sql << "select count(*) from sys_web_user;", soci::into(count);

  std::cout << "We have " << count << " entries in the sys_web_user.\n";

  std::string name;
  while (true) {
    std::cout << "Enter name: ";
    std::cin >> name;

    std::string real_name;
    soci::indicator ind;
    sql << "select real_name from sys_web_user where user_name = :name",
        into(real_name, ind), soci::use(name);

    if (ind == soci::i_ok) {
      std::cout << "The real_name is " << real_name << '\n';
    } else {
      std::cout << "There is no real_name for " << name << '\n';
    }
  }
}

class Person {
public:
  std::string name{"Default"};
  uint32_t age{0};

  void say() {
    std::cout << "my name is: " << name << ", age: " << age << "\n";
  }
};

RTTR_REGISTRATION {
  rttr::registration::class_<Person>("Person")
      .constructor<>()
      .property("name", &Person::name)
      .property("age", &Person::age);
  // .method("say", &Person::say);

  rttr::registration::class_<Person>("Person").method("say", &Person::say);
}

void rttr_test() {
  Person p{"city", 10};
  auto type = rttr::type::get<Person>();
  auto properties = type.get_properties();
  for (auto &&prop : properties) {
    std::cout << "name: " << prop.get_name()
              << ", value: " << prop.get_value(p).to_string() << std::endl;
  }
  type.get_method("say").invoke(p);
  type.create({}).convert<Person>().say();
  type.get_constructor().invoke().convert<Person>().say();
}

void qt_test() {
  // int argc = 0;
  // QCoreApplication app(argc, nullptr);

  // qDebug() << QSqlDatabase::drivers();

  // auto db = QSqlDatabase::addDatabase("QPSQL");
  // db.setHostName("127.0.0.1");
  // db.setPort(6000);
  // db.setUserName("postgres");
  // db.setPassword("123456");
  // db.setDatabaseName("kunshan_new");

  // if (!db.open()) {
  //   qDebug() << "db connection failed!" << db.lastError();
  //   app.exit(-1);
  //   return;
  // }

  // QSqlQuery q(db);
  // q.prepare("select count(*) as cnt from sys_web_user") ;
  // auto res = q.exec();
  // if (!res) {
  //   qDebug() << "create table error" << q.lastError() << "\n";
  //   return;
  // }
  // q.next();
  // qDebug() << "count: " << q.value(0).toInt();
  // app.exit();
}

void sonic_test() {
  sonic_json::Document doc;
  doc.Parse(R"(
  {
    "name": "zs",
    "age": 10
  }
  )");
  std::cout << "name: " << doc.FindMember("name")->value.GetStringView()
            << "\n";
}