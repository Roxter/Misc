set verify off
declare
	res number;
begin
	select count(1) into res from all_users where upper(username) = upper('student_db');
	if res <> 0 then
    execute immediate 'drop user STUDENT_DB cascade';
	end if;
end;
/
CREATE USER STUDENT_DB IDENTIFIED BY 0;
GRANT CONNECT, RESOURCE, DBA, CREATE ROLE, CREATE USER, ALTER USER, CREATE SESSION, CREATE PROFILE TO STUDENT_DB;
DISCONNECT system;
CONNECT STUDENT_DB/0;
CREATE TABLE FACULTY (
Faculty_Letter  varchar2(250),
Faculty_Name  varchar2(250),
CONSTRAINT Faculty_Letter_Cons PRIMARY KEY (Faculty_Letter)
);
CREATE TABLE STUDENT (
Student_ID  number,
Group_code  varchar2(250),
CONSTRAINT Student_ID_Cons PRIMARY KEY (Student_ID)
);
CREATE TABLE TEST (
Test_ID  number,
Test_Name  varchar2(250),
CONSTRAINT Test_ID_Cons PRIMARY KEY (Test_ID )
);
CREATE TABLE STUDENT_TEST (
Test_ID  number,
Student_ID  number,
Score  number
);
ALTER TABLE STUDENT_TEST ADD CONSTRAINT Cons1
    FOREIGN KEY (STUDENT_ID)
    REFERENCES STUDENT_DB.STUDENT(STUDENT_ID)
;
ALTER TABLE STUDENT_TEST ADD CONSTRAINT Cons2
    FOREIGN KEY (TEST_ID)
    REFERENCES STUDENT_DB.TEST(TEST_ID)
;