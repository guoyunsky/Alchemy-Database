#!/bin/bash 

CLI="./xdb-cli"

function init_external() {
  $CLI CREATE TABLE external "(id int primary key, division int, health int, salary FLOAT, name TEXT)"
  $CLI CREATE INDEX external:division:index ON external "(division)"
  $CLI CREATE INDEX external:health:index   ON external "(health)"
}
function init_healthplan() {
  $CLI CREATE TABLE healthplan "(id int primary key, name TEXT)"
}
function init_division() {
  $CLI CREATE TABLE division "(id int primary key, name TEXT, location TEXT)"
  $CLI CREATE INDEX division:name:index ON division "(name)"
}
function init_subdivision() {
  $CLI CREATE TABLE subdivision "(id int primary key, division int, name TEXT)"
  $CLI CREATE INDEX subdivision:division:index ON subdivision "(division)"
}
function init_employee() {
  $CLI CREATE TABLE employee "(id int primary key, division int, salary FLOAT, name TEXT)"
  $CLI CREATE INDEX employee:name:index     ON employee "(name)"
  $CLI CREATE INDEX employee:division:index ON employee "(division)"
}
function init_customer() {
  $CLI CREATE TABLE customer "(id int primary key, employee int, name TEXT, hobby TEXT)"
  $CLI CREATE INDEX customer:employee:index ON customer "(employee)"
  $CLI CREATE INDEX customer:hobby:index    ON customer "(hobby)"
}
function init_worker() {
  $CLI CREATE TABLE worker "(id int primary key, division int, health int, salary FLOAT, name TEXT)"
  $CLI CREATE INDEX worker:division:index ON worker "(division)"
  $CLI CREATE INDEX worker:health:index   ON worker "(health)"
}

function insert_external() {
  $CLI INSERT INTO external VALUES "(1,66,1,15000.99,'marieanne')" "RETURN SIZE"
  $CLI INSERT INTO external VALUES "(2,33,3,75000.77,'rosemarie')"
  $CLI INSERT INTO external VALUES "(3,11,2,55000.55,'johnathan')"
  $CLI INSERT INTO external VALUES "(4,22,1,25000.99,'bartholemew')"
}
function insert_healthplan() {
  $CLI INSERT INTO healthplan VALUES "(1,'none')"
  $CLI INSERT INTO healthplan VALUES "(2,'kaiser')"
  $CLI INSERT INTO healthplan VALUES "(3,'general')"
  $CLI INSERT INTO healthplan VALUES "(4,'extended')"
  $CLI INSERT INTO healthplan VALUES "(5,'foreign')"
}
function insert_subdivision() {
  $CLI INSERT INTO subdivision VALUES "(1,11,'middle-management')"
  $CLI INSERT INTO subdivision VALUES "(2,11,'top-level')"
  $CLI INSERT INTO subdivision VALUES "(3,44,'trial')"
  $CLI INSERT INTO subdivision VALUES "(4,44,'research')"
  $CLI INSERT INTO subdivision VALUES "(5,22,'factory')"
  $CLI INSERT INTO subdivision VALUES "(6,22,'field')"
}
function insert_division() {
  $CLI INSERT INTO division VALUES "(11,'bosses','N.Y.C')"
  $CLI INSERT INTO division VALUES "(22,'workers','Chicago')"
  $CLI INSERT INTO division VALUES "(33,'execs','Dubai')"
  $CLI INSERT INTO division VALUES "(55,'bankers','Zurich')"
  $CLI INSERT INTO division VALUES "(66,'janitors','Detroit')"
  $CLI INSERT INTO division VALUES "(44,'lawyers','L.A.')"
}
function insert_employee() {
  $CLI INSERT INTO employee VALUES "(1,11,10000.99,'jim')"
  $CLI INSERT INTO employee VALUES "(2,22,12000.99,'jack')"
  $CLI INSERT INTO employee VALUES "(3,33,30000.99,'bob')"
  $CLI INSERT INTO employee VALUES "(4,22,23000.99,'bill')"
  $CLI INSERT INTO employee VALUES "(5,22,5000.99,'tim')"
  $CLI INSERT INTO employee VALUES "(6,66,60000.99,'jan')"
  $CLI INSERT INTO employee VALUES "(7,77,7000.99,'beth')"
  $CLI INSERT INTO employee VALUES "(8,88,80000.99,'kim')"
  $CLI INSERT INTO employee VALUES "(9,99,9000.99,'pam')"
  $CLI INSERT INTO employee VALUES "(11,111,111000.99,'sammy')"
}
function insert_customer() {
  $CLI INSERT INTO customer VALUES "(1,2,'johnathan','sailing')"
  $CLI INSERT INTO customer VALUES "(2,3,'bartholemew','fencing')"
  $CLI INSERT INTO customer VALUES "(3,3,'jeremiah','yachting')"
  $CLI INSERT INTO customer VALUES "(4,4,'christopher','curling')"
  $CLI INSERT INTO customer VALUES "(6,4,'jennifer','stamps')"
  $CLI INSERT INTO customer VALUES "(7,4,'marieanne','painting')"
  $CLI INSERT INTO customer VALUES "(8,5,'rosemarie','violin')"
  $CLI INSERT INTO customer VALUES "(9,5,'bethany','choir')"
  $CLI INSERT INTO customer VALUES "(10,6,'gregory','dance')"
}
function insert_worker() {
  $CLI INSERT INTO worker VALUES "(1,11,2,60000.66,'jim')"
  $CLI INSERT INTO worker VALUES "(2,22,1,30000.33,'jack')"
  $CLI INSERT INTO worker VALUES "(3,33,4,90000.99,'bob')"
  $CLI INSERT INTO worker VALUES "(4,44,3,70000.77,'bill')"
  $CLI INSERT INTO worker VALUES "(6,66,1,12000.99,'jan')"
  $CLI INSERT INTO worker VALUES "(7,66,1,11000.99,'beth')"
  $CLI INSERT INTO worker VALUES "(8,11,2,68888.99,'mac')"
  $CLI INSERT INTO worker VALUES "(9,22,1,31111.99,'ken')"
  $CLI INSERT INTO worker VALUES "(10,33,4,111111.99,'seth')"
}

function initer() {
  init_worker
  init_customer
  init_employee
  init_division
  init_subdivision
  init_healthplan
  init_external
}
function inserter() {
  insert_worker
  insert_customer
  insert_employee
  insert_division
  insert_subdivision
  insert_healthplan
  insert_external
}
function dropper() {
  echo "DROPPER"
  $CLI DROP TABLE worker
  $CLI DROP TABLE customer
  $CLI DROP TABLE employee
  $CLI DROP TABLE division
  $CLI DROP TABLE subdivision
  $CLI DROP TABLE healthplan
  $CLI DROP TABLE external
}

function selecter() {
  echo "SELECT"
  echo division -------------------------------------------
  $CLI SELECT "*" FROM division WHERE "id = 22"
  $CLI SELECT "name, location" FROM division WHERE "id = 22"
  echo employee -------------------------------------------
  $CLI SELECT "*" FROM employee WHERE "id=2"
  $CLI SELECT "name,salary" FROM employee WHERE "id=2"
  echo customer -------------------------------------------
  $CLI SELECT "*" FROM customer WHERE "id =2"
  $CLI SELECT name FROM customer WHERE "id =2"
  echo worker ---------------------------------------------
  $CLI SELECT "*" FROM worker WHERE "id = 7"
  $CLI SELECT "name ,salary , division" FROM worker WHERE "id = 7"
  echo subdivision ----------------------------------------
  $CLI SELECT "*" FROM subdivision WHERE "id = 2"
  $CLI SELECT "name,division" FROM subdivision WHERE "id = 2"
  echo healthplan -----------------------------------------
  $CLI SELECT "*" FROM healthplan WHERE "id = 2"
  $CLI SELECT name FROM healthplan WHERE "id = 2"
  echo external -------------------------------------------
  $CLI SELECT "*" FROM external WHERE "id = 3 "
  $CLI SELECT "name,salary,division" FROM external WHERE "id = 3"
}

function updater() {
  echo "UPDATE"
  echo SELECT "*" FROM employee WHERE id = 1
  $CLI SELECT "*" FROM employee WHERE "id = 1"
  echo UPDATE employee SET "salary = salary + 5.55,name= name || 'my',division= division + 11" WHERE id = 1
  $CLI UPDATE employee SET "salary = salary + 5.55,name= name || 'my',division= division + 11" WHERE id = 1
  echo SELECT "*" FROM employee WHERE id = 1
  $CLI SELECT "*" FROM employee WHERE "id = 1"
   echo UPDATE employee SET "salary=5.55,name='NEWNAME',division=66" WHERE id = 1
   $CLI UPDATE employee SET "salary=5.55,name='NEWNAME',division=66" WHERE id = 1
  echo SELECT "*" FROM employee WHERE id = 1
  $CLI SELECT "*" FROM employee WHERE "id = 1"
  echo UPDATE employee SET id=100 WHERE "id = 1"
  $CLI UPDATE employee SET id=100 WHERE "id = 1"
  echo SELECT "*" FROM employee WHERE id = 100
  $CLI SELECT "*" FROM employee WHERE "id = 100"
  echo UPDATE employee SET division=22 WHERE id = 100
  $CLI UPDATE employee SET division=22 WHERE id = 100
  echo SELECT "*" FROM employee WHERE id = 100
  $CLI SELECT "*" FROM employee WHERE "id = 100"
}

function delete_employee() {
  echo SELECT name,salary FROM employee WHERE id = 3
  $CLI SELECT "name,salary" FROM employee WHERE "id = 3"
  echo DELETE FROM employee WHERE id = 3
  $CLI DELETE FROM employee WHERE "id = 3"
  echo SELECT name,salary FROM employee WHERE id = 3
  $CLI SELECT "name,salary" FROM employee WHERE "id = 3"
}
function delete_customer() {
  echo SELECT name, hobby FROM customer WHERE id = 7
  $CLI SELECT "name, hobby" FROM customer WHERE "id = 7"
  echo DELETE FROM customer WHERE id = 7
  $CLI DELETE FROM customer WHERE "id = 7"
  echo SELECT "name, hobby" FROM customer WHERE id = 7
  $CLI SELECT "name, hobby" FROM customer WHERE "id = 7"
}
function delete_division() {
  echo SELECT name, location FROM division WHERE id = 33
  $CLI SELECT "name, location" FROM division WHERE "id = 33"
  echo DELETE FROM division WHERE id = 33
  $CLI DELETE FROM division WHERE "id = 33"
  echo SELECT "name, location" FROM division WHERE id = 33
  $CLI SELECT "name, location" FROM division WHERE "id = 33"
}
  
function deleter() {
  echo "DELETE"
  delete_employee
  delete_customer
  delete_division
}

function iselecter_division() {
  echo SELECT id,name,location FROM division WHERE name BETWEEN a AND z
  $CLI SELECT "id,name,location" FROM division WHERE "name BETWEEN 'a' AND 'z'"
}
function iselecter_employee() {
  echo SELECT id,name,salary,division FROM employee WHERE division BETWEEN 11 AND 55
  $CLI SELECT "id,name,salary,division" FROM employee WHERE "division BETWEEN 11 AND 55"
}
function iselecter_customer() {
  echo SELECT hobby,id,name,employee FROM customer WHERE hobby BETWEEN a AND z
  $CLI SELECT "hobby,id,name,employee" FROM customer WHERE "hobby BETWEEN 'a' AND 'z'"
}
function iselecter_customer_employee() {
  echo SELECT employee,name,id FROM customer WHERE employee BETWEEN 3 AND 6
  $CLI SELECT "employee,name,id" FROM customer WHERE "employee BETWEEN 3 AND 6"
}
function iselecter_worker() {
  echo SELECT id,health,name,salary,division FROM worker WHERE health BETWEEN 1 AND 3
  $CLI SELECT "id,health,name,salary,division" FROM worker WHERE "health BETWEEN 1 AND 3"
}
function iselecter() {
  echo "ISELECT"
  iselecter_division
  echo
  iselecter_employee
  echo
  iselecter_customer
}
function iupdater_customer() {
  $CLI DUMP customer
  echo UPDATE customer SET hobby=FISHING,employee=6 WHERE hobby BETWEEN v AND z
  $CLI UPDATE customer SET "hobby = 'FISHING' ,employee=6" WHERE "hobby BETWEEN 'v' AND 'z'"
  $CLI DUMP customer
}
function iupdater_customer_rev() {
  $CLI DUMP customer
  echo UPDATE customer SET hobby=ziplining,employee=7 WHERE hobby BETWEEN f AND g
  $CLI UPDATE customer SET "hobby='ziplining',employee=7" WHERE "hobby BETWEEN 'f' AND 'g'"
  $CLI DUMP customer
}
function ideleter_customer() {
  echo DELETE FROM customer WHERE employee BETWEEN 4 AND 5
  $CLI DELETE FROM customer WHERE "employee BETWEEN 4 AND 5"
}


function join_div_extrnl() {
  echo externals
  echo SELECT division.name,division.location,external.name,external.salary FROM division,external WHERE division.id=external.division AND division.id BETWEEN 11 AND 80
  $CLI SELECT "division.name , division.location ,external.name, external.salary" FROM "division,external" WHERE "division.id=external.division AND division.id BETWEEN 11 AND 80"
}

function join_div_wrkr() {
  echo workers
  echo SELECT division.name,division.location,worker.name,worker.salary FROM division,worker WHERE division.id = worker.division AND division.id BETWEEN 11 AND 33
  $CLI SELECT "division.name,division.location,worker.name,worker.salary" FROM "division, worker" WHERE "division.id = worker.division AND division.id BETWEEN 11 AND 33"
}

function join_div_sub_ext() {
  echo subdivision
  echo SELECT subdivision.name, division.name,division.location,external.name,external.salary FROM division,external,subdivision WHERE "subdivision.division = division.id AND subdivision.division=external.division AND division.id BETWEEN 11 AND 80"
  $CLI SELECT subdivision.name, division.name,division.location,external.name,external.salary FROM division,external,subdivision WHERE "subdivision.division = division.id AND subdivision.division=external.division AND division.id BETWEEN 11 AND 80"
}
function order_by_test() {
  echo "ORDER BY TEST"
  echo SELECT id,name,salary,division FROM employee WHERE id BETWEEN 4 AND 9 ORDER BY id LIMIT 4 OFFSET 1;
  $CLI SELECT "id,name,salary,division" FROM employee WHERE "id BETWEEN 4 AND 9 ORDER BY id LIMIT 4 OFFSET 1"

  echo SELECT id,name,salary,division FROM employee WHERE id BETWEEN 4 AND 9 ORDER BY id DESC LIMIT 4;
  $CLI SELECT "id,name,salary,division" FROM employee WHERE "id BETWEEN 4 AND 9 ORDER BY id DESC LIMIT 4"

  echo SELECT id,name,salary,division FROM employee WHERE id BETWEEN 4 AND 9 ORDER BY name LIMIT 4;
  $CLI SELECT "id,name,salary,division" FROM employee WHERE "id BETWEEN 4 AND 9 ORDER BY name LIMIT 4"

  echo SELECT id,name,salary,division FROM employee WHERE division BETWEEN 22 AND 77 ORDER BY division
  $CLI SELECT "id,name,salary,division" FROM employee WHERE "division BETWEEN 22 AND 77 ORDER BY division"

  echo SELECT id,name,salary,division FROM employee WHERE division BETWEEN 22 AND 77 ORDER BY name LIMIT 4
  $CLI SELECT "id,name,salary,division" FROM employee WHERE "division BETWEEN 22 AND 77 ORDER BY name LIMIT 4"

  echo SELECT id,name,salary,division FROM employee WHERE division BETWEEN 22 AND 77 ORDER BY name DESC LIMIT 4
  $CLI SELECT "id,name,salary,division" FROM employee WHERE "division BETWEEN 22 AND 77 ORDER BY name DESC LIMIT 4"

  echo SELECT "id,name,salary,division" FROM employee WHERE "division = 22 ORDER BY name DESC LIMIT 2"
  $CLI SELECT "id,name,salary,division" FROM employee WHERE "division = 22 ORDER BY name DESC LIMIT 2"
}

function order_by_limit_offset_test() {
    echo "PK O(PK)"
    $CLI SELECT id,name,salary,division FROM employee WHERE id BETWEEN 1 AND 9 ORDER BY id
    echo LIMIT 3
    $CLI SELECT id,name,salary,division FROM employee WHERE "name BETWEEN 'a' AND 'z' ORDER BY id LIMIT 3"
    echo LIMIT 3 OFFSET 1
    $CLI SELECT id,name,salary,division FROM employee WHERE "name BETWEEN 'a' AND 'z' ORDER BY id LIMIT 3 OFFSET 1"

    echo
    echo "PK O(name)"
    $CLI SELECT id,name,salary,division FROM employee WHERE id BETWEEN 1 AND 11 ORDER BY name
    echo LIMIT 3
    $CLI SELECT id,name,salary,division FROM employee WHERE id BETWEEN 1 AND 11 ORDER BY name LIMIT 3
    echo LIMIT 3 OFFSET 1
    $CLI SELECT id,name,salary,division FROM employee WHERE id BETWEEN 1 AND 11 ORDER BY name LIMIT 3 OFFSET 1

    echo
    echo "FK O(FK) - FK=name"
    $CLI SELECT id,name,salary,division FROM employee WHERE "name BETWEEN 'a' AND 'z' ORDER BY name"
    echo LIMIT 3
    $CLI SELECT id,name,salary,division FROM employee WHERE "name BETWEEN 'a' AND 'z' ORDER BY name LIMIT 3"
    echo LIMIT 3 OFFSET 1
    $CLI SELECT id,name,salary,division FROM employee WHERE "name BETWEEN 'a' AND 'z' ORDER BY name LIMIT 3 OFFSET 1"

    echo
    echo "FK O(salary) - FK=name"
    $CLI SELECT id,name,salary,division FROM employee WHERE "name BETWEEN 'a' AND 'z' ORDER BY salary"
    echo LIMIT 3
    $CLI SELECT id,name,salary,division FROM employee WHERE "name BETWEEN 'a' AND 'z' ORDER BY salary LIMIT 3"
    echo LIMIT 3 OFFSET 1
    $CLI SELECT id,name,salary,division FROM employee WHERE "name BETWEEN 'a' AND 'z' ORDER BY salary LIMIT 3 OFFSET 1"
}

function sql_orderby_test() {
  order_by_test
  order_by_limit_offset_test
}

function orderbyer() {
  echo ORDERBYER
  sql_orderby_test
  istore_customer_hobby_order_by_denorm_to_many_lists
}

function select_count_range() {
  $CLI SELECT "COUNT(*)" FROM customer WHERE "hobby BETWEEN b AND s"
}
function select_count_join() {
  $CLI SELECT "COUNT(*)" FROM healthplan,worker WHERE healthplan.id=worker.health AND healthplan.id BETWEEN 2 AND 5
}
function select_count_fk() {
  $CLI SELECT "COUNT(*)" FROM customer WHERE employee = 4
}
function select_counter() {
  select_count_range
  select_count_join
  select_count_fk
}

function sql_in_test_cust_id() {
  echo SELECT \* FROM customer WHERE "id IN (1,2,3,4)"
  $CLI SELECT \* FROM customer WHERE "id IN (1,2,3,4)"
}
function sql_in_test_select() {
  echo SELECT \* FROM customer WHERE "id IN (SELECT id FROM customer WHERE id between 1 AND 3) ORDER BY name"
  $CLI SELECT \* FROM customer WHERE "id IN (SELECT id FROM customer WHERE id between 1 AND 3) ORDER BY name"
}
function sql_in_test_cust_hobby() {
  echo SELECT \* FROM customer WHERE "hobby IN ('yachting', 'painting' , 'violin')" ORDER BY name
  $CLI SELECT \* FROM customer WHERE "hobby IN ('yachting', 'painting' , 'violin') ORDER BY name"
}
function in_test_cust_hobby() {
  sql_in_test_cust_hobby
  $CLI DEL list_index_customer_hobby
  $CLI LPUSH list_index_customer_hobby yachting
  $CLI LPUSH list_index_customer_hobby painting
  $CLI LPUSH list_index_customer_hobby violin
  $CLI LPUSH list_index_customer_hobby choir
  echo SELECT \* FROM customer WHERE "hobby IN (LRANGE list_index_customer_hobby 0 2)" ORDER BY name
  $CLI SELECT \* FROM customer WHERE "hobby IN (LRANGE list_index_customer_hobby 0 2)" ORDER BY name
}

function in_test_join_nonrelational() {
  echo SELECT division.id,division.name,division.location,external.name,external.salary FROM division,external WHERE division.id=external.division AND division.id IN "(44,55,33,11,22)"
  $CLI SELECT "division.id,division.name,division.location,external.name,external.salary" FROM "division,external" WHERE "division.id=external.division AND division.id IN (44,55,33,11,22)"
  $CLI DEL L_IND_div_id
  echo LPUSH L_IND_div_id 22
  $CLI LPUSH L_IND_div_id 22
  echo LPUSH L_IND_div_id 11
  $CLI LPUSH L_IND_div_id 11
  echo LPUSH L_IND_div_id 33
  $CLI LPUSH L_IND_div_id 33
  echo LPUSH L_IND_div_id 55
  $CLI LPUSH L_IND_div_id 55
  echo LPUSH L_IND_div_id 44
  $CLI LPUSH L_IND_div_id 44
  echo SELECT division.id,division.name,division.location,external.name,external.salary FROM division,external WHERE division.id=external.division AND division.id IN "(LRANGE L_IND_div_id 0 -1)"
  $CLI SELECT "division.id,division.name,division.location,external.name,external.salary" FROM "division,external" WHERE "division.id=external.division AND division.id IN (LRANGE L_IND_div_id 0 -1)"
}

function sql_in_tester() {
  sql_in_test_cust_id
  sql_in_test_select
  sql_in_test_cust_hobby
}
function in_tester() {
  echo IN_TESTER
  sql_in_tester
  in_test_cust_id
  in_test_cust_hobby
  in_test_join_nonrelational
}

function joiner() {
  echo "JOINS"
  echo
  join_div_extrnl
  echo
  join_div_wrkr
  echo
  join_div_sub_ext
}

function populate() {
  initer
  inserter
}


function simple_test_btree_table_transition() {
  echo "simple_test_btree_table_transition"
  $CLI DROP TABLE bt_trans
  $CLI CREATE TABLE bt_trans "(id INT, t TEXT)"
  LIM=64
  I=1
  while [ $I -lt $LIM ]; do
    $CLI INSERT INTO bt_trans VALUES "($I,'TEXT_$I')"
    I=$[${I}+1];
  done
  $CLI BTREE bt_trans
  $CLI DESC bt_trans
  echo "press enter to transition"
  read
  $CLI INSERT INTO bt_trans VALUES "($I,'TEXT_$I')"
  I=$[${I}+1];
  $CLI INSERT INTO bt_trans VALUES "($I,'TEXT_$I')"
  I=$[${I}+1];
  $CLI BTREE bt_trans
  $CLI DESC bt_trans
}

function init_UU() {
  $CLI DROP TABLE UU
  $CLI CREATE TABLE UU "(pk INT, fk1 INT)"
}
function insert_UU() {
  $CLI INSERT INTO UU VALUES "(1,2)" "RETURN SIZE"
  $CLI INSERT INTO UU VALUES "(2,3)" "RETURN SIZE"
  $CLI INSERT INTO UU VALUES "(3,4)" "RETURN SIZE"
  $CLI INSERT INTO UU VALUES "(4,5)" "RETURN SIZE"
  $CLI INSERT INTO UU VALUES "(5,6)" "RETURN SIZE"
  $CLI INSERT INTO UU VALUES "(6,7)" "RETURN SIZE"
  $CLI INSERT INTO UU VALUES "(7,8)" "RETURN SIZE"
  $CLI INSERT INTO UU VALUES "(8,9)" "RETURN SIZE"
}
function test_UU() {
  init_UU
  insert_UU
  echo DUMP UU
  $CLI DUMP UU
  $CLI update UU SET pk=11 WHERE pk =2
  $CLI SELECT \* FROM UU  WHERE pk = 11
  $CLI update UU SET fk1=10 WHERE pk = 4
  $CLI SELECT \* FROM UU  WHERE pk =4
  $CLI CREATE INDEX ind_UU_fk1 ON UU "(i)"
  $CLI update UU SET fk1=99 WHERE i = 2;
  $CLI update UU SET fk1=99 WHERE i = 4
  $CLI SELECT \* FROM UU WHERE i = 99
  echo DUMP UU
  $CLI DUMP UU
}

function sql_test() {
  dropper
  works
  scanner
  sql_in_tester
  sql_orderby_test
  select_counter
  sql_create_table_as_tester
  sql_float_tests
  test_UU
  init_test_table
  NUM=$(echo "math.randomseed(os.time()); print (math.random(1000));" | lua)
  # TODO replace w/ ./xdb-gen-benchmark
  #./xdb-benchmark -n $NUM -r $NUM -c 100 -T
}

function works() {
  populate
  selecter
  iselecter
  updater
  iselecter_employee
  deleter
  iselecter
  iupdater_customer
  iselecter_customer
  ideleter_customer
  iselecter_customer_employee
  order_by_test
  joiner
}

function single_join_div_extrnl() {
  init_division
  insert_division
  init_external
  insert_external
  join_div_extrnl
}

function single_join_wrkr_health_rev() {
  init_worker
  insert_worker
  init_healthplan
  insert_healthplan
  $CLI SELECT "healthplan.name,worker.name,worker.salary" FROM "healthplan,worker" WHERE "healthplan.id=worker.health AND healthplan.id BETWEEN 1 AND 5"
}

function single_join_wrkr_health() {
  init_worker
  insert_worker
  init_healthplan
  insert_healthplan
  $CLI SELECT "worker.name,worker.salary,healthplan.name" FROM "worker,healthplan" WHERE "worker.health=healthplan.id AND healthplan.id BETWEEN 1 AND 5"
}

function single_join_sub_wrkr() {
  init_division
  insert_division
  init_worker
  insert_worker
  init_subdivision
  insert_subdivision
}

function scan_external() {
  echo SCANSELECT name,salary FROM external WHERE salary BETWEEN 15000.99 AND 25001.01
  $CLI SCANSELECT "name,salary" FROM external WHERE "salary BETWEEN 15000.99 AND 25001.01"
}
function scan_healthpan() {
   echo SCANSELECT "*" FROM healthplan WHERE name BETWEEN a AND k
   $CLI SCANSELECT "*" FROM healthplan WHERE "name BETWEEN 'a' AND 'k'"
   echo SCANSELECT \* FROM healthplan WHERE "name IN ('none','general','foreign')"
   $CLI SCANSELECT \* FROM healthplan WHERE "name IN ('none','general','foreign')"
   echo SCANSELECT \* FROM healthplan WHERE "name=kaiser"
   $CLI SCANSELECT \* FROM healthplan WHERE "name='kaiser'"
   echo SCANSELECT \* FROM healthplan WHERE "name IN ('none')"
   $CLI SCANSELECT \* FROM healthplan WHERE "name IN ('none')"
}

function scan_customer() {
  echo SCANSELECT \* FROM customer ORDER BY hobby
  $CLI SCANSELECT \* FROM customer ORDER BY hobby
  echo SCANSELECT \* FROM customer WHERE "name IN ('bethany','gregory','jennifer') ORDER BY hobby"
  $CLI SCANSELECT \* FROM customer WHERE "name IN ('bethany','gregory','jennifer') ORDER BY hobby"
  echo SCANSELECT \* FROM customer WHERE "name BETWEEN a AND z ORDER BY hobby DESC"
  $CLI SCANSELECT \* FROM customer WHERE "name BETWEEN 'a' AND 'z' ORDER BY hobby DESC"
}

function scanner() {
  echo SCANNER
  scan_customer
  scan_external
  scan_healthpan
}

function init_x3() {
  $CLI DROP TABLE X3
  $CLI CREATE TABLE X3  "(id int, f float, t text, i int)";
}
function insert_x3() {
  $CLI INSERT INTO X3 VALUES "(1,1.11,'text1',33)";
  $CLI INSERT INTO X3 VALUES "(2,2.22,'text2',22)";
  $CLI INSERT INTO X3 VALUES "(3,3.33,'text3',11)"
}
function scan_x3() {
  echo SCANSELECT \* FROM X3 WHERE i BETWEEN 11 AND 33
  $CLI SCANSELECT \* FROM X3 WHERE i BETWEEN 11 AND 33
  echo SCANSELECT \* FROM X3 WHERE i BETWEEN 12 AND 33
  $CLI SCANSELECT \* FROM X3 WHERE i BETWEEN 12 AND 33
  echo SCANSELECT \* FROM X3 WHERE i BETWEEN 12 AND 32
  $CLI SCANSELECT \* FROM X3 WHERE i BETWEEN 12 AND 32
  echo SCANSELECT \* FROM X3 WHERE f BETWEEN 1.1 AND 3.33
  $CLI SCANSELECT \* FROM X3 WHERE f BETWEEN 1.1 AND 3.33
  echo SCANSELECT \* FROM X3 WHERE f BETWEEN 1.2 AND 3.2
  $CLI SCANSELECT \* FROM X3 WHERE f BETWEEN 1.2 AND 3.2
  echo SCANSELECT \* FROM X3 WHERE f BETWEEN 1.2 AND 3.1
  $CLI SCANSELECT \* FROM X3 WHERE f BETWEEN 1.2 AND 3.1

  echo
  echo SCANSELECT \* FROM X3 ORDER BY f DESC
  $CLI SCANSELECT \* FROM X3 ORDER BY f DESC
  echo SCANSELECT \* FROM X3 ORDER BY f DESC LIMIT 2
  $CLI SCANSELECT \* FROM X3 ORDER BY f DESC LIMIT 2
  echo SCANSELECT \* FROM X3 ORDER BY f DESC LIMIT 2 OFFSET 1
  $CLI SCANSELECT \* FROM X3 ORDER BY f DESC LIMIT 2 OFFSET 1
  echo SCANSELECT \* FROM X3 ORDER BY f DESC LIMIT 2 OFFSET 2
  $CLI SCANSELECT \* FROM X3 ORDER BY f DESC LIMIT 2 OFFSET 2

  echo SCANSELECT "COUNT(*)" FROM X3
  $CLI SCANSELECT "COUNT(*)" FROM X3
  echo DELETE FROM X3 WHERE id BETWEEN 1 AND 3 ORDER BY f DESC LIMIT 1
  $CLI DELETE FROM X3 WHERE id BETWEEN 1 AND 3 ORDER BY f DESC LIMIT 1
  echo SCANSELECT "COUNT(*)" FROM X3
  $CLI SCANSELECT "COUNT(*)" FROM X3
  echo DUMP X3
  $CLI DUMP X3
  echo UPDATE X3 SET t = "XXXXXXXXXXX" WHERE id BETWEEN 1 AND 3 ORDER BY f DESC LIMIT 1
  $CLI UPDATE X3 SET "t = 'XXXXXXXXXXX'" WHERE id BETWEEN 1 AND 3 ORDER BY f DESC LIMIT 1
  echo DUMP X3
  $CLI DUMP X3
}

function test_x3() {
  init_x3
  insert_x3
  scan_x3
}

function init_x4() {
  $CLI DROP   TABLE X4
  $CLI CREATE TABLE X4 "(id int, f float, t text)";
  $CLI CREATE INDEX X4:f:index ON X4 "(f)"
}
function insert_x4() {
  $CLI INSERT INTO X4 VALUES "(1,1.11,'text1')";
  $CLI INSERT INTO X4 VALUES "(2,2.22,'text2')";
  $CLI INSERT INTO X4 VALUES "(3,3.33,'text3')"
  $CLI INSERT INTO X4 VALUES "(4,4.44,'text4')"
  $CLI INSERT INTO X4 VALUES "(5,5.55,'text5')"
  $CLI INSERT INTO X4 VALUES "(6,6.66,'text6')"
  $CLI INSERT INTO X4 VALUES "(7,7.77,'text7')"
  $CLI INSERT INTO X4 VALUES "(15,5.55,'text15')"
  $CLI INSERT INTO X4 VALUES "(16,6.66,'text16')"
  $CLI INSERT INTO X4 VALUES "(17,7.77,'text17')"
  $CLI INSERT INTO X4 VALUES "(25,5.55,'text25')"
  $CLI INSERT INTO X4 VALUES "(26,6.66,'text26')"
  $CLI INSERT INTO X4 VALUES "(27,7.77,'text27')"
  $CLI INSERT INTO X4 VALUES "(35,5.55,'text35')"
  $CLI INSERT INTO X4 VALUES "(36,6.66,'text36')"
  $CLI INSERT INTO X4 VALUES "(37,7.77,'text37')"
}
function select_x4() {
  echo SELECT \* FROM X4 WHERE id BETWEEN 2 AND 5
  $CLI SELECT \* FROM X4 WHERE id BETWEEN 2 AND 5
  echo SELECT \* FROM X4 WHERE f BETWEEN 2 AND 5
  $CLI SELECT \* FROM X4 WHERE f BETWEEN 2 AND 5
  echo SELECT \* FROM X4 WHERE f BETWEEN 2 AND 5 ORDER BY f DESC
  $CLI SELECT \* FROM X4 WHERE f BETWEEN 2 AND 5 ORDER BY f DESC
  echo SELECT \* FROM X4 WHERE f = 5.550000191
  $CLI SELECT \* FROM X4 WHERE f = 5.550000191
  echo SELECT \* FROM X4 WHERE f = 5.550000191 order by t LIMIT 2 OFFSET 1
  $CLI SELECT \* FROM X4 WHERE f = 5.550000191 order by t LIMIT 2 OFFSET 1
}

function test_x4() {
  init_x4
  insert_x4
  select_x4
}

function init_x5() {
  $CLI DROP   TABLE X5
  $CLI CREATE TABLE X5  "(id float, t text, i int)";
}
function insert_x5() {
  $CLI INSERT INTO X5 VALUES "(1.11,'text1',33)";
  $CLI INSERT INTO X5 VALUES "(2.22,'text2',22)";
  $CLI INSERT INTO X5 VALUES "(3.33,'text3',11)"
}
function update_x5() {
  $CLI DUMP X5
  echo UPDATE X5 SET id=4.4 WHERE id = 2.2200000286102295
  $CLI UPDATE X5 SET id=4.4 WHERE id = 2.2200000286102295
  echo UPDATE X5 SET "id= id ^ 4.4" WHERE id = 4.400000095
  $CLI UPDATE X5 SET "id= id ^ 4.4" WHERE id = 4.400000095
  $CLI DUMP X5
}
function test_x5() {
  init_x5
  insert_x5
  update_x5
}

function sql_float_tests() {
  $CLI DROP TABLE X3
  $CLI DROP TABLE X4
  $CLI DROP TABLE X5
  test_x3
  test_x4
  test_x5
}
function float_tests() {
  sql_float_tests
}


function create_table_as_select_customer() {
  $CLI DROP TABLE copy
  echo CREATE TABLE copy SELECT id,hobby,name,employee FROM customer WHERE hobby BETWEEN a AND z
  $CLI CREATE TABLE copy "SELECT id,hobby,name,employee FROM customer WHERE hobby BETWEEN 'a' AND 'z'"
  $CLI DESC copy
  $CLI DUMP copy
}

function create_table_as_select_join_worker_health() {
  echo CREATE TABLE worker_health SELECT worker.id,worker.name,worker.salary,healthplan.name FROM worker,healthplan WHERE worker.health = healthplan.id AND healthplan.id BETWEEN 1 AND 5
  $CLI CREATE TABLE worker_health "SELECT worker.id,worker.name,worker.salary,healthplan.name FROM worker,healthplan WHERE worker.health = healthplan.id AND healthplan.id BETWEEN 1 AND 5"
  $CLI DESC worker_health
  $CLI DUMP worker_health
}

# PROTOCOL PROTOCOL PROTOCOL PROTOCOL PROTOCOL PROTOCOL PROTOCOL
# PROTOCOL PROTOCOL PROTOCOL PROTOCOL PROTOCOL PROTOCOL PROTOCOL
function protocol_example_sql() {
  $CLI CREATE TABLE foo "(id INT, val FLOAT, name TEXT)"
  $CLI CREATE INDEX foo_val_index ON foo "(val)"
  $CLI INSERT INTO foo VALUES "(1,1.1111111,'one')"
  $CLI INSERT INTO foo VALUES "(2,2.2222222,'two')"
  $CLI SELECT "*" FROM foo WHERE "id = 1"
  $CLI SCANSELECT "*" FROM foo
  $CLI UPDATE foo SET val=9.999999 WHERE "id = 1"
  $CLI DELETE FROM foo WHERE "id = 2"
  $CLI DROP INDEX foo_val_index
  $CLI DESC foo
  $CLI DUMP foo
}
alias TCPDUMP_ALCHEMY="sudo tcpdump -l -q -A -s 1500 -i lo 'tcp port 6379'"
alias WATCH_SERVER_MEM=" while true; do ps avx|grep xdb-server |grep -v grep| while read a b c d e f g h i; do echo \$h; done; sleep 1; done"



function init_test_table() {
  $CLI CREATE TABLE test "(id int primary key, field TEXT, name TEXT)"
}


function sql_create_table_as_tester() {
  create_table_as_select_customer
  create_table_as_select_join_worker_health
}

function create_table_as_tester() {
  echo CREATE_TABLE_SELECT
  sql_create_table_as_tester
}

function basic_tests() {
  works
  scanner

  create_table_as_tester
}

function all_tests() {
  $CLI FLUSHALL
  works
  dropper

  pk_string_join_tests
  pk_float_join_tests

  float_tests
  populate
  $CLI DEBUG RELOAD

  scanner
  in_tester
  orderbyer
  select_counter

  create_table_as_tester

  mci_test
  second_mci_test
  dmci_test

  #selfjoin
  #many_selfjoin

  test_UU
  pk_tester
  int_limit_test
  long_limit_test
  test_LU
  test_UL

  test_uniq_UL && test_uniq_LU && test_uniq_LL

  mci_full_delete
  dmci_full_delete

  test_cols3
  test_AA_backdoor
  test_update_overwrite
  test_partial
  test_alter
  test_lru
  test_replace
  test_insert_output
  test_iup
  fk_trigger_count_test
  $CLI DEBUG RELOAD
}
function all_tests_plus_benchmarks() {
  all_tests
  test_other_bt_mem_usage
  test_ALL_OTHER_index
  #./Benchmark_Range_Query_Lengths.sh
  #./Benchmark_Range_Query_Lengths.sh JOIN
  #./Benchmark_Range_Query_Lengths.sh 3WAY
  #./Benchmark_Range_Query_Lengths.sh 10WAY
}

# UNIT_TESTS UNIT_TESTS UNIT_TESTS UNIT_TESTS UNIT_TESTS UNIT_TESTS UNIT_TESTS
# UNIT_TESTS UNIT_TESTS UNIT_TESTS UNIT_TESTS UNIT_TESTS UNIT_TESTS UNIT_TESTS
function init_ints_table() {
  $CLI CREATE TABLE ints "(id int primary key, x TEXT, a int, y TEXT, b int, z TEXT, c int)"
}
function insert_ints() {
  $CLI INSERT INTO ints VALUES "(1,A,1,B,256,C,35000)"
  $CLI INSERT INTO ints VALUES "(2,D,2,E,500,F,600000000)"
  $CLI INSERT INTO ints VALUES "(40000,G,3,H,3,I,3)"
  $CLI INSERT INTO ints VALUES "(40001,J,3,K,3,L,3)"
  $CLI INSERT INTO ints VALUES "(300000000,M,3,N,3,O,3)"
}

function populate_join_fk_test() {
  $CLI CREATE TABLE master     "(id INT, val TEXT)"

  $CLI CREATE TABLE reference1 "(id INT, master_id INT, val TEXT)"
  $CLI CREATE INDEX reference1:master_id:index ON reference1 "(master_id)"

  $CLI CREATE TABLE reference2 "(id INT, master_id INT, val TEXT)"
  $CLI CREATE INDEX reference2:master_id:index ON reference2 "(master_id)"

  $CLI INSERT INTO master VALUES "(1,'MASTER_ONE')"
  $CLI INSERT INTO master VALUES "(2,'MASTER_TWO')"
  $CLI INSERT INTO master VALUES "(3,'MASTER_THREE')"

  $CLI INSERT INTO reference1 VALUES "(1,1,'R1_M_ONE_CHILD_ONE')"
  $CLI INSERT INTO reference1 VALUES "(2,1,'R1_M_ONE_CHILD_TWO')"
  $CLI INSERT INTO reference1 VALUES "(3,1,'R1_M_ONE_CHILD_THREE')"
  $CLI INSERT INTO reference1 VALUES "(4,2,'R1_M_TWO_CHILD_ONE')"
  $CLI INSERT INTO reference1 VALUES "(5,2,'R1_M_TWO_CHILD_TWO')"
  $CLI INSERT INTO reference1 VALUES "(6,2,'R1_M_TWO_CHILD_THREE')"
  $CLI INSERT INTO reference1 VALUES "(7,3,'R1_M_THREE_CHILD_ONE')"
  $CLI INSERT INTO reference1 VALUES "(8,3,'R1_M_THREE_CHILD_TWO')"
  $CLI INSERT INTO reference1 VALUES "(9,3,'R1_M_THREE_CHILD_THREE')"

  $CLI INSERT INTO reference2 VALUES "(1,1,'R2_M_ONE_CHILD_ONE')"
  $CLI INSERT INTO reference2 VALUES "(2,1,'R2_M_ONE_CHILD_TWO')"
  $CLI INSERT INTO reference2 VALUES "(3,1,'R2_M_ONE_CHILD_THREE')"
  $CLI INSERT INTO reference2 VALUES "(4,2,'R2_M_TWO_CHILD_ONE')"
  $CLI INSERT INTO reference2 VALUES "(5,2,'R2_M_TWO_CHILD_TWO')"
  $CLI INSERT INTO reference2 VALUES "(6,2,'R2_M_TWO_CHILD_THREE')"
  $CLI INSERT INTO reference2 VALUES "(7,3,'R2_M_THREE_CHILD_ONE')"
  $CLI INSERT INTO reference2 VALUES "(8,3,'R2_M_THREE_CHILD_TWO')"
  $CLI INSERT INTO reference2 VALUES "(9,3,'R2_M_THREE_CHILD_THREE')"

  echo SELECT reference1.val, reference2.val FROM reference1, reference2 WHERE reference1.master_id = reference2.master_id AND reference1.master_id BETWEEN 1 AND 3
  $CLI SELECT "reference1.val, reference2.val" FROM "reference1, reference2" WHERE "reference1.master_id = reference2.master_id AND reference1.master_id BETWEEN 1 AND 3"
}

function index_size_test() {
  $CLI CREATE TABLE istest "(id INT, fk1 INT, fk2 INT, val TEXT)"
  $CLI CREATE INDEX istest:fk1:index ON istest "(fk1)"
  $CLI CREATE INDEX istest:fk2:index ON istest "(fk2)"
  $CLI desc istest
  $CLI INSERT INTO istest VALUES "(1,101,201,'ONE')"
  $CLI desc istest
  $CLI INSERT INTO istest VALUES "(2,102,202,'TWO')"
  $CLI desc istest
  $CLI INSERT INTO istest VALUES "(3,103,203,'THREE')"
  $CLI desc istest
  $CLI INSERT INTO istest VALUES "(4,104,204,'FOUR')" 
  $CLI desc istest
  $CLI INSERT INTO istest VALUES "(5,104,204,'FIVE')" 
  $CLI desc istest
  $CLI INSERT INTO istest VALUES "(6,104,204,'SIX')" 
  $CLI desc istest
  $CLI INSERT INTO istest VALUES "(7,104,204,'SEBN')" 
  $CLI desc istest
  $CLI INSERT INTO istest VALUES "(8,104,204,'ATE')" 
  $CLI desc istest
}

function int_pk_tester() {
  $CLI DROP   TABLE pktest
  $CLI CREATE TABLE pktest "(id INT, val TEXT)"
  $CLI INSERT INTO pktest VALUES "(1,'1')"
  $CLI INSERT INTO pktest VALUES "(200,'200')"
  $CLI INSERT INTO pktest VALUES "(536870911,'536870911')"
  $CLI INSERT INTO pktest VALUES "(536870914,'536870914')"
  $CLI INSERT INTO pktest VALUES "(4294967295,'4294967295')"
  $CLI INSERT INTO pktest VALUES "(4294967298,'4294967298')"
  $CLI INSERT INTO pktest VALUES "(2,'2')"
  $CLI INSERT INTO pktest VALUES "(2147483648,'2147483648')"
  $CLI INSERT INTO pktest VALUES "(2147483647,'2147483647')"
  $CLI INSERT INTO pktest VALUES "(-5,'2147483647')"
}
function text_pk_tester() {
  $CLI DROP   TABLE pktest_string
  $CLI CREATE TABLE pktest_string "(id TEXT, val TEXT)"
  $CLI INSERT INTO pktest_string VALUES "('1','1')"
  $CLI INSERT INTO pktest_string VALUES "('21','21')"
  echo PK LEN 252
  $CLI INSERT INTO pktest_string VALUES "('.sXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXs.','sXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXs')"
  echo PK LEN 260
  $CLI INSERT INTO pktest_string VALUES "('.USHRTXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXUSHRT.','USHRTXXXXXXAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXUSHRT')"
  echo PK LEN 401
    $CLI INSERT INTO pktest_string VALUES "('.USHRTXXXXXXAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXUSHRT.','USHRTXXXXXXAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXUSHRT')"
}
function pk_tester() {
  int_pk_tester
  text_pk_tester
}

alias FREE_LINUX_BUFFS="sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches"
alias ALL_TESTS_LOOP="while true; do all_tests; done > /dev/null"
alias BAD_TESTS_LOOP="while true; do all_tests; done > /dev/null"

alias RECONF="$CLI CONFIG ADD LUA test/alchemy.lua"

# STRING_PK STRING_PK STRING_PK STRING_PK STRING_PK STRING_PK STRING_PK
function init_string_pk_one() {
  $CLI CREATE TABLE s_one "(id TEXT, val TEXT)"
}
function init_string_pk_two() {
  $CLI CREATE TABLE s_two "(id TEXT, val TEXT)"
}
function init_string_pk_three() {
  $CLI CREATE TABLE s_three "(id TEXT, val TEXT)"
}

function insert_string_pk_one() {
  $CLI INSERT INTO s_one VALUES "('1','1_1')"
  $CLI INSERT INTO s_one VALUES "('2','1_2')"
  $CLI INSERT INTO s_one VALUES "('3','1_3')"
  $CLI INSERT INTO s_one VALUES "('4','1_4')"
  $CLI INSERT INTO s_one VALUES "('5','1_5')"
  $CLI INSERT INTO s_one VALUES "('6','1_6')"
  $CLI INSERT INTO s_one VALUES "('7','1_7')"
  $CLI INSERT INTO s_one VALUES "('8','1_8')"
  $CLI INSERT INTO s_one VALUES "('9','1_9')"
}
function insert_string_pk_two() {
  $CLI INSERT INTO s_two VALUES "('1','2_1')"
  $CLI INSERT INTO s_two VALUES "('3','2_3')"
  $CLI INSERT INTO s_two VALUES "('5','2_5')"
  $CLI INSERT INTO s_two VALUES "('7','2_7')"
  $CLI INSERT INTO s_two VALUES "('9','2_9')"
}
function insert_string_pk_three() {
  $CLI INSERT INTO s_three VALUES "('2','3_2')"
  $CLI INSERT INTO s_three VALUES "('4','3_4')"
  $CLI INSERT INTO s_three VALUES "('6','3_6')"
  $CLI INSERT INTO s_three VALUES "('8','3_8')"
}

function pk_string_join_tests() {
  $CLI DROP TABLE s_one
  $CLI DROP TABLE s_two
  $CLI DROP TABLE s_three
  init_string_pk_one
  init_string_pk_two
  init_string_pk_three
  insert_string_pk_one
  insert_string_pk_two
  insert_string_pk_three

  echo $CLI SELECT s_one.val,s_two.val FROM s_one,s_two WHERE s_one.id = s_two.id AND s_one.id BETWEEN 1 AND 9
  $CLI SELECT "s_one.val,s_two.val" FROM "s_one,s_two" WHERE "s_one.id = s_two.id AND s_one.id BETWEEN '1' AND '9'"

  echo $CLI SELECT s_one.val,s_two.val FROM s_one,s_two WHERE s_one.id = s_two.id AND s_one.id IN "(1,2,3,4,5,6,7,8,9)"
  $CLI SELECT "s_one.val,s_two.val" FROM "s_one,s_two" WHERE "s_one.id = s_two.id AND s_one.id IN ('1','2','3','4','5','6','7','8','9')"

  echo $CLI SELECT s_one.val,s_three.val FROM s_one,s_three WHERE s_one.id = s_three.id AND s_one.id BETWEEN 1 AND 9
  $CLI SELECT s_one.val,s_three.val FROM "s_one,s_three" WHERE "s_one.id = s_three.id AND s_one.id BETWEEN '1' AND '9'"

  echo $CLI SELECT s_one.val,s_three.val FROM s_one,s_three WHERE s_one.id = s_three.id AND s_one.id  IN "(1,2,3,4,5,6,7,8,9)"
  $CLI SELECT s_one.val,s_three.val FROM "s_one,s_three" WHERE "s_one.id = s_three.id AND s_one.id  IN ('1','2','3','4','5','6','7','8','9')"
}

# FLOAT_PK FLOAT_PK FLOAT_PK FLOAT_PK FLOAT_PK FLOAT_PK FLOAT_PK FLOAT_PK
function init_float_pk_one() {
  $CLI CREATE TABLE f_one "(id FLOAT, val TEXT)"
}
function init_float_pk_two() {
  $CLI CREATE TABLE f_two "(id FLOAT, val TEXT)"
}
function init_float_pk_three() {
  $CLI CREATE TABLE f_three "(id FLOAT, val TEXT)"
}
function insert_float_pk_one() {
  $CLI INSERT INTO f_one VALUES "(1.1,'1_1')"
  $CLI INSERT INTO f_one VALUES "(2.2,'1_2')"
  $CLI INSERT INTO f_one VALUES "(3.3,'1_3')"
  $CLI INSERT INTO f_one VALUES "(4.4,'1_4')"
  $CLI INSERT INTO f_one VALUES "(5.5,'1_5')"
  $CLI INSERT INTO f_one VALUES "(6.6,'1_6')"
  $CLI INSERT INTO f_one VALUES "(7.7,'1_7')"
  $CLI INSERT INTO f_one VALUES "(8.8,'1_8')"
  $CLI INSERT INTO f_one VALUES "(9.9,'1_9')"
}
function insert_float_pk_two() {
  $CLI INSERT INTO f_two VALUES "(1.1,'2_1')"
  $CLI INSERT INTO f_two VALUES "(3.3,'2_3')"
  $CLI INSERT INTO f_two VALUES "(5.5,'2_5')"
  $CLI INSERT INTO f_two VALUES "(7.7,'2_7')"
  $CLI INSERT INTO f_two VALUES "(9.9,'2_9')"
}
function insert_float_pk_three() {
  $CLI INSERT INTO f_three VALUES "(2.2,'3_2')"
  $CLI INSERT INTO f_three VALUES "(4.4,'3_4')"
  $CLI INSERT INTO f_three VALUES "(6.6,'3_6')"
  $CLI INSERT INTO f_three VALUES "(8.8,'3_8')"
}

function pk_float_join_tests() {
  $CLI DROP TABLE f_one
  $CLI DROP TABLE f_two
  $CLI DROP TABLE f_three
  init_float_pk_one
  init_float_pk_two
  init_float_pk_three
  insert_float_pk_one
  insert_float_pk_two
  insert_float_pk_three
  echo $CLI SELECT f_one.val,f_two.val FROM f_one,f_two WHERE f_one.id = f_two.id AND f_one.id BETWEEN 1 AND 10 
  $CLI SELECT "f_one.val,f_two.val" FROM "f_one,f_two" WHERE "f_one.id = f_two.id AND f_one.id BETWEEN 1 AND 10"

  echo $CLI SELECT f_one.val,f_two.val FROM f_one,f_two WHERE f_one.id = f_two.id AND f_one.id IN "(1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8,9.9)"
  $CLI SELECT "f_one.val,f_two.val" FROM "f_one,f_two" WHERE "f_one.id = f_two.id AND f_one.id IN (1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8,9.9)"

  echo $CLI SELECT f_one.val,f_three.val FROM f_one,f_three WHERE f_one.id = f_three.id AND f_one.id BETWEEN 1 AND 10 
  $CLI SELECT f_one.val,f_three.val FROM "f_one,f_three" WHERE "f_one.id = f_three.id AND f_one.id BETWEEN 1 AND 10"

  echo $CLI SELECT f_one.val,f_three.val FROM f_one,f_three WHERE f_one.id = f_three.id AND f_one.id  IN "(1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8,9.9)"
  $CLI SELECT f_one.val,f_three.val FROM "f_one,f_three" WHERE "f_one.id = f_three.id AND f_one.id  IN (1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8,9.9)"
}

# HELPERS HELPERS HELPERS HELPERS HELPERS HELPERS HELPERS HELPERS HELPERS
# HELPERS HELPERS HELPERS HELPERS HELPERS HELPERS HELPERS HELPERS HELPERS
function wait_on_proc_net_tcp() {
  MIN=$1
  SLEEP_TIME=2
  PROC_TCP=99999
  while [ $PROC_TCP -gt $MIN ]; do
    PROC_TCP=$(wc -l /proc/net/tcp | cut -f 1 -d \ )
    if [ $PROC_TCP -lt $MIN ]; then
        break;
    fi
    echo $0: sleep $SLEEP_TIME - PROC_TCP=$PROC_TCP
    sleep $SLEEP_TIME
  done
}

function looping_sql_test() {
  while true; do
    $CLI flushall;
    sql_test;
    wait_on_proc_net_tcp 10000
  done
}

function large_update() {
  if [ -z "$4" ]; then
    echo "Usage: large_update statement limit variable sleep_throttle"
    return;
  fi
  STMT="$1"
  LIMIT="$2"
  VAR="$3"
  THRTL="$4"

  MOD_STMT="$STMT LIMIT $LIMIT OFFSET $VAR"
  time (
    while true; do
      RES=$(taskset -c 1 $CLI $MOD_STMT | cut -f 2 -d \ )
      if [ "$RES" != "$LIMIT" ]; then echo "BREAK"; break; fi
      sleep $THRTL
    done
  )
}

function lots_of_cols_test () {
  $CLI CREATE TABLE cols "(id INT,col_0 INT, col_1 INT, col_2 INT, col_3 INT, col_4 INT, col_5 INT, col_6 INT, col_7 INT, col_8 INT, col_9 INT, col_10 INT, col_11 INT, col_12 INT, col_13 INT, col_14 INT, col_15 INT, col_16 INT, col_17 INT, col_18 INT, col_19 INT, col_20 INT, col_21 INT, col_22 INT, col_23 INT, col_24 INT, col_25 INT, col_26 INT, col_27 INT, col_28 INT, col_29 INT, col_30 INT, col_31 INT, col_32 INT, col_33 INT, col_34 INT, col_35 INT, col_36 INT, col_37 INT, col_38 INT, col_39 INT, col_40 INT, col_41 INT, col_42 INT, col_43 INT, col_44 INT, col_45 INT, col_46 INT, col_47 INT, col_48 INT, col_49 INT, col_50 INT, col_51 INT, col_52 INT, col_53 INT, col_54 INT, col_55 INT, col_56 INT, col_57 INT, col_58 INT, col_59 INT, col_60 INT, col_61 INT, col_62 INT)"
  time taskset -c 1 ./gen-benchmark -q -c $C -n $REQ -s 1 -A OK -Q INSERT INTO cols VALUES "(00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001)"
}

function run_lua_tests() {
  (cd test;
    for a in $(ls TEST*.lua); do
        time taskset -c 1 luajit $a
    done
  )
}

function multiple_column_orderby_init() {
  $CLI DROP   TABLE obycol
  $CLI CREATE TABLE obycol "(id INT, i INT, j INT, k INT, l LONG, m INT, s TEXT)"
}
function multiple_column_orderby_insert() {
  $CLI INSERT INTO obycol VALUES "(1,1,1,2,4,1,'ONE')"   "RETURN SIZE"
  $CLI INSERT INTO obycol VALUES "(2,1,1,2,4,3,'TWO')"   "RETURN SIZE"
  $CLI INSERT INTO obycol VALUES "(3,1,2,2,3,5,'THREE')" "RETURN SIZE"
  $CLI INSERT INTO obycol VALUES "(4,1,2,2,3,7,'FOUR')"  "RETURN SIZE"
  $CLI INSERT INTO obycol VALUES "(5,2,3,2,2,9,'FIVE')"  "RETURN SIZE"
  $CLI INSERT INTO obycol VALUES "(6,2,3,1,2,2,'SIX')"   "RETURN SIZE"
  $CLI INSERT INTO obycol VALUES "(7,2,4,1,1,4,'SEVEN')" "RETURN SIZE"
  $CLI INSERT INTO obycol VALUES "(8,2,4,1,1,6,'EIGHT')" "RETURN SIZE"
  $CLI INSERT INTO obycol VALUES "(9,2,4,1,1,8,'NINE')"  "RETURN SIZE"
}
function setup_mem_leak() {
  C=200
  REQ=300000
  multiple_column_orderby_init
  multiple_column_orderby_insert
}
function mem_leak_joins() {
  C=200
  REQ=300000
  if [ -n "$1" ]; then
    setup_mem_leak
  fi
  init_test_table
  $CLI INSERT INTO test VALUES "(1,'field','name')"
  echo "JOIN"
  taskset -c 1 $BENCH -c $C -n $REQ -s 1 -A MULTI -Q SELECT "obycol.id, test.name" FROM "obycol, test" WHERE "obycol.id = test.id AND obycol.id = 1"

  (cd test; lua TEST_selfjoin.lua)

  echo SELFJOIN2
  taskset -c 1 $BENCH -c $C -n $REQ -s 1 -A MULTI -Q SELECT "i.name, a.item_id" FROM "item i, word2item a, word2item b, word2item c" WHERE  "a.item_id = i.id  AND a.seller_id = 99 AND b.seller_id = 99 AND c.seller_id = 99 AND a.word_id = 1 AND b.word_id = 2 AND c.word_id = 5 AND a.item_id = b.item_id AND b.item_id = c.item_id AND c.x IN (11,22,33) AND a.x BETWEEN 2 AND 3 AND b.x = 6 AND i.id = 20"
}
function mem_leak_tests() {
  C=200
  REQ=300000
  setup_mem_leak
  amem_pre
  echo "obycol - id=1"
  taskset -c 1 $BENCH -q -c $C -n $REQ -s 1 -A MULTI -Q SELECT \* FROM obycol WHERE "id=1";
  echo "obycol - id BETWEEN 1 AND 10"
  taskset -c 1 $BENCH -q -c $C -n $REQ -s 1 -A MULTI -Q SELECT \* FROM obycol WHERE "id between 1 AND 10";
  echo "obycol - id IN (1,2,3,4,5,6,7,8,9) "
  taskset -c 1 $BENCH -q -c $C -n $REQ -s 1 -A MULTI -Q SELECT \* FROM obycol WHERE "id IN (1,2,3,4,5,6,7,8,9)";
  echo "obycol - id BETWEEN 1 AND 10 ORDER BY k, m DESC LIMIT 4 OFFSET 3"
  taskset -c 1 $BENCH -q -c $C -n $REQ -s 1 -A MULTI -Q SELECT \* FROM obycol WHERE "id BETWEEN 1 AND 10 ORDER BY k, m DESC LIMIT 4 OFFSET 3"; 
  echo "update expression"
  taskset -c 1 $BENCH -q -c $C -n $REQ -s 1 -A INT -Q UPDATE obycol SET "k = k + 1, l = l + 2" WHERE "id = 4"

  mem_leak_joins 1

  mci_setup
  echo MCI
  taskset -c 1 $BENCH -q -c $C -n $REQ -s 1 -A MULTI -Q SELECT \* FROM MCI WHERE "fk4 = 1 AND fk3 = 1 AND fk2 = '1' AND fk1 = 1"

  echo DMCI UNIQUE VIOLATION
  uniq_violation_mem_leak
  amem_post
}


export BENCH=./gen-benchmark
export MANY="taskset -c 1 $BENCH -q -c $C -n $REQ -s 1 -A MULTI -Q"

function insert_nine_into_bt_trans() {
  $CLI CREATE TABLE bt_trans "(id INT, t TEXT)";
  LIM=0;
  ITER=9;
  K=0;
  while [ $K -lt $ITER ]; do
    LIM=$[${LIM}+1];
    $CLI INSERT INTO bt_trans VALUES "($LIM,'TEXT_$LIM')";
     K=$[${K}+1];
  done;
}
function all_delete_cases() {
  $CLI FLUSHALL
  insert_nine_into_bt_trans
  ID=4;$CLI DELETE FROM bt_trans WHERE id = $ID; # 2B
  ID=5;$CLI DELETE FROM bt_trans WHERE id = $ID;
  ID=3;$CLI DELETE FROM bt_trans WHERE id = $ID; # 3B.2
  insert_nine_into_bt_trans
  ID=6;$CLI DELETE FROM bt_trans WHERE id = $ID; # 2A
  ID=7;$CLI DELETE FROM bt_trans WHERE id = $ID; # 3A.1
  ID=5;$CLI DELETE FROM bt_trans WHERE id = $ID; # 3B.1
  insert_nine_into_bt_trans
  ID=4;$CLI DELETE FROM bt_trans WHERE id = $ID;
  ID=5;$CLI DELETE FROM bt_trans WHERE id = $ID;
  ID=6;$CLI DELETE FROM bt_trans WHERE id = $ID; # 2C
  insert_nine_into_bt_trans
  ID=3;$CLI DELETE FROM bt_trans WHERE id = $ID; # 3A.2
}

function amem_pre(){
  MEMA=$(ps avx |grep xdb-server|grep -v grep | while read a b c d e f g h i j k; do echo $h; done)
  MEMA_PRE=$MEMA
}
function amem_post(){
  MEMA=$(ps avx |grep xdb-server|grep -v grep | while read a b c d e f g h i j k; do echo $h; done)
  MEMA_POST=$MEMA
  echo "mem_change: $[${MEMA_POST}-${MEMA_PRE}]  PRE: $MEMA_PRE POST: $MEMA_POST"
}
function init_longcol() {
  $CLI DROP TABLE longcol
  $CLI CREATE TABLE longcol "(id INT, t TEXT, t2 TEXT)"
}
function insert_longcol() {
  echo "1,aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa,x" | wc -m
  $CLI INSERT INTO longcol VALUES "(1,'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa','x')" "RETURN SIZE"
  echo "2,aaaaaaaaaabbbbbbbbbbbbbbbbbcccccccccccccc,y" | wc -m
  $CLI INSERT INTO longcol VALUES "(2,'aaaaaaaaaabbbbbbbbbbbbbbbbbcccccccccccccc','y')" "RETURN SIZE"
  echo "3,aaaaaaaaaabbbbbbbbbbbbbbbbbccccccccccccccddddddddddeeeeeeeeeeeeeee,z" | wc -m
  $CLI INSERT INTO longcol VALUES "(3,'aaaaaaaaaabbbbbbbbbbbbbbbbbccccccccccccccddddddddddeeeeeeeeeeeeeee','z')" "RETURN SIZE"
  echo "4,aaaaaaaaaabbbbbbbbbbbbbbbbbccccccccccccccddddddddddeeeeeeeeeeeeeeeffffffffffffffggggggggggggg,w" | wc -m
  $CLI INSERT INTO longcol VALUES "(4,'aaaaaaaaaabbbbbbbbbbbbbbbbbccccccccccccccddddddddddeeeeeeeeeeeeeeeffffffffffffffggggggggggggg','w')" "RETURN SIZE"
  echo "5,aaaaaaaaaabbbbbbbbbbbbbbbbbccccccccccccccddddddddddeeeeeeeeeeeeeeeffffffffffffffggggggggggggghhhhhhhhhhhhhhiiiiiiiiiii,u" | wc -m
  $CLI INSERT INTO longcol VALUES "(5,'aaaaaaaaaabbbbbbbbbbbbbbbbbccccccccccccccddddddddddeeeeeeeeeeeeeeeffffffffffffffggggggggggggghhhhhhhhhhhhhhiiiiiiiiiii','u')" "RETURN SIZE"
  echo "6,a123456789xyzabcdefghi,x" | wc -m
  $CLI INSERT INTO longcol VALUES "(6,'a123456789xyzabcdefghi','x')" "RETURN SIZE"
  echo "7,ABCDEFGHIJxyzabcdefghi,x" | wc -m
  $CLI INSERT INTO longcol VALUES "(7,'ABCDEFGHIJxyzabcdefghi','x')" "RETURN SIZE"
}


function init_j1() {
  $CLI DROP TABLE j1
  $CLI CREATE TABLE j1 "(pk INT, fk INT, t TEXT)"
  $CLI CREATE INDEX i_j1_fk ON j1 "(fk)"
}
function insert_j1() {
  $CLI INSERT INTO j1 VALUES "(1,1,'ONE')"
  $CLI INSERT INTO j1 VALUES "(2,1,'TWO')"
  $CLI INSERT INTO j1 VALUES "(3,1,'THREE')"
  $CLI INSERT INTO j1 VALUES "(4,2,'FOUR')"
  $CLI INSERT INTO j1 VALUES "(5,2,'FIVE')"
  $CLI INSERT INTO j1 VALUES "(6,2,'SIX')"
  $CLI INSERT INTO j1 VALUES "(7,3,'SEVEN')"
  $CLI INSERT INTO j1 VALUES "(8,3,'EIGHT')"
  $CLI INSERT INTO j1 VALUES "(9,3,'NINE')"
  $CLI INSERT INTO j1 VALUES "(10,4,'TEN')"
  $CLI INSERT INTO j1 VALUES "(11,5,'ASAME')"
  $CLI INSERT INTO j1 VALUES "(12,5,'SAME')"
}
function init_j2() {
  $CLI DROP TABLE j2
  $CLI CREATE TABLE j2 "(pk INT, t TEXT)"
}
function insert_j2() {
  $CLI INSERT INTO j2 VALUES "(1,'one')"
  $CLI INSERT INTO j2 VALUES "(2,'two')"
  $CLI INSERT INTO j2 VALUES "(3,'three')"
  $CLI INSERT INTO j2 VALUES "(5,'five')"
}

function selfjoin() {
  (cd test; lua TEST_selfjoin.lua);
  $CLI SELECT "c.*" FROM "word2item a, word2item b, word2item c" WHERE "a.seller_id = 99 AND b.seller_id = 99 AND c.seller_id = 99 AND a.word_id = 1 AND b.word_id = 2 AND c.word_id = 4 AND a.item_id = b.item_id AND b.item_id = c.item_id"
}
function many_selfjoin() {
  $CLI SELECT i.name, a.item_id FROM "item i, word2item a, word2item b, word2item c" WHERE  "a.item_id = i.id  AND a.seller_id = 99 AND b.seller_id = 99 AND c.seller_id = 99 AND a.word_id = 1 AND b.word_id = 2 AND c.word_id = 4 AND a.item_id = b.item_id AND b.item_id = c.item_id"
  $CLI SELECT i.name, a.item_id FROM "item i, word2item a, word2item b, word2item c" WHERE  "a.item_id = i.id  AND a.seller_id = 99 AND b.seller_id = 99 AND c.seller_id = 99 AND a.word_id = 1 AND b.word_id = 2 AND c.word_id = 5 AND a.item_id = b.item_id AND b.item_id = c.item_id"

  $CLI SELECT "*" FROM "item i, word2item a, word2item b, word2item c" WHERE  "a.item_id = i.id  AND a.seller_id = 99 AND b.seller_id = 99 AND c.seller_id = 99 AND a.word_id = 1 AND b.word_id = 2 AND c.word_id = 5 AND a.item_id = b.item_id AND b.item_id = c.item_id AND a.x = 2 AND b.x = 6 AND c.x = 11"

  $CLI SELECT "*" FROM "item i, word2item a, word2item b, word2item c" WHERE  "a.item_id = i.id  AND a.seller_id = 99 AND b.seller_id = 99 AND c.seller_id = 99 AND a.word_id = 1 AND b.word_id = 2 AND c.word_id = 5 AND a.item_id = b.item_id AND b.item_id = c.item_id AND a.x = 2 AND b.x = 6 AND c.x = 11 AND i.id = 20"
  $CLI SELECT "*" FROM "item i, word2item a, word2item b, word2item c" WHERE  "a.item_id = i.id  AND a.seller_id = 99 AND b.seller_id = 99 AND c.seller_id = 99 AND a.word_id = 1 AND b.word_id = 2 AND c.word_id = 4 AND a.item_id = b.item_id AND b.item_id = c.item_id AND b.x = 5 AND c.x = 9 AND i.id = 10"


  $CLI SELECT "*" FROM "item i, word2item a, word2item b" WHERE  "a.item_id = i.id  AND a.seller_id = 99 AND b.seller_id = 99 AND a.word_id = 1 AND b.word_id = 2 AND a.item_id = b.item_id"
  $CLI SELECT "*" FROM "item i, word2item a, word2item b" WHERE  "a.item_id = i.id  AND a.seller_id = 99 AND b.seller_id = 99 AND a.word_id = 1 AND b.word_id = 5 AND a.item_id = b.item_id"
  $CLI SELECT "*" FROM "item i, word2item a, word2item b" WHERE  "a.item_id = i.id  AND a.seller_id = 99 AND b.seller_id = 99 AND a.word_id = 1 AND b.word_id = 4 AND a.item_id = b.item_id"
  $CLI SELECT "*" FROM "item i, word2item a, word2item b" WHERE  "a.item_id = i.id  AND a.seller_id = 99 AND b.seller_id = 99 AND a.word_id = 3 AND b.word_id = 5 AND a.item_id = b.item_id"


  $CLI SELECT i.name, a.item_id FROM "item i, word2item a, word2item b, word2item c" WHERE  "a.item_id = i.id  AND a.seller_id = 99 AND b.seller_id = 99 AND c.seller_id = 99 AND a.word_id = 1 AND b.word_id = 2 AND c.word_id = 5 AND a.item_id = b.item_id AND b.item_id = c.item_id AND c.x IN (11,22,33) AND a.x BETWEEN 2 AND 3 AND b.x = 6 AND i.id = 20"

  $CLI SCANSELECT "a.word_id, i.name, a.id" FROM "item i, word2item a" WHERE  "a.item_id = i.id AND a.item_id BETWEEN 80 AND 90 ORDER by i.name, a.word_id"

  $CLI SELECT a.word_id, i.name, a.id FROM "item i, word2item a" WHERE  "a.item_id = i.id AND a.id BETWEEN 500 AND 1500 ORDER by i.name, a.word_id DESC"
  $CLI SELECT a.word_id, i.name, a.id FROM "item i, word2item a" WHERE  "a.item_id = i.id AND a.seller_id BETWEEN 55 AND 111 ORDER by i.name, a.word_id DESC"
}

function init_mci() {
  $CLI DROP TABLE MCI
  $CLI CREATE TABLE MCI "(id INT, fk1 INT, fk2 TEXT, fk3 INT, fk4 INT, val TEXT)"
}
function insert_mci() {
  $CLI INSERT INTO MCI VALUES "(1,1,'1',1,1,'ONE')"
  $CLI INSERT INTO MCI VALUES "(2,1,'1',2,1,'TWO')"
  $CLI INSERT INTO MCI VALUES "(3,1,'1',3,1,'THREE')"
  $CLI INSERT INTO MCI VALUES "(4,1,'1',4,1,'FOUR')"
  $CLI INSERT INTO MCI VALUES "(5,1,'1',5,1,'FIVE')"
  $CLI INSERT INTO MCI VALUES "(6,2,'1',1,1,'SIX')"
  $CLI INSERT INTO MCI VALUES "(7,2,'1',2,1,'SEVEN')"
  $CLI INSERT INTO MCI VALUES "(8,2,'1',3,1,'EIGHT')"
  $CLI INSERT INTO MCI VALUES "(9,2,'1',4,1,'NINE')"
  $CLI INSERT INTO MCI VALUES "(10,1,'2',5,1,'TEN')"
  $CLI INSERT INTO MCI VALUES "(11,1,'2',1,1,'ELEVEN')"
  $CLI INSERT INTO MCI VALUES "(12,1,'2',2,1,'TWELVE')"
  $CLI INSERT INTO MCI VALUES "(13,1,'1',3,1,'THIRTEEN')"
  $CLI INSERT INTO MCI VALUES "(14,1,'1',4,1,'FOURTEEN')"
  $CLI INSERT INTO MCI VALUES "(15,1,'1',5,2,'FIFTEEN')"
  $CLI INSERT INTO MCI VALUES "(16,1,'2',1,2,'SIXTEEN')"
}
function add_indexes_to_mci() {
  $CLI CREATE INDEX i_mci_3       ON MCI "(fk3)"
  $CLI CREATE INDEX i_mci_1_2     ON MCI "(fk1, fk2)"
  $CLI CREATE INDEX i_mci_2_3_1   ON MCI "(fk2 ,fk3, fk1)"
  $CLI CREATE INDEX i_mci_4_3_2_1 ON MCI "(fk4,fk3,fk2,fk1)"
}
function mci_setup() {
  init_mci
  insert_mci
  add_indexes_to_mci
}
function mci_select() {
  echo SELECT \* FROM MCI WHERE "fk3 = 1" 
  $CLI SELECT \* FROM MCI WHERE "fk3 = 1" 
  if [ -n "$1" ]; then read; fi
  echo SELECT \* FROM MCI WHERE "fk1 = 1" 
  $CLI SELECT \* FROM MCI WHERE "fk1 = 1" 
  if [ -n "$1" ]; then read; fi
  echo SELECT \* FROM MCI WHERE "fk2 = '2'" 
  $CLI SELECT \* FROM MCI WHERE "fk2 = '2'" 
  if [ -n "$1" ]; then read; fi
  echo SELECT \* FROM MCI WHERE "fk2 = '2' AND fk1 = 1" 
  $CLI SELECT \* FROM MCI WHERE "fk2 = '2' AND fk1 = 1" 
  if [ -n "$1" ]; then read; fi
  echo SELECT \* FROM MCI WHERE "fk2 = '1' AND fk1 = 2" 
  $CLI SELECT \* FROM MCI WHERE "fk2 = '1' AND fk1 = 2" 
  if [ -n "$1" ]; then read; fi
  echo SELECT \* FROM MCI WHERE "fk3 = 1 AND fk2 = '1' AND fk1 = 1" 
  $CLI SELECT \* FROM MCI WHERE "fk3 = 1 AND fk2 = '1' AND fk1 = 1" 
  if [ -n "$1" ]; then read; fi
  echo SELECT \* FROM MCI WHERE "fk4 = 1 AND fk3 = 1 AND fk2 = '1' AND fk1 = 1" 
  $CLI SELECT \* FROM MCI WHERE "fk4 = 1 AND fk3 = 1 AND fk2 = '1' AND fk1 = 1" 
}
function mci_test() {
  mci_setup
  mci_select
}
function mci_explain() {
  mci_setup
  EXPLAIN SELECT \* FROM MCI WHERE "fk3 = 1" 
  if [ -n "$1" ]; then read; fi
  EXPLAIN SELECT \* FROM MCI WHERE "fk1 = 1" 
  if [ -n "$1" ]; then read; fi
  EXPLAIN SELECT \* FROM MCI WHERE "fk2 = '2'" 
  if [ -n "$1" ]; then read; fi
  EXPLAIN SELECT \* FROM MCI WHERE "fk2 = '2' AND fk1 = 1" 
  if [ -n "$1" ]; then read; fi
  EXPLAIN SELECT \* FROM MCI WHERE "fk2 = '1' AND fk1 = 2" 
  if [ -n "$1" ]; then read; fi
  EXPLAIN SELECT \* FROM MCI WHERE "fk3 = 1 AND fk2 = '1' AND fk1 = 1" 
  if [ -n "$1" ]; then read; fi
  EXPLAIN SELECT \* FROM MCI WHERE "fk4 = 1 AND fk3 = 1 AND fk2 = '1' AND fk1 = 1" 
}
function mci_full_delete() {
  mci_test
  $CLI DELETE FROM MCI WHERE fk1 = 1
  $CLI DELETE FROM MCI WHERE fk1 = 2
  $CLI DUMP MCI
}
function init_second_mci() {
  $CLI DROP TABLE SECOND_MCI
  $CLI CREATE TABLE SECOND_MCI "(id INT, fk1 INT, fk2 TEXT, name TEXT)"
}
function add_indexes_to_second_mci() {
  $CLI CREATE INDEX i_smci_2   ON SECOND_MCI "(fk2)"
  $CLI CREATE INDEX i_smci_1_2 ON SECOND_MCI "(fk1, fk2)"
}
function insert_second_mci() {
  $CLI INSERT INTO SECOND_MCI VALUES "(1,1,'1','NAME_ONE')"
  $CLI INSERT INTO SECOND_MCI VALUES "(2,1,'1','NAME_TWO')"
  $CLI INSERT INTO SECOND_MCI VALUES "(3,1,'1','NAME_THREE')"
  $CLI INSERT INTO SECOND_MCI VALUES "(4,2,'1','NAME_FOUR')"
  $CLI INSERT INTO SECOND_MCI VALUES "(5,2,'1','NAME_FIVE')"
  $CLI INSERT INTO SECOND_MCI VALUES "(6,2,'1','NAME_SIX')"
  $CLI INSERT INTO SECOND_MCI VALUES "(7,1,'2','NAME_SEVEN')"
  $CLI INSERT INTO SECOND_MCI VALUES "(8,1,'2','NAME_EIGHT')"
  $CLI INSERT INTO SECOND_MCI VALUES "(9,1,'2','NAME_NINE')"
  $CLI INSERT INTO SECOND_MCI VALUES "(10,2,'2','NAME_TEN')"
  $CLI INSERT INTO SECOND_MCI VALUES "(11,2,'2','NAME_ELEVEN')"
  $CLI INSERT INTO SECOND_MCI VALUES "(12,2,'2','NAME_TWELVE')"
  $CLI INSERT INTO SECOND_MCI VALUES "(13,2,'2','NAME_THIRTEEN')"
  $CLI INSERT INTO SECOND_MCI VALUES "(14,1,'3','NAME_FOURTEEN')"
  $CLI INSERT INTO SECOND_MCI VALUES "(15,1,'3','NAME_FIFTEEN')"
}
function second_mci_setup() {
  init_second_mci
  insert_second_mci
  add_indexes_to_second_mci
}
function mci_joins() {
  echo "(MCI)M->1 S->?"
  echo SELECT \* FROM MCI m, SECOND_MCI s WHERE "m.fk1 = s.fk1 AND m.fk1 = 2 AND m.fk3=3 AND m.fk2 = '1'"
  $CLI SELECT \* FROM MCI m, SECOND_MCI s WHERE "m.fk1 = s.fk1 AND m.fk1 = 2 AND m.fk3=3 AND m.fk2 = '1'"
  if [ -n "$1" ]; then read; fi
  echo "(S)M->3 (MCI)S->4"
  echo SELECT \* FROM MCI m, SECOND_MCI s WHERE "m.fk1 = s.fk1 AND m.fk3=3 AND s.fk1 = 2 AND s.fk2 = '2'"
  $CLI SELECT \* FROM MCI m, SECOND_MCI s WHERE "m.fk1 = s.fk1 AND m.fk3=3 AND s.fk1 = 2 AND s.fk2 = '2'"
  if [ -n "$1" ]; then read; fi
  echo "(MCI)M->4 (MCI)S->3"
  echo SELECT \* FROM MCI m, SECOND_MCI s WHERE "m.fk1 = s.fk1 AND m.fk1 = 1 AND m.fk2 = '2' AND s.fk1 = 1 AND s.fk2 = '1'"
  $CLI SELECT \* FROM MCI m, SECOND_MCI s WHERE "m.fk1 = s.fk1 AND m.fk1 = 1 AND m.fk2 = '2' AND s.fk1 = 1 AND s.fk2 = '1'"
  if [ -n "$1" ]; then read; fi
  echo "(MCI)M->INF (MCI)S->2"
  echo SELECT \* FROM MCI m, SECOND_MCI s WHERE "m.fk1 = s.fk1 AND m.fk1 = 1 AND m.fk3=3 AND s.fk1 = 1 AND s.fk2 = '3'"
  $CLI SELECT \* FROM MCI m, SECOND_MCI s WHERE "m.fk1 = s.fk1 AND m.fk1 = 1 AND m.fk3=3 AND s.fk1 = 1 AND s.fk2 = '3'"
  if [ -n "$1" ]; then read; fi
  echo "(MCI)M->1 (MCI)S->2"
  echo SELECT \* FROM MCI m, SECOND_MCI s WHERE "m.fk1 = s.fk1 AND m.fk1 = 1 AND m.fk2 = '1' AND m.fk3=1 AND s.fk1 = 1 AND s.fk2 = '3'"
  $CLI SELECT \* FROM MCI m, SECOND_MCI s WHERE "m.fk1 = s.fk1 AND m.fk1 = 1 AND m.fk2 = '1' AND m.fk3=1 AND s.fk1 = 1 AND s.fk2 = '3'"
}
function second_mci_test() {
  mci_setup
  second_mci_setup
  mci_joins
}
function mci_join_explain() {
  mci_setup
  second_mci_setup
  echo "(MCI)M->1 S->?"
  echo SELECT \* FROM MCI m, SECOND_MCI s WHERE "m.fk1 = s.fk1 AND m.fk1 = 2 AND m.fk3=3 AND m.fk2 = '1'"
  EXPLAIN SELECT \* FROM "MCI m, SECOND_MCI s" WHERE "m.fk1 = s.fk1 AND m.fk1 = 2 AND m.fk3=3 AND m.fk2 = '1'"
  if [ -n "$1" ]; then read; fi
  echo "(S)M->3 (MCI)S->4"
  echo SELECT \* FROM MCI m, SECOND_MCI s WHERE "m.fk1 = s.fk1 AND m.fk3=3 AND s.fk1 = 2 AND s.fk2 = '2'"
  EXPLAIN SELECT \* FROM "MCI m, SECOND_MCI s" WHERE "m.fk1 = s.fk1 AND m.fk3=3 AND s.fk1 = 2 AND s.fk2 = '2'"
  if [ -n "$1" ]; then read; fi
  echo "(MCI)M->4 (MCI)S->3"
  echo SELECT \* FROM MCI m, SECOND_MCI s WHERE "m.fk1 = s.fk1 AND m.fk1 = 1 AND m.fk2 = '2' AND s.fk1 = 1 AND s.fk2 = '1'"
  EXPLAIN SELECT \* FROM "MCI m, SECOND_MCI s" WHERE "m.fk1 = s.fk1 AND m.fk1 = 1 AND m.fk2 = '2' AND s.fk1 = 1 AND s.fk2 = '1'"
  if [ -n "$1" ]; then read; fi
  echo "(MCI)M->3 (MCI)S->2"
  echo SELECT \* FROM MCI m, SECOND_MCI s WHERE "m.fk1 = s.fk1 AND m.fk1 = 1 AND m.fk3=3 AND s.fk1 = 1 AND s.fk2 = '3'"
  EXPLAIN SELECT \* FROM "MCI m, SECOND_MCI s" WHERE "m.fk1 = s.fk1 AND m.fk1 = 1 AND m.fk3=3 AND s.fk1 = 1 AND s.fk2 = '3'"
  if [ -n "$1" ]; then read; fi
  echo "(MCI)M->1 (MCI)S->2"
  echo SELECT \* FROM MCI m, SECOND_MCI s WHERE "m.fk1 = s.fk1 AND m.fk1 = 1 AND m.fk2 = '1' AND m.fk3=1 AND s.fk1 = 1 AND s.fk2 = '3'"
  EXPLAIN SELECT \* FROM "MCI m, SECOND_MCI s" WHERE "m.fk1 = s.fk1 AND m.fk1 = 1 AND m.fk2 = '1' AND m.fk3=1 AND s.fk1 = 1 AND s.fk2 = '3'"
}

function EXPLAIN() {
  RET=$($CLI EXPLAIN "${1}" "${2}" "${3}" "${4}" "${5}" "${6}")
  echo -ne "${RET}";
  echo
}

function init_dmci() {
  $CLI DROP TABLE DMCI
  $CLI CREATE TABLE DMCI "(id INT, fk1 INT, fk2 INT, fk3 INT, val TEXT)"
}
function insert_dmci() {
  $CLI INSERT INTO DMCI VALUES "(1,1,1,5,'ONE')"
  $CLI INSERT INTO DMCI VALUES "(2,1,1,6,'TWO')"
  $CLI INSERT INTO DMCI VALUES "(3,1,2,5,'THREE')"
  $CLI INSERT INTO DMCI VALUES "(4,1,2,6,'FOUR')"
  $CLI INSERT INTO DMCI VALUES "(5,1,2,7,'FIVE')"
  $CLI INSERT INTO DMCI VALUES "(6,2,1,5,'SIX')"
  $CLI INSERT INTO DMCI VALUES "(7,2,1,6,'SEVEN')"
  $CLI INSERT INTO DMCI VALUES "(8,2,2,5,'EIGHT')"
}
function add_indexes_to_dmci() {
  $CLI CREATE UNIQUE INDEX i_mci_1_2_3 ON DMCI "(fk1,fk2,fk3)"
}
function dmci_setup() {
  init_dmci
  add_indexes_to_dmci
  insert_dmci
}
function dmci_test() {
  dmci_setup
  echo SELECT "*" FROM DMCI WHERE "fk1 = 1 AND fk2 = 1 AND fk3 = 5"
  $CLI SELECT "*" FROM DMCI WHERE "fk1 = 1 AND fk2 = 1 AND fk3 = 5"
  echo SELECT "*" FROM DMCI WHERE "fk1 = 1 AND fk2 = 1"
  $CLI SELECT "*" FROM DMCI WHERE "fk1 = 1 AND fk2 = 1"
  echo SELECT "*" FROM DMCI WHERE "fk1 = 1"
  $CLI SELECT "*" FROM DMCI WHERE "fk1 = 1"
}
function dmci_full_delete() {
  dmci_test
  $CLI DELETE FROM DMCI WHERE fk1 = 1
  $CLI DELETE FROM DMCI WHERE fk1 = 2
  $CLI DUMP DMCI
}
function dmci_build_index_fail_test() {
  init_dmci
  $CLI INSERT INTO DMCI VALUES "(1,1,1,5,'ONE')"
  $CLI INSERT INTO DMCI VALUES "(2,1,1,5,'TWO')"
  add_indexes_to_dmci
  #taskset -c 1 $BENCH -c $C -n $REQ -s 1 -A OK -Q CREATE UNIQUE INDEX i_mci_1_2_3 ON DMCI "(fk1,fk2,fk3)"
}
function uniq_violation_test() {
  dmci_setup
  $CLI INSERT INTO DMCI VALUES "(9,1,1,5,'FAIL')"
  $CLI UPDATE DMCI SET "fk3 = 5" WHERE "fk1 = 1 AND fk2 = 1"
}
function uniq_violation_mem_leak() {
  dmci_setup
  echo VIOLATION UPDATE
  taskset -c 1 $BENCH -c $C -n $REQ -s 1 -A OK -Q UPDATE DMCI SET "fk3 = 5" WHERE "fk1 = 1 AND fk2 = 1"
  echo VIOLATION INSERT
  taskset -c 1 $BENCH -c $C -n $REQ -s 1 -A OK -Q INSERT INTO DMCI VALUES "(9,1,1,5,'FAIL')"
}

function OLD_init_mercadolibre() {
  C=200
  N=10000000
  $CLI DROP   TABLE item_words
  $CLI CREATE TABLE item_words "(id INT, seller_id INT, word_id INT, item_id INT, status INT, ltype INT, bmode INT, labels INT, cat INT)"
  $CLI CREATE UNIQUE INDEX ind_IW_sw2i ON item_words "(seller_id, word_id, item_id)"
  time taskset -c 1 $BENCH -q -c $C -n $N -s 1 -m "1,199999,19999,9,49,49,49,199" -A OK -Q INSERT INTO item_words VALUES "(00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001)"
}
function init_mercadolibre() {
  C=200
  N=10000000
  $CLI DROP   TABLE item_words
  $CLI CREATE TABLE item_words "(id INT, seller_id INT, word_id INT, item_id LONG, status INT, ltype INT, bmode INT, labels INT, cat INT)"
  $CLI CREATE UNIQUE INDEX ind_IW_sw2i ON item_words "(seller_id, word_id, item_id)"
  amem_pre
  time taskset -c 1 $BENCH -q -c $C -n $N -s 1 -m "1,199999,19999,9,49,49,49,199" -A OK -Q INSERT INTO item_words VALUES "(00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001,00000000000001)"
  amem_post
}
function delete_mercadolibre() {
  init_mercadolibre
  C=200
  N=10000000
  R=200000
  OPT=" -r $R "
  echo DELETE item_words word_id=00000000000001 OPT: $OPT
  time taskset -c 1 $BENCH  -c $C -n $N $OPT -A OK -Q DELETE FROM item_words WHERE "word_id=00000000000001 AND seller_id = 1";

  init_mercadolibre
  N=200000
  OPT=" -s 1 "
  echo DELETE item_words word_id=00000000000001 OPT: $OPT
  time taskset -c 1 $BENCH  -c $C -n $N $OPT -A OK -Q DELETE FROM item_words WHERE "word_id=00000000000001 AND seller_id = 1";
}


function test_init_mercadolibre() {
  C=50
  REQ=100000
  echo "Baseline singleFK row MCI lookup"
  taskset -c 1 $BENCH -c $C -n $REQ -s 1 -A MULTI -Q SELECT item_id FROM item_words WHERE "seller_id = 1 AND word_id = 14 AND item_id = 230"
  echo "MCI singleFK Range Query"
  taskset -c 1 $BENCH -c $C -n $REQ -s 1 -A MULTI -Q SELECT item_id FROM item_words WHERE "seller_id = 1 AND word_id = 14"

  echo "2 set intersection"
  taskset -c 1 $BENCH -c $C -n $REQ -s 1 -A MULTI -Q SELECT "b.item_id" FROM "item_words a, item_words b" WHERE "a.seller_id = 1 AND b.seller_id = 1 AND a.word_id = 23 AND b.word_id = 14 AND a.item_id = b.item_id"
  echo "2 set intersection w/ status filter"
  taskset -c 1 $BENCH -c $C -n $REQ -s 1 -A MULTI -Q SELECT "b.item_id" FROM "item_words a, item_words b" WHERE "a.seller_id = 1 AND b.seller_id = 1 AND a.word_id = 23 AND b.word_id = 14 AND a.item_id = b.item_id AND b.status IN (1,7)"
  echo "2 set intersection w/ cat & status filter"
  taskset -c 1 $BENCH -c $C -n $REQ -s 1 -A MULTI -Q SELECT "b.item_id" FROM "item_words a, item_words b" WHERE "a.seller_id = 1 AND b.seller_id = 1 AND a.word_id = 23 AND b.word_id = 14 AND a.item_id = b.item_id AND b.cat IN (7,11,15) AND b.status IN (1,7)"

  echo "3 set intersection"
  taskset -c 1 $BENCH -c $C -n $REQ -s 1 -A MULTI -Q SELECT "c.item_id" FROM "item_words a, item_words b, item_words c" WHERE "a.seller_id = 1 AND b.seller_id = 1 AND c.seller_id = 1 AND a.word_id = 23 AND b.word_id = 14 AND c.word_id = 50 AND a.item_id = b.item_id AND b.item_id = c.item_id"
  echo "3 set intersection w/ cat filter"
  taskset -c 1 $BENCH -c $C -n $REQ -s 1 -A MULTI -Q SELECT "c.item_id" FROM "item_words a, item_words b, item_words c" WHERE "a.seller_id = 1 AND b.seller_id = 1 AND c.seller_id = 1 AND a.word_id = 23 AND b.word_id = 14 AND c.word_id = 50 AND a.item_id = b.item_id AND b.item_id = c.item_id AND c.cat IN (23,27,31)"
  
  echo "3 set intersection w/ cat & status filter"
  taskset -c 1 $BENCH -c $C -n $REQ -s 1 -A MULTI -Q SELECT "c.item_id" FROM "item_words a, item_words b, item_words c" WHERE "a.seller_id = 1 AND b.seller_id = 1 AND c.seller_id = 1 AND a.word_id = 23 AND b.word_id = 14 AND c.word_id = 50 AND a.item_id = b.item_id AND b.item_id = c.item_id AND c.cat IN (23,27,31) AND c.status IN (3,4)"

  echo "5 set intersection w/ cat & status filter"
  taskset -c 1 $BENCH -c $C -n $REQ -s 1 -A MULTI -Q SELECT "c.word_id,c.item_id" FROM "item_words a, item_words b, item_words c, item_words d, item_words e" WHERE "a.seller_id = 1 AND b.seller_id = 1 AND c.seller_id = 1 AND d.seller_id = 1 AND e.seller_id = 1 AND a.word_id = 23 AND b.word_id = 14 AND c.word_id = 50 AND d.word_id = 185 AND e.word_id = 302 AND a.item_id = b.item_id AND b.item_id = c.item_id AND c.item_id = d.item_id AND d.item_id = e.item_id AND e.cat IN (103,119,127,139,155) AND e.status IN (5,6,7,8,9)"
}

function init_longmci() {
  $CLI DROP   TABLE longmci
  $CLI CREATE TABLE longmci "(pk INT, fk1 INT, fk2 INT, fk3 INT, fk4 INT)"
  $CLI CREATE INDEX i_lm ON longmci "(fk1, fk2, fk3, fk4)"
}
function insert_longmci() {
  $CLI INSERT INTO longmci VALUES "(1,1,1,1,1)"
  $CLI INSERT INTO longmci VALUES "(2,1,1,2,2)"
  $CLI INSERT INTO longmci VALUES "(3,1,1,3,3)"
  $CLI INSERT INTO longmci VALUES "(4,1,1,4,4)"
  $CLI INSERT INTO longmci VALUES "(5,1,1,5,1)"
  $CLI INSERT INTO longmci VALUES "(6,1,1,6,2)"
}
function test_longmci() {
  EXPLAIN SELECT \* FROM "longmci a, longmci b, longmci c" WHERE "a.fk1 = b.fk1 AND c.fk1 = b.fk1 AND a.fk1 = 1"
  if [ -n "$1" ]; then read; fi
  EXPLAIN SELECT \* FROM "longmci a, longmci b, longmci c" WHERE "a.fk1 = b.fk1 AND c.fk1 = b.fk1 AND a.fk1 = 1 AND a.fk2 = 1 AND b.fk2 = 1 AND c.fk2 = 1"
  if [ -n "$1" ]; then read; fi
  EXPLAIN SELECT \* FROM "longmci a, longmci b, longmci c" WHERE "a.fk1 = b.fk1 AND c.fk1 = b.fk1 AND a.fk1 = 1 AND a.fk2 = 1 AND a.fk4 = 22 AND b.fk4 = 33 AND c.fk3 = 44"
}

function long_limit_test() {
  $CLI DROP   TABLE longs
  $CLI CREATE TABLE longs "(pk long, fk1 long, fk2 long)"; # 3 cols so not LL
  $CLI INSERT INTO longs VALUES "(1,1,1)"  "RETURN SIZE"
  $CLI INSERT INTO longs VALUES "(128,128,128)"  "RETURN SIZE"
  $CLI INSERT INTO longs VALUES "(16384,16384,16384)"  "RETURN SIZE"
  $CLI INSERT INTO longs VALUES "(536870912,536870912,536870912)"  "RETURN SIZE"
  $CLI INSERT INTO longs VALUES "(17592186044416,17592186044416,17592186044416)"  "RETURN SIZE"
  $CLI INSERT INTO longs VALUES "(576460752303423488,576460752303423488,576460752303423488)"  "RETURN SIZE"
  $CLI INSERT INTO longs VALUES "(18446744073709551615,18446744073709551615,18446744073709551615)"  "RETURN SIZE"
  $CLI INSERT INTO longs VALUES "(18446744073709551617,18446744073709551617,18446744073709551617)"  "RETURN SIZE"
  $CLI INSERT INTO longs VALUES "(11111111111111111111111111111111,11111111111111111111111111111111,11111111111111111111111111111111)"  "RETURN SIZE"
  $CLI DUMP longs
}

function int_limit_test() {
  $CLI DROP   TABLE ints
  $CLI CREATE TABLE ints "(pk INT, fk1 INT, fk2 INT)"; # 3 cols so not UU
  $CLI INSERT INTO ints VALUES "(1,1,1)"  "RETURN SIZE"
  $CLI INSERT INTO ints VALUES "(127,127,127)"  "RETURN SIZE"
  $CLI INSERT INTO ints VALUES "(128,128,128)"  "RETURN SIZE"
  $CLI INSERT INTO ints VALUES "(16383,16383,16383)"  "RETURN SIZE"
  $CLI INSERT INTO ints VALUES "(16384,16384,16384)"  "RETURN SIZE"
  $CLI INSERT INTO ints VALUES "(536870911,536870911,536870911)"  "RETURN SIZE"
  $CLI INSERT INTO ints VALUES "(536870912,536870912,536870912)"  "RETURN SIZE"
  $CLI INSERT INTO ints VALUES "(4294967295,4294967295,4294967295)"  "RETURN SIZE"
  $CLI INSERT INTO ints VALUES "(4294967296,4294967296,4294967296)"  "RETURN SIZE"
  $CLI DUMP ints
}


function init_UL() {
  $CLI DROP   TABLE UL
  $CLI CREATE TABLE UL "(pk INT, fk1 long)";
}
function insert_UL() {
  $CLI INSERT INTO UL VALUES "(1,1)"
  $CLI INSERT INTO UL VALUES "(2,128)"
  $CLI INSERT INTO UL VALUES "(3,16384)"
  $CLI INSERT INTO UL VALUES "(4,536870912)"
  $CLI INSERT INTO UL VALUES "(5,17592186044416)"
  $CLI INSERT INTO UL VALUES "(6,576460752303423488)"
  $CLI INSERT INTO UL VALUES "(7,18446744073709551615)"
}
function test_UL() {
  init_UL
  insert_UL
  $CLI DUMP UL
}

function init_LU() {
  $CLI DROP   TABLE LU
  $CLI CREATE TABLE LU "(pk LONG, fk1 INT)";
}
function insert_LU() {
  $CLI INSERT INTO LU VALUES "(1,                    1)"
  $CLI INSERT INTO LU VALUES "(128,                  2)"
  $CLI INSERT INTO LU VALUES "(16384,                3)"
  $CLI INSERT INTO LU VALUES "(536870912,            4)"
  $CLI INSERT INTO LU VALUES "(17592186044416,       5)"
  $CLI INSERT INTO LU VALUES "(576460752303423488,   6)"
  $CLI INSERT INTO LU VALUES "(18446744073709551615, 7)"
}
function test_LU() {
  init_LU
  insert_LU
  $CLI DUMP LU
}
function test_LU_longs() {
  test_LU
  I=1844674407370954161;
  while [ $I -lt 1844674407370955161 ]; do
    echo -ne "${I}\t"
    $CLI INSERT INTO LU VALUES "($I,1)"; I=$[${I}+1];
  done
  I=576460752303423488;
  while [ $I -lt 576460752303424488 ]; do
    echo -ne "${I}\t"
    $CLI INSERT INTO LU VALUES "($I,1)"; I=$[${I}+1];
  done
  I=1000;
  while [ $I -lt 2000 ]; do
    echo -ne "${I}\t"
    $CLI INSERT INTO LU VALUES "($I,1)"; I=$[${I}+1];
  done
}
# TODO function init_uniq_UU() { -> UU
function init_uniq_LU() {
  $CLI DROP   TABLE U_LU
  $CLI CREATE TABLE U_LU "(pk LONG, fk1 long, fk2 INT)";
  $CLI CREATE UNIQUE INDEX i_ULU ON U_LU "(fk1, fk2)";
}
function insert_uniq_LU() {
  $CLI INSERT INTO U_LU VALUES "(1,1,1)"
  $CLI INSERT INTO U_LU VALUES "(2,1,2)"
  $CLI INSERT INTO U_LU VALUES "(3,1,3)"
  $CLI INSERT INTO U_LU VALUES "(18446744073709551610, 18446744073709551610, 4)"
  $CLI INSERT INTO U_LU VALUES "(18446744073709551611, 18446744073709551610, 5)"
  $CLI INSERT INTO U_LU VALUES "(18446744073709551612, 18446744073709551610, 6)"
  $CLI INSERT INTO U_LU VALUES "(18446744073709551613, 18446744073709551610, 7)"
  $CLI INSERT INTO U_LU VALUES "(18446744073709551614, 18446744073709551610, 8)"
}
function test_uniq_LU() {
  init_uniq_LU
  insert_uniq_LU
  echo SELECT \* FROM U_LU WHERE fk1 = 1
  $CLI SELECT \* FROM U_LU WHERE fk1 = 1
  echo SELECT \* FROM U_LU WHERE fk1 = 18446744073709551610
  $CLI SELECT \* FROM U_LU WHERE fk1 = 18446744073709551610
  echo SELECT \* FROM U_LU WHERE fk1 = 18446744073709551610 AND fk2 = 4
  $CLI SELECT \* FROM U_LU WHERE fk1 = 18446744073709551610 AND fk2 = 4
}

function init_uniq_UL() {
  $CLI DROP   TABLE U_UL
  $CLI CREATE TABLE U_UL "(pk INT, fk1 long, fk2 long)";
  $CLI CREATE UNIQUE INDEX i_UUL ON U_UL "(fk1, fk2)";
}
function insert_uniq_UL() {
  $CLI INSERT INTO U_UL VALUES "(1,1,1)"
  $CLI INSERT INTO U_UL VALUES "(2,1,2)"
  $CLI INSERT INTO U_UL VALUES "(3,1,3)"
  $CLI INSERT INTO U_UL VALUES "(4,2,4)"
  $CLI INSERT INTO U_UL VALUES "(5,2,5)"
  $CLI INSERT INTO U_UL VALUES "(6,3,6)"
  $CLI INSERT INTO U_UL VALUES "(7,4,576460752303423487)"
  $CLI INSERT INTO U_UL VALUES "(8,4,576460752303423488)"
  $CLI INSERT INTO U_UL VALUES "(9,4,576460752303423489)"
  $CLI INSERT INTO U_UL VALUES "(10, 18446744073709551610, 18446744073709551610)"
  $CLI INSERT INTO U_UL VALUES "(11, 18446744073709551610, 18446744073709551611)"
  $CLI INSERT INTO U_UL VALUES "(12, 18446744073709551610, 18446744073709551612)"
  $CLI INSERT INTO U_UL VALUES "(13, 18446744073709551610, 18446744073709551613)"
}
function test_uniq_UL() {
  init_uniq_UL
  insert_uniq_UL
  echo SELECT \* FROM U_UL WHERE fk1 = 1
  $CLI SELECT \* FROM U_UL WHERE fk1 = 1
  echo SELECT \* FROM U_UL WHERE fk1 = 2
  $CLI SELECT \* FROM U_UL WHERE fk1 = 2
  echo SELECT \* FROM U_UL WHERE fk1 = 3
  $CLI SELECT \* FROM U_UL WHERE fk1 = 3
  echo SELECT \* FROM U_UL WHERE fk1 = 4
  $CLI SELECT \* FROM U_UL WHERE fk1 = 4
  echo SELECT \* FROM U_UL WHERE fk1 = 18446744073709551610
  $CLI SELECT \* FROM U_UL WHERE fk1 = 18446744073709551610
  echo SELECT \* FROM U_UL WHERE fk1 = 18446744073709551610 AND fk2 = 18446744073709551610
  $CLI SELECT \* FROM U_UL WHERE fk1 = 18446744073709551610 AND fk2 = 18446744073709551610
}


function init_LL() {
  $CLI DROP   TABLE LL
  $CLI CREATE TABLE LL "(pk LONG, fk1 LONG)";
}
function insert_LL() {
  $CLI INSERT INTO LL VALUES "(1,                    1)"
  $CLI INSERT INTO LL VALUES "(128,                  128)"
  $CLI INSERT INTO LL VALUES "(16384,                16384)"
  $CLI INSERT INTO LL VALUES "(536870912,            536870912)"
  $CLI INSERT INTO LL VALUES "(17592186044416,       17592186044416)"
  $CLI INSERT INTO LL VALUES "(576460752303423488,   576460752303423488)"
  $CLI INSERT INTO LL VALUES "(18446744073709551615, 18446744073709551615)"
}
function test_LL() {
  init_LL
  insert_LL
  $CLI DUMP LL
}

function init_uniq_LL() {
  $CLI DROP   TABLE U_LL
  $CLI CREATE TABLE U_LL "(pk LONG, fk1 long, fk2 long)";
  $CLI CREATE UNIQUE INDEX i_ULL ON U_LL "(fk1, fk2)";
}
function insert_uniq_LL() {
  $CLI INSERT INTO U_LL VALUES "(1,1,1)";
  $CLI INSERT INTO U_LL VALUES "(2,1,2)";
  $CLI INSERT INTO U_LL VALUES "(3,1,3)";
  $CLI INSERT INTO U_LL VALUES "(536870912,2,536870912)";
  $CLI INSERT INTO U_LL VALUES "(536870913,2,536870913)";
  $CLI INSERT INTO U_LL VALUES "(536870914,3,536870914)";
  $CLI INSERT INTO U_LL VALUES "(576460752303423487,4,576460752303423487)";
  $CLI INSERT INTO U_LL VALUES "(576460752303423488,4,576460752303423488)"
  $CLI INSERT INTO U_LL VALUES "(576460752303423489,4,576460752303423489)"
  $CLI INSERT INTO U_LL VALUES "(18446744073709551610, 18446744073709551610, 18446744073709551610)";
  $CLI INSERT INTO U_LL VALUES "(18446744073709551611, 18446744073709551610, 18446744073709551611)"
  $CLI INSERT INTO U_LL VALUES "(18446744073709551612, 18446744073709551610, 18446744073709551612)"
  $CLI INSERT INTO U_LL VALUES "(18446744073709551613, 18446744073709551610, 18446744073709551613)"
  $CLI INSERT INTO U_LL VALUES "(18446744073709551614, 18446744073709551610, 18446744073709551614)"
}
function test_uniq_LL() {
  init_uniq_LL
  insert_uniq_LL
  echo SELECT \* FROM U_LL WHERE fk1 = 1
  $CLI SELECT \* FROM U_LL WHERE fk1 = 1
  echo SELECT \* FROM U_LL WHERE fk1 = 2
  $CLI SELECT \* FROM U_LL WHERE fk1 = 2
  echo SELECT \* FROM U_LL WHERE fk1 = 3
  $CLI SELECT \* FROM U_LL WHERE fk1 = 3
  echo SELECT \* FROM U_LL WHERE fk1 = 4
  $CLI SELECT \* FROM U_LL WHERE fk1 = 4
  echo SELECT \* FROM U_LL WHERE fk1 = 18446744073709551610
  $CLI SELECT \* FROM U_LL WHERE fk1 = 18446744073709551610
  echo SELECT \* FROM U_LL WHERE fk1 = 18446744073709551610 AND fk2 = 18446744073709551610
  $CLI SELECT \* FROM U_LL WHERE fk1 = 18446744073709551610 AND fk2 = 18446744073709551610
  echo "VIOLATION (fails after first)"
  $CLI UPDATE U_LL SET fk2 = 18446744073709551609 WHERE fk1 = 18446744073709551610 ORDER BY fk2 LIMIT 4
  echo "should update ONE row - from previous VIOLATION"
   $CLI UPDATE U_LL SET fk2 = fk2 - 999 WHERE fk1 = 18446744073709551610 AND fk2 = 18446744073709551609
  echo "update FIVE cols"
  $CLI UPDATE U_LL SET fk2 = fk2 - 999 WHERE fk1 = 18446744073709551610
  echo "RETURN ONE ROW"
  $CLI SELECT \* FROM U_LL WHERE fk1 = 18446744073709551610 AND fk2 = 18446744073709550615
  echo "DELETE THREE"
  $CLI DELETE FROM U_LL WHERE fk1 = 1
  echo "ELEVEN"
  $CLI SCANSELECT "COUNT(*)" FROM U_LL
  echo "DEL ONE"
  $CLI DELETE FROM U_LL WHERE fk1 = 2 AND fk2 = 536870912
  echo "DEL ONE"
  $CLI DELETE FROM U_LL WHERE fk1 = 2
  echo "DEL FIVE"
  $CLI DELETE FROM U_LL WHERE fk1 = 18446744073709551610
  echo "FOUR"
  $CLI SCANSELECT "COUNT(*)" FROM U_LL
  $CLI DUMP U_LL
}

function test_other_bt_mem_usage() {
  C=200
  N=1000000
  if [ -n "$1" ]; then N=$1; fi
  echo UU $N rows
  init_UU;
  amem_pre;time taskset -c 1 $BENCH  -c $C -n $N -s 1 -A OK -Q INSERT INTO UU VALUES "(00000000000001,00000000000001)";amem_post

  echo UL $N rows
  init_UL;
  amem_pre;time taskset -c 1 $BENCH  -c $C -n $N -s 1 -A OK -Q INSERT INTO UL VALUES "(00000000000001,00000000000001)";amem_post

  echo LU $N rows
  init_LU;
  amem_pre;time taskset -c 1 $BENCH  -c $C -n $N -s 1 -A OK -Q INSERT INTO LU VALUES "(00000000000001,00000000000001)";amem_post

  echo LL $N rows
  init_LL;
  amem_pre;time taskset -c 1 $BENCH  -c $C -n $N -s 1 -A OK -Q INSERT INTO LL VALUES "(00000000000001,00000000000001)";amem_post
}
function delete_other_bts() {
  test_other_bt_mem_usage
  C=200
  N=1000000
  #OPT=" -s 1 "
  OPT=" -r $N "
  for O in UU UL LU LL; do
    echo DELETE $O $N rows
    time taskset -c 1 $BENCH  -c $C -n $N $OPT -A OK -Q DELETE FROM $O WHERE "pk=00000000000001";
  done
}

function init_cols3() {
  $CLI DROP   TABLE cols3
  $CLI CREATE TABLE cols3 "(pk LONG, fk1 LONG, fk2 LONG)"
  $CLI CREATE INDEX i1_c3 ON cols3 "(fk1)"
  $CLI CREATE INDEX i2_c3 ON cols3 "(fk2)"
}
function insert_cols3() {
  $CLI INSERT INTO cols3 VALUES "(1,11,7)"
  $CLI INSERT INTO cols3 VALUES "(2,11,8)"
  $CLI INSERT INTO cols3 VALUES "(3,33,9)"
  $CLI INSERT INTO cols3 VALUES "(4,33,9)"
}
function test_cols3() {
  init_cols3;
  insert_cols3;
  echo "RANGE should win it has 3 rows, INL has 4"
  EXPLAIN SELECT \* FROM cols3 WHERE "fk1 IN (11,33) AND fk2 BETWEEN 8 AND 9"
}

function test_OTHER_index() {
  C=200
  N=100000
  if [ -z "$1" ]; then echo "$0 [UU|UL|LU|LL]"; return; fi
  TBL=$1
  init_${TBL}
  amem_pre;time taskset -c 1 $BENCH -q -c $C -n $N -s 1 -m 1000 -A OK -Q INSERT INTO ${TBL} VALUES "(00000000000001,00000000000001)";amem_post
  $CLI CREATE INDEX I_${TBL} ON ${TBL} "(fk1)"
  $CLI SELECT "COUNT(*)" FROM ${TBL} WHERE fk1 = 999
  time taskset -c 1 $BENCH -q -c $C -n $N -r 1000 -m 1000 -A OK -Q DELETE FROM ${TBL} WHERE fk1=00000000000001
  $CLI DESC ${TBL} 
}
function test_ALL_OTHER_index() {
  test_OTHER_index UU
  test_OTHER_index UL
  test_OTHER_index LU
  test_OTHER_index LL
}

function test_AA_backdoor() {
  $CLI DROP   TABLE AA_BD
  $CLI CREATE TABLE AA_BD "(pk INT, fk1 INT)"
  $CLI INSERT INTO AA_BD VALUES "(,1)"
  $CLI INSERT INTO AA_BD VALUES "(,1)"
  $CLI INSERT INTO AA_BD VALUES "(,1)"
  $CLI INSERT INTO AA_BD VALUES "(,1)"
  $CLI INSERT INTO AA_BD VALUES "(99,99)"
  $CLI INSERT INTO AA_BD VALUES "(,99)"
  $CLI INSERT INTO AA_BD VALUES "(,99)"
  echo "AA_BD PK:[1-4,99-101]"
  $CLI DUMP AA_BD
}

function test_update_overwrite() {
  $CLI DROP   TABLE up
  $CLI CREATE TABLE up "(pk INT, t TEXT)";
  $CLI INSERT INTO up VALUES "(1,'3124lkhafsldfh1239hldsfjhdaslr572489yrasdjbnczxchqweryk.dcvhj')" "RETURN SIZE"
  $CLI DESC up
  $CLI DUMP up
  echo "SAME SIZE"
  $CLI UPDATE up SET "t = '3124lkhafsldfh1239hldsfjhdaslr572489yrasdjbnczxchqweryk.dcvhjNEW'" WHERE pk = 1;
  $CLI DESC up
  $CLI DUMP up
  echo "NEW POINTER"
  $CLI UPDATE up SET "t = '3124lkhafsldfh1239hldsfjhdaslr572489yrasdjbnczxchqweryk.dcvhjNEWSTUFFasfjklhasdfkljhasdklfhasdklfhsdaklfhlhfasdferwg345623452345HXXY1234'" WHERE pk = 1;
  $CLI DESC up
  $CLI DUMP up
  echo "REALLOC OVERWRITE"
  $CLI UPDATE up SET "t = '3124lkhafsldfh1239hldsfjhdaslr572489yrasdjbnczxchqweryk.dcvhjNEWSTUFFasfjklhasdfkljhasdklfhasdklfhsdaklfhlhfasdferwg345623452345HXXY1234ab'" WHERE pk = 1;
  $CLI DUMP up
  $CLI DESC up
  echo 4th update path - OTHER_BT
  init_UU; insert_UU
  $CLI SELECT \* FROM UU WHERE pk=1
  $CLI UPDATE UU SET fk1=99 WHERE pk=1
  $CLI SELECT \* FROM UU WHERE pk=1
}

function bulk_insert_simple() {
  echo "SIMPLE inserter"
  $CLI DROP   TABLE inserter
  $CLI CREATE TABLE inserter "(pk INT, fk1 INT)"
  $CLI INSERT INTO inserter VALUES "(,1)" "(,1)" "(,1)" "(,1)" "(,1)" "RETURN SIZE"
  $CLI INSERT INTO inserter VALUES "(,1)" "(,1)" "(,1)" "(,1)" "(,1)"
  $CLI INSERT INTO inserter VALUES "(,1)" "(,1)" "(,1)" "(,1)" "(,1)" "RETURN SIZE"
  $CLI INSERT INTO inserter VALUES "(,1)" "(,1)" "(,1)" "(,1)" "(,1)"
}
function bulk_inserter() {
  bulk_insert_simple
}

function test_partial() {
  $CLI DROP TABLE partial;
  $CLI CREATE TABLE partial "(pk INT, fk1 INT, fk2 INT, fk3 INT, fk4 INT, fk5 INT, fk6 INT, t1 TEXT, t2 TEXT)";
  $CLI CREATE INDEX i_p_2 ON partial "(fk2)"
  $CLI INSERT INTO partial "(fk3, pk, fk5)" VALUES "(333,1,55555)" ;
  $CLI INSERT INTO partial "(fk4, pk, fk1, fk2)" VALUES "(4444,,1,22)" ;
  $CLI INSERT INTO partial "(fk6, pk)" VALUES "(666666,)" ;
  $CLI INSERT INTO partial "(pk, t2, t1, fk1)" VALUES "(,'TTTTT','ooooo',1)" ;
  $CLI INSERT INTO partial VALUES "(,1,22,333,4444,555555,666666,'T','o')"
  echo "NOT LZF"
  $CLI INSERT INTO partial "(pk, t2, t1)" VALUES "(,'ADFLKJSDFLJQOIERULSKDFJASKLDJFLASKDJFOFIJSLFK','ooooo')" ;
  $CLI INSERT INTO partial "(pk, t2, t1)" VALUES "(,'ADFaaaaaaaaaaaLKJSDFLJQOIERULSKDFJbbbbbbbbbbbbbbASKLDJFLASKDJccccccccccccccccccFOFIJSLFK','ooooo')" ;
  $CLI INSERT INTO partial "(pk, t2, t1)" VALUES "(,'111111111111111112222222222222222222233333333333333333444444444444444445555555555556666666666666777777777777888888888888899999999999qqqqqqwwwwwwwwwweeeeerrrrrrrrtttttttttttyyyyyyyyyADFaaaaaaaaaaaLKJSDFLJQOIERULSKDFJbbbbbbbbbbbbbbASKLDJFLASKDJccccccccccccccccccFOFIJSLFK','ooooo')" ;
  $CLI INSERT INTO partial "(pk, t2, t1)" VALUES "(,'asdfyu123p4ha9d8fy23uhra9sdfyk123jr498asdfhklasehr98124hfkjlasdyr9q2348fasjkdfhr13498rhfasdjklyr123489frhqw8asdflk1345hfsdlru240nfles4ui4111111111111111112222222222222222222233333333333333333444444444444444445555555555556666666666666777777777777888888888888899999999999qqqqqqwwwwwwwwwweeeeerrrrrrrrtttttttttttyyyyyyyyyADFaaaaaaaaaaaLKJSDFLJQOIERULSKDFJbbbbbbbbbbbbbbASKLDJFLASKDJccccccccccccccccccFOFIJSLFK','ooooo')" ;
  $CLI DUMP partial
  echo
  echo UNDEFINED UPDATE
  $CLI UPDATE partial SET "fk1= fk1 + 1" WHERE pk = 3; $CLI SELECT \* FROM partial WHERE pk=3
  $CLI UPDATE partial SET "fk1=1" WHERE pk = 3; $CLI SELECT \* FROM partial WHERE pk=3
  $CLI UPDATE partial SET "fk1= fk1 + 1" WHERE pk = 3; $CLI SELECT \* FROM partial WHERE pk=3
  $CLI UPDATE partial SET "fk3=333" WHERE pk = 3; $CLI SELECT \* FROM partial WHERE pk=3
  echo INDEXES 2 rows
  $CLI SELECT \* FROM partial WHERE fk2 = 22
  $CLI UPDATE partial SET fk2=22 WHERE pk=1
  echo INDEXES 3 rows
  $CLI SELECT \* FROM partial WHERE fk2 = 22
  echo NEW INDEX
  $CLI CREATE INDEX i_p_3 ON partial "(fk3)"
  echo INDEXES 3 rows
  $CLI SELECT \* FROM partial WHERE fk3 = 333
  echo MCI
  $CLI CREATE UNIQUE INDEX i_p_mci_1_2_3 ON partial "(fk1,fk2,fk3)"
  echo ONE ROW
  $CLI SELECT \* FROM partial WHERE fk1 = 1
  echo DELETE 3 via INDEX on fk3
  $CLI DELETE FROM partial WHERE fk3 = 333
  echo "ZERO ROWs (collateral)"
  $CLI SELECT \* FROM partial WHERE fk1 = 1
  $CLI DUMP partial

  $CLI SELECT \* FROM partial WHERE fk1 = 1
  echo UPDATE partial SET "fk2 = 22, fk3 =333" WHERE pk = 4
  $CLI UPDATE partial SET "fk2 = 22, fk3 =333" WHERE pk = 4
  echo ONE ROW
  $CLI SELECT \* FROM partial WHERE fk1 = 1
  echo UPDATE partial SET "fk1 = 7, fk2 = 22, fk3 =333" WHERE pk = 4
  $CLI UPDATE partial SET "fk1 = 7, fk2 = 22, fk3 =333" WHERE pk = 4
  echo ZERO ROWs
  $CLI SELECT \* FROM partial WHERE fk1 = 1
  echo ONE ROW
  $CLI SELECT \* FROM partial WHERE fk1 = 7
}

function test_alter() {
  $CLI DROP   TABLE AT
  $CLI CREATE TABLE AT "(pk INT, c1 INT, c2 INT)"
  $CLI INSERT INTO AT VALUES "(,1,77)"
  $CLI INSERT INTO AT VALUES "(,2,88)"
  $CLI INSERT INTO AT VALUES "(,3,99)"
  $CLI ALTER TABLE AT ADD COLUMN fk3 INT
  $CLI ALTER TABLE AT ADD COLUMN fk4 LONG
  $CLI ALTER TABLE AT ADD COLUMN fk5 FLOAT
  $CLI ALTER TABLE AT ADD COLUMN fk6 TEXT
  echo 2 errors
  $CLI ALTER TABLE AT ADD COLUMN bad PARSE
  $CLI ALTER TABLE AT ADD COLUMN fk3 INT
  echo DESC
  $CLI DESC AT
  echo DUMP
  $CLI DUMP AT
  echo OK UPDATE
  $CLI UPDATE AT SET "fk4=999999999999999" WHERE pk = 2
  echo VIOLATION UPDATE
  $CLI UPDATE AT SET "fk4= fk4+ 10" WHERE pk = 3
  echo INSERT new COLS
  $CLI INSERT INTO AT VALUES "(,4,66,222,3333,444.44,'FIVE')"
  echo DUMP
  $CLI DUMP AT
}
function init_lru() {
  $CLI DROP   TABLE LRU
  $CLI CREATE TABLE LRU "(pk INT, c1 INT, c2 INT)"
  $CLI CREATE LRUINDEX ON LRU
}
function test_lru() {
  SLEEP_TIME=4
  $CLI DROP   TABLE LRU
  $CLI CREATE TABLE LRU "(pk INT, c1 INT, c2 INT)"
  $CLI INSERT INTO LRU VALUES "(,9,666)"
  $CLI INSERT INTO LRU VALUES "(,11,777)"
  $CLI INSERT INTO LRU VALUES "(,22,888)"
  $CLI INSERT INTO LRU VALUES "(,33,999)"
  $CLI INSERT INTO LRU VALUES "(,44,111)"
  $CLI INSERT INTO LRU VALUES "(,55,222)"
  $CLI INSERT INTO LRU VALUES "(,66,999)"
  $CLI INSERT INTO LRU VALUES "(,88,222)"
  $CLI INSERT INTO LRU VALUES "(,99,333)"
  $CLI DESC LRU
  echo SCANSELECT \* FROM LRU
  $CLI SCANSELECT \* FROM LRU
  echo CREATE LRUINDEX ON LRU
  $CLI CREATE LRUINDEX ON LRU
  $CLI DESC LRU
  echo SCANSELECT \* FROM LRU
  $CLI SCANSELECT \* FROM LRU
  if [ -n "$1" ]; then echo sleep $SLEEP_TIME; sleep $SLEEP_TIME; fi
  echo SCANSELECT \* FROM LRU ORDER BY c2 LIMIT 4
  $CLI SCANSELECT \* FROM LRU ORDER BY c2 LIMIT 4
  if [ -n "$1" ]; then echo sleep $SLEEP_TIME; sleep $SLEEP_TIME; fi
  echo UPDATE LRU SET c1=1 WHERE pk BETWEEN 3 AND 5
  $CLI UPDATE LRU SET c1=1 WHERE pk BETWEEN 3 AND 5
  if [ -n "$1" ]; then echo sleep $SLEEP_TIME; sleep $SLEEP_TIME; fi
  echo JOIN
  init_UU; insert_UU
  echo SELECT \* FROM "LRU l, UU u" WHERE "u.pk = l.pk AND l.pk BETWEEN 6 AND 7"
  $CLI SELECT \* FROM "LRU l, UU u" WHERE "u.pk = l.pk AND l.pk BETWEEN 6 AND 7"
  if [ -n "$1" ]; then echo sleep $SLEEP_TIME; sleep $SLEEP_TIME; fi
  echo 2 X INSERT INTO LRU VALUES "(,77,444)"
  $CLI INSERT INTO LRU VALUES "(,77,444)"
  $CLI INSERT INTO LRU VALUES "(,77,444)"
  echo DUMP LRU
  $CLI DUMP LRU
  $CLI DUMP LRU TO FILE /tmp/XXX; cut -f 4 -d \, /tmp/XXX |sort |uniq -c
}
function lru_test_iterations() {
  init_lru
  I=0
  LIM=50
  C=10; N=60;
  while [ $I -lt $LIM ]; do
    time taskset -c 1 $BENCH -q -c $C -n $N -A OK -Q INSERT INTO LRU VALUES "(,1,1)";
    I=$[${I}+1];
    sleep 2.2;
  done
  $CLI DUMP LRU TO FILE /tmp/XXX; cut -f 4 -d \, /tmp/XXX |sort |uniq -c
}

function test_replace() {
  echo TEST REPLACE
  echo test_uniq_LU
  test_uniq_LU > /dev/null
  echo SELECT \* FROM U_LU WHERE fk1=1
  $CLI SELECT \* FROM U_LU WHERE fk1=1
  echo INSERT INTO U_LU VALUES "(2,1,3)" - OVERWRITE
  $CLI INSERT INTO U_LU VALUES "(2,1,3)" "RETURN SIZE"
  echo REPLACE INTO U_LU VALUES "(2,1,3)" - UNIQUE MCI VIOLATION
  $CLI REPLACE INTO U_LU VALUES "(2,1,3)" "RETURN SIZE"
  echo SELECT \* FROM U_LU WHERE fk1=1 - no change
  $CLI SELECT \* FROM U_LU WHERE fk1=1
  echo REPLACE INTO U_LU VALUES "(2,1,4)" - WORKS
  $CLI REPLACE INTO U_LU VALUES "(2,1,4)" "RETURN SIZE"
  echo SELECT \* FROM U_LU WHERE fk1=1 - ONE CHANGED ROW
  $CLI SELECT \* FROM U_LU WHERE fk1=1
  echo "SELECT \* FROM U_LU WHERE fk1=1 AND fk2=2 -> 0 rows"
  $CLI SELECT \* FROM U_LU WHERE fk1=1 AND fk2=2
  echo "SELECT \* FROM U_LU WHERE fk1=1 AND fk2=4 -> 1 row"
  $CLI SELECT \* FROM U_LU WHERE fk1=1 AND fk2=4
}

function replace_3() {
  $CLI REPLACE INTO UU VALUES "(1,44)"
  $CLI REPLACE INTO UU VALUES "(2,55)" "RETURN SIZE"
  $CLI REPLACE INTO UU VALUES "(3,66)" "RETURN SIZE"
}
function insert_3() {
  $CLI INSERT  INTO UU VALUES "(1,11)"
  $CLI INSERT  INTO UU VALUES "(2,22)" "RETURN SIZE"
  $CLI INSERT  INTO UU VALUES "(3,33)" "RETURN SIZE"
}
function test_different_insert_calls() {
  init_UU
  echo insert_3 insert_3
  insert_3
  insert_3
  $CLI DUMP UU
  init_UU
  echo insert_3 replace_3
  insert_3
  replace_3
  $CLI DUMP UU
  init_UU
  echo replace_3 insert_3
  replace_3
  insert_3
  $CLI DUMP UU
  init_UU
  echo replace_3 replace_3
  replace_3
  replace_3
  $CLI DUMP UU
}
function replace_ALL_3() {
  $CLI REPLACE INTO UU VALUES "(1,44)" "(2,55)" "(3,66)" "RETURN SIZE"
}
function insert_ALL_3() {
  $CLI INSERT  INTO UU VALUES "(1,11)" "(2,22)" "(3,33)" "RETURN SIZE"
}
function test_different_insert_ALL_calls() {
  init_UU
  echo insert_ALL_3 insert_ALL_3
  insert_ALL_3
  insert_ALL_3
  $CLI DUMP UU
  init_UU
  echo insert_ALL_3 replace_ALL_3
  insert_ALL_3
  replace_ALL_3
  $CLI DUMP UU
  init_UU
  echo replace_ALL_3 insert_ALL_3
  replace_ALL_3
  insert_ALL_3
  $CLI DUMP UU
  init_UU
  echo replace_ALL_3 replace_ALL_3
  replace_ALL_3
  replace_ALL_3
  $CLI DUMP UU
}
function replace_REDUNDANT_3() {
  $CLI REPLACE INTO UU VALUES "(1,44)" "(2,55)" "(1,44)" "RETURN SIZE"
}
function insert_REDUNDANT_3() {
  $CLI INSERT  INTO UU VALUES "(1,11)" "(2,22)" "(1,11)" "RETURN SIZE"
}
function insert_REDUNDANT_3_simple() {
  $CLI INSERT  INTO UU VALUES "(1,11)" "(2,22)" "(1,11)"
}
function test_different_insert_REDUNDANT_calls() {
  init_UU
  echo insert_REDUNDANT_3 insert_REDUNDANT_3
  insert_REDUNDANT_3
  insert_REDUNDANT_3
  $CLI DUMP UU
  init_UU
  echo insert_REDUNDANT_3 replace_REDUNDANT_3
  insert_REDUNDANT_3
  replace_REDUNDANT_3
  $CLI DUMP UU
  init_UU
  echo replace_REDUNDANT_3 insert_REDUNDANT_3
  replace_REDUNDANT_3
  insert_REDUNDANT_3
  $CLI DUMP UU
  init_UU
  echo replace_REDUNDANT_3 replace_REDUNDANT_3
  replace_REDUNDANT_3
  replace_REDUNDANT_3
  $CLI DUMP UU
  init_UU
  echo insert_REDUNDANT_3_simple
  insert_REDUNDANT_3_simple
  $CLI DUMP UU
}
function test_insert_output() {
  bulk_insert_simple  
  test_different_insert_calls
  test_different_insert_ALL_calls
  test_different_insert_REDUNDANT_calls
}

function test_iup() {
  init_UU
  echo 3 X INSERT INTO UU VALUES "(1,11)" "(2,22)" "ON DUPLICATE KEY UPDATE" "fk1 = fk1 * 9" "RETURN SIZE"
  $CLI INSERT INTO UU VALUES "(1,11)" "(2,22)" "ON DUPLICATE KEY UPDATE" "fk1 = fk1 * 9" "RETURN SIZE"
  $CLI INSERT INTO UU VALUES "(1,11)" "(2,22)" "ON DUPLICATE KEY UPDATE" "fk1 = fk1 * 9" "RETURN SIZE"
  $CLI INSERT INTO UU VALUES "(1,11)" "(2,22)" "ON DUPLICATE KEY UPDATE" "fk1 = fk1 * 9" "RETURN SIZE"
  $CLI DUMP UU
  echo DELETE FROM UU WHERE pk = 1
  $CLI DELETE FROM UU WHERE pk = 1
  echo INSERT INTO UU VALUES "(1,11)" "(2,22)" "ON DUPLICATE KEY UPDATE" "fk1 = fk1 * 9" "RETURN SIZE"
  $CLI INSERT INTO UU VALUES "(1,11)" "(2,22)" "ON DUPLICATE KEY UPDATE" "fk1 = fk1 * 9" "RETURN SIZE"
  $CLI DUMP UU
  echo DELETE FROM UU WHERE pk = 2
  $CLI DELETE FROM UU WHERE pk = 2
  echo INSERT INTO UU VALUES "(1,11)" "(2,22)" "ON DUPLICATE KEY UPDATE" "fk1 = fk1 * 9" "RETURN SIZE"
  $CLI INSERT INTO UU VALUES "(1,11)" "(2,22)" "ON DUPLICATE KEY UPDATE" "fk1 = fk1 * 9" "RETURN SIZE"
  $CLI DUMP UU

  init_UU
  echo 3 X INSERT INTO UU VALUES "(1,11)" "(2,22)" "ON DUPLICATE KEY UPDATE" "fk1 = fk1 * 9";
  $CLI INSERT INTO UU VALUES "(1,11)" "(2,22)" "ON DUPLICATE KEY UPDATE" "fk1 = fk1 * 9";
  $CLI INSERT INTO UU VALUES "(1,11)" "(2,22)" "ON DUPLICATE KEY UPDATE" "fk1 = fk1 * 9";
  $CLI INSERT INTO UU VALUES "(1,11)" "(2,22)" "ON DUPLICATE KEY UPDATE" "fk1 = fk1 * 9";
  $CLI DUMP UU
  echo DELETE FROM UU WHERE pk = 1
  $CLI DELETE FROM UU WHERE pk = 1
  echo INSERT INTO UU VALUES "(1,11)" "(2,22)" "ON DUPLICATE KEY UPDATE" "fk1 = fk1 * 9";
  $CLI INSERT INTO UU VALUES "(1,11)" "(2,22)" "ON DUPLICATE KEY UPDATE" "fk1 = fk1 * 9";
  $CLI DUMP UU
  echo DELETE FROM UU WHERE pk = 2
  $CLI DELETE FROM UU WHERE pk = 2
  echo INSERT INTO UU VALUES "(1,11)" "(2,22)" "ON DUPLICATE KEY UPDATE" "fk1 = fk1 * 9";
  $CLI INSERT INTO UU VALUES "(1,11)" "(2,22)" "ON DUPLICATE KEY UPDATE" "fk1 = fk1 * 9";
  $CLI DUMP UU

  init_UU
  echo 3 X INSERT INTO UU VALUES "(1,11)" "ON DUPLICATE KEY UPDATE" "fk1 = fk1 * 9" "RETURN SIZE"
  $CLI INSERT INTO UU VALUES "(1,11)" "ON DUPLICATE KEY UPDATE" "fk1 = fk1 * 9" "RETURN SIZE"
  $CLI INSERT INTO UU VALUES "(1,11)" "ON DUPLICATE KEY UPDATE" "fk1 = fk1 * 9" "RETURN SIZE"
  $CLI INSERT INTO UU VALUES "(1,11)" "ON DUPLICATE KEY UPDATE" "fk1 = fk1 * 9" "RETURN SIZE"
  $CLI DUMP UU
  echo DELETE FROM UU WHERE pk = 1
  $CLI DELETE FROM UU WHERE pk = 1
  echo INSERT INTO UU VALUES "(1,11)" "ON DUPLICATE KEY UPDATE" "fk1 = fk1 * 9" "RETURN SIZE"
  $CLI INSERT INTO UU VALUES "(1,11)" "ON DUPLICATE KEY UPDATE" "fk1 = fk1 * 9" "RETURN SIZE"
  $CLI DUMP UU

  init_UU
  echo 3 X INSERT INTO UU VALUES "(1,11)" "ON DUPLICATE KEY UPDATE" "fk1 = fk1 * 9" 
  $CLI INSERT INTO UU VALUES "(1,11)" "ON DUPLICATE KEY UPDATE" "fk1 = fk1 * 9" 
  $CLI INSERT INTO UU VALUES "(1,11)" "ON DUPLICATE KEY UPDATE" "fk1 = fk1 * 9" 
  $CLI INSERT INTO UU VALUES "(1,11)" "ON DUPLICATE KEY UPDATE" "fk1 = fk1 * 9" 
  $CLI DUMP UU
  echo DELETE FROM UU WHERE pk = 1
  $CLI DELETE FROM UU WHERE pk = 1
  echo INSERT INTO UU VALUES "(1,11)" "ON DUPLICATE KEY UPDATE" "fk1 = fk1 * 9"
  $CLI INSERT INTO UU VALUES "(1,11)" "ON DUPLICATE KEY UPDATE" "fk1 = fk1 * 9" 
  $CLI DUMP UU
}


# LUATRIGGER LUATRIGGER LUATRIGGER LUATRIGGER LUATRIGGER LUATRIGGER
# LUATRIGGER LUATRIGGER LUATRIGGER LUATRIGGER LUATRIGGER LUATRIGGER
function init_cap_test() {
  $CLI DROP   TABLE cap
  $CLI CREATE TABLE cap "(pk INT, fk1 INT, t TEXT)"
  $CLI CREATE INDEX      i_cap  ON cap "(fk1)"
  $CLI CREATE LUATRIGGER lt_cap ON cap "cap(fk1)"

  # TRIGGER -> LUA cap()
  #$CLI CREATE TRIGGER t_cap ON cap "LUA return cap(\$fk1);"

  # TRIGGER -> INSERT
  #$CLI CREATE TABLE cnt_cap_fk "(fk INT, count INT)"
  #$CLI CREATE TRIGGER t_m ON cap "INSERT INTO cnt_cap_fk VALUES (\$fk1, 1) ON DUPLICATE KEY UPDATE count = count + 1" "UPDATE cnt_cap_fk SET count=count-1 WHERE fk=\$fk1"
}
function cap_test() {
  init_cap_test
  C=200
  REQ=1000000
  taskset -c 1 $BENCH -c $C -n $REQ -s 1 -m 777,999 -A OK -Q INSERT INTO cap VALUES "(00000000000001,00000000000001,'pagename_00000000000001')";
}

function first_ltrigger_test() {
  init_UU
  echo CREATE LUATRIGGER lt_UU ON UU "lcap_add(fk1, pk)" "lcap_del(fk1, pk)"
  $CLI CREATE LUATRIGGER lt_UU ON UU "lcap_add(fk1, pk)" "lcap_del(fk1, pk)"
  echo 2 X INSERT INTO UU VALUES "(,7)"
  $CLI INSERT INTO UU VALUES "(,7)"
  $CLI INSERT INTO UU VALUES "(,7)"
  echo DELETE FROM UU WHERE pk=1
  $CLI DELETE FROM UU WHERE pk=1
}

function lcap_test() {
  $CLI CONFIG ADD LUA cap.lua
  $CLI DROP   TABLE lcap
  $CLI CREATE TABLE lcap "(pk INT, fk1 INT, fk2 INT)"
  $CLI CREATE INDEX      i_lcap   ON lcap "(fk1)"
  $CLI CREATE LUATRIGGER dlt_lcap ON lcap "add_lcap(fk1)" "del_lcap(fk1, fk2)"
  $CLI CREATE LRUINDEX ON lcap
  $CLI INSERT INTO lcap VALUES "(1,1,1)"
  $CLI INSERT INTO lcap VALUES "(2,2,2)"
  $CLI INSERT INTO lcap VALUES "(3,3,3)"
  $CLI DELETE FROM lcap WHERE "pk = 1"
}
