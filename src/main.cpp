#include <bits/stdc++.h>
#include <check_dep.hpp>
#include <Core/mylib.h>
#include <sonic/sonic.h>

int main(int arc, char **argv) {

  mylib_test();

  json_cpp_test();
  tbb_test();
  range_v3_test();
  cpr_test();
  simple_boost_test();
  zmq_test();
  // odbc_test();
  // soci_test();
  rttr_test();
  qt_test();
  sonic_test();

  return 0;
}