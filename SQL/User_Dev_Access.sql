REM
REM             Database creation script
REM
REM      This script must be run under SYS account
REM
set verify off
prompt Creating schema user...

accept schema_name prompt 'Please enter the name of the schema to generate: '
accept schema_password prompt 'Please enter the password of the schema: '

accept ru_name prompt 'Please enter the name RU'
accept ru_password prompt 'Please enter the password RU'

accept en_name prompt 'Please enter the name EN '
accept en_password prompt 'Please enter the password EN'

REM dropping the user if already exists
declare
	res number;
	coursenum number;
	studentnum number;
	cntr number;
begin

	select count(1) into res from all_users where upper(username) = upper('&schema_name');
	if res <> 0 then
    execute immediate 'drop user &schema_name cascade';
	end if;
	
  select count(1) into res from all_users where upper(username) = upper('&ru_name');
	if res <> 0 then
		execute immediate 'drop user &ru_name cascade';
	end if;
	
  select count(1) into res from all_users where upper(username) = upper('&en_name');	
	if res <> 0 then
		execute immediate 'drop user &en_name cascade';
	end if;
	
end;
/
prompt user created...
/

CONNECT system/0;

CREATE USER &schema_name IDENTIFIED BY &schema_password;
GRANT CONNECT, RESOURCE, CREATE TABLE TO &schema_name;

ALTER USER &schema_name QUOTA UNLIMITED ON USERS;
/
CONNECT &schema_name/&schema_password;

CREATE TABLE STUDENT_RU
( st_id number(10) NOT NULL,
  st_name varchar2(30) NOT NULL,
  st_surname varchar2(30) NOT NULL,
  faculty varchar2(50) NOT NULL,
  CONSTRAINT st_id PRIMARY KEY (st_id)
);
/
CREATE TABLE COURSES_RU 
( st_id number(10) NOT NULL,
  st_name varchar2(30) NOT NULL,
  st_surname varchar2(30) NOT NULL,
  course varchar2(50) NOT NULL,
  grade number(10),
  CONSTRAINT id PRIMARY KEY (st_id, course),
   FOREIGN KEY (st_id)
   REFERENCES STUDENT_RU(st_id)
);
/
INSERT ALL
	INTO STUDENT_RU (st_id ,st_name ,st_surname ,faculty) VALUES (1125, 'Иван', 'Петров', 'Твёрдых структур')
	INTO STUDENT_RU (st_id ,st_name ,st_surname ,faculty) VALUES (1126, 'Александр', 'Кузнецов', 'Твёрдых структур')
	INTO STUDENT_RU (st_id ,st_name ,st_surname ,faculty) VALUES (1127, 'Фёдор', 'Смолов', 'Тёмной материи')
	INTO STUDENT_RU (st_id ,st_name ,st_surname ,faculty) VALUES (1128, 'Ярослав', 'Баширов', 'Твёрдых структур')
	INTO STUDENT_RU (st_id ,st_name ,st_surname ,faculty) VALUES (1129, 'Пётр', 'Зайцев', 'Тёмной материи')
	INTO STUDENT_RU (st_id ,st_name ,st_surname ,faculty) VALUES (1130, 'Руслан', 'Иванов', 'Математики')
SELECT * FROM dual;
/
INSERT ALL
	INTO COURSES_RU (st_id ,st_name ,st_surname, course, grade) VALUES (1125, 'Иван', 'Петров', 'Статистика', 4)
	INTO COURSES_RU (st_id ,st_name ,st_surname, course, grade) VALUES (1126, 'Александр', 'Кузнецов', 'Статистика', 3)
	INTO COURSES_RU (st_id ,st_name ,st_surname, course, grade) VALUES (1127, 'Фёдор', 'Смолов', 'Геометрия', 4)
	INTO COURSES_RU (st_id ,st_name ,st_surname, course, grade) VALUES (1128, 'Ярослав', 'Баширов', 'Статистика', 4)
	INTO COURSES_RU (st_id ,st_name ,st_surname, course, grade) VALUES (1129, 'Пётр', 'Зайцев', 'Математика', 5)
	INTO COURSES_RU (st_id ,st_name ,st_surname, course, grade) VALUES (1130, 'Руслан', 'Иванов', 'Геометрия', 3)
	INTO COURSES_RU (st_id ,st_name ,st_surname, course, grade) VALUES (1126, 'Александр', 'Кузнецов', 'Математика', 4)
	INTO COURSES_RU (st_id ,st_name ,st_surname, course, grade) VALUES (1127, 'Фёдор', 'Смолов', 'Математика', 5)
	INTO COURSES_RU (st_id ,st_name ,st_surname, course, grade) VALUES (1128, 'Ярослав', 'Баширов', 'Математика', 5)
	INTO COURSES_RU (st_id ,st_name ,st_surname, course, grade) VALUES (1129, 'Пётр', 'Зайцев', 'Физика', 4)
	INTO COURSES_RU (st_id ,st_name ,st_surname, course, grade) VALUES (1130, 'Руслан', 'Иванов', 'Физика', 5)
SELECT * FROM dual;
/
CREATE TABLE STUDENT_EN
( st_EN_id number(10) NOT NULL,
  st_name varchar2(30) NOT NULL,
  st_surname varchar2(30) NOT NULL,
  faculty varchar2(50) NOT NULL,
  CONSTRAINT st_EN_id PRIMARY KEY (st_EN_id)
);
/
CREATE TABLE COURSES_EN 
( st_EN_id number(10) NOT NULL,
  st_name varchar2(30) NOT NULL,
  st_surname varchar2(30) NOT NULL,
  course varchar2(50) NOT NULL,
  grade number(10),
  CONSTRAINT idEN PRIMARY KEY (st_EN_id, course),
   FOREIGN KEY (st_EN_id)
   REFERENCES STUDENT_EN(st_EN_id)
);
/
INSERT ALL
  INTO STUDENT_EN (st_EN_id ,st_name ,st_surname ,faculty) VALUES (1125, 'Ivan', 'Petrov', 'Solid structure')
  INTO STUDENT_EN (st_EN_id ,st_name ,st_surname ,faculty) VALUES (1126, 'Alexander', 'Kuznetsov', 'Solid structure')
  INTO STUDENT_EN (st_EN_id ,st_name ,st_surname ,faculty) VALUES (1127, 'Fyodor', 'Smolov', 'Dark matter')
  INTO STUDENT_EN (st_EN_id ,st_name ,st_surname ,faculty) VALUES (1128, 'Yaroslav', 'Bashirov', 'Solid structure')
  INTO STUDENT_EN (st_EN_id ,st_name ,st_surname ,faculty) VALUES (1129, 'Peter', 'Zajcev', 'Dark matter')
  INTO STUDENT_EN (st_EN_id ,st_name ,st_surname ,faculty) VALUES (1130, 'Ruslan', 'Ivanov', 'Mathematics')
SELECT * FROM dual;
/
INSERT ALL
  INTO COURSES_EN (st_EN_id ,st_name ,st_surname, course, grade) VALUES (1125, 'Ivan', 'Petrov', 'Statistics', 4)
  INTO COURSES_EN (st_EN_id ,st_name ,st_surname, course, grade) VALUES (1126, 'Alexander', 'Kuznetsov', 'Statistics', 3)
  INTO COURSES_EN (st_EN_id ,st_name ,st_surname, course, grade) VALUES (1127, 'Fyodor', 'Smolov', 'Geometry', 4)
  INTO COURSES_EN (st_EN_id ,st_name ,st_surname, course, grade) VALUES (1128, 'Yaroslav', 'Bashirov', 'Statistics', 4)
  INTO COURSES_EN (st_EN_id ,st_name ,st_surname, course, grade) VALUES (1129, 'Peter', 'Zajcev', 'Mathematics', 5)
  INTO COURSES_EN (st_EN_id ,st_name ,st_surname, course, grade) VALUES (1130, 'Ruslan', 'Ivanov', 'Geometry', 3)
  INTO COURSES_EN (st_EN_id ,st_name ,st_surname, course, grade) VALUES (1126, 'Alexander', 'Kuznetsov', 'Mathematics', 4)
  INTO COURSES_EN (st_EN_id ,st_name ,st_surname, course, grade) VALUES (1127, 'Fyodor', 'Smolov', 'Mathematics', 5)
  INTO COURSES_EN (st_EN_id ,st_name ,st_surname, course, grade) VALUES (1128, 'Yaroslav', 'Bashirov', 'Mathematics', 5)
  INTO COURSES_EN (st_EN_id ,st_name ,st_surname, course, grade) VALUES (1129, 'Peter', 'Zajcev', 'Physics', 4)
  INTO COURSES_EN (st_EN_id ,st_name ,st_surname, course, grade) VALUES (1130, 'Ruslan', 'Ivanov', 'Physics', 5)
SELECT * FROM dual;
/
CONNECT system/0;
/
CREATE USER &ru_name IDENTIFIED BY &ru_password;
/
GRANT CONNECT, RESOURCE, CREATE SYNONYM TO &ru_name;
/

CREATE USER &en_name IDENTIFIED BY &en_password;
/
GRANT CONNECT, RESOURCE, CREATE SYNONYM TO &en_name;
/
CONNECT &schema_name/&schema_password;
GRANT SELECT ON COURSES_RU TO &ru_name;
GRANT SELECT ON STUDENT_RU TO &ru_name;
GRANT SELECT ON COURSES_EN TO &en_name;
GRANT SELECT ON STUDENT_EN TO &en_name;
/
CONNECT &ru_name/&ru_password;
/
CREATE OR REPLACE SYNONYM COURSES
FOR &schema_name..COURSES_RU;
/
CREATE OR REPLACE SYNONYM STUDENT
FOR &schema_name..STUDENT_RU;
/
SHOW USER
/
SELECT * FROM COURSES;
/
SELECT * FROM STUDENT;
/

CONNECT &en_name/&en_password;
/
CREATE OR REPLACE SYNONYM COURSES
FOR &schema_name..COURSES_EN;
/
CREATE OR REPLACE SYNONYM STUDENT
FOR &schema_name..STUDENT_EN;
/
SHOW USER
/
SELECT * FROM COURSES;
/
SELECT * FROM STUDENT;
/

CONNECT system/0;

CREATE PROFILE CAT_PROFILE LIMIT 
   SESSIONS_PER_USER          1 
   CPU_PER_CALL               60000; 
   
 CREATE PROFILE DOG_PROFILE LIMIT 
   SESSIONS_PER_USER          1 
   CPU_PER_CALL               30000; 

ALTER PROFILE DEFAULT LIMIT
PASSWORD_LIFE_TIME 180
PASSWORD_GRACE_TIME 7
PASSWORD_REUSE_TIME UNLIMITED
PASSWORD_REUSE_MAX UNLIMITED
FAILED_LOGIN_ATTEMPTS 10
PASSWORD_LOCK_TIME 1;

ALTER USER &ru_name PROFILE CAT_PROFILE;
ALTER USER &en_name PROFILE DOG_PROFILE;

DROP PROFILE CAT_PROFILE CASCADE;
DROP PROFILE DOG_PROFILE CASCADE;