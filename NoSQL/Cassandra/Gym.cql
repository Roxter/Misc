DROP KEYSPACE DATES;
DROP KEYSPACE CLIENTS;

DROP TABLE CLIENTS.CLIENTS_BY_REC_ID;

CREATE KEYSPACE DATES WITH replication = { 'class' : 'SimpleStrategy', 'replication_factor' : 2};
CREATE KEYSPACE CLIENTS WITH replication = { 'class' : 'SimpleStrategy', 'replication_factor' : 2};

CREATE TABLE CLIENTS.CLIENTS_BY_REC_ID (
Record_Num SMALLINT,
Client_ID SMALLINT,
Client_Name TEXT,
Client_Surname TEXT,
Sport_ID SMALLINT,
Sport_Type TEXT,
Abon_Cost SMALLINT,
PRIMARY KEY(Record_Num, Client_ID));

CREATE TABLE CLIENTS.CLIENTS_BY_SURNAME (
Record_Num SMALLINT,
Client_ID SMALLINT,
Client_Name TEXT,
Client_Surname TEXT,
Sport_ID SMALLINT,
Sport_Type TEXT,
Abon_Cost SMALLINT,
PRIMARY KEY(Record_Num, Client_Surname))
WITH CLUSTERING ORDER BY (Client_Surname ASC);

CREATE TABLE DATES.ABONEMENT_BY_ID (
Abon_ID SMALLINT,
Abon_Amount TEXT,
Abon_Cost SMALLINT,
PRIMARY KEY(Abon_ID, Abon_Cost));

CREATE TABLE DATES.ABONEMENT_BY_COST (
Abon_ID SMALLINT,
Abon_Amount TEXT,
Abon_Cost SMALLINT,
PRIMARY KEY(Abon_Cost, Abon_Amount))
WITH CLUSTERING ORDER BY (Abon_Amount ASC);

CREATE TABLE DATES.CLIENTS_BY_ID (
Record_Num SMALLINT,
Client_ID SMALLINT,
Client_Name TEXT,
Client_Surname TEXT,
Sport_ID SMALLINT,
Sport_Type TEXT,
Abon_Cost SMALLINT,
PRIMARY KEY(Client_ID, Client_Surname));

CREATE TABLE DATES.REG_BY_DATE (
Reg_ID SMALLINT,
Reg_Date DATE,
Client_ID SMALLINT,
Abon_Cost SMALLINT,
PRIMARY KEY(Reg_Date, Client_ID))
WITH CLUSTERING ORDER BY (Client_ID ASC);

INSERT INTO CLIENTS.CLIENTS_BY_REC_ID(Record_Num, Client_ID, Client_Name, Client_Surname, Sport_ID, Sport_Type, Abon_Cost) VALUES (1, 1, 'Elena', 'Tarablina', 1, 'Valleyball', 300);
INSERT INTO CLIENTS.CLIENTS_BY_REC_ID(Record_Num, Client_ID, Client_Name, Client_Surname, Sport_ID, Sport_Type, Abon_Cost) VALUES (2, 2, 'Vyacheslav', 'Zaycev', 2, 'Basketball', 200);
INSERT INTO CLIENTS.CLIENTS_BY_REC_ID(Record_Num, Client_ID, Client_Name, Client_Surname, Sport_ID, Sport_Type, Abon_Cost) VALUES (3, 3, 'Sergey', 'Gorbachev', 3, 'Football', 100);
INSERT INTO CLIENTS.CLIENTS_BY_REC_ID(Record_Num, Client_ID, Client_Name, Client_Surname, Sport_ID, Sport_Type, Abon_Cost) VALUES (4, 4, 'Sergey', 'Svetlakov', 4, 'Swimming', 400);
INSERT INTO CLIENTS.CLIENTS_BY_REC_ID(Record_Num, Client_ID, Client_Name, Client_Surname, Sport_ID, Sport_Type, Abon_Cost) VALUES (5, 5, 'Ilya', 'Bykov', 1, 'Valleyball', 300);
INSERT INTO CLIENTS.CLIENTS_BY_REC_ID(Record_Num, Client_ID, Client_Name, Client_Surname, Sport_ID, Sport_Type, Abon_Cost) VALUES (6, 2, 'Vyacheslav', 'Zaycev', 1, 'Valleyball', 100);
INSERT INTO CLIENTS.CLIENTS_BY_REC_ID(Record_Num, Client_ID, Client_Name, Client_Surname, Sport_ID, Sport_Type, Abon_Cost) VALUES (7, 5, 'Ilya', 'Bykov', 3, 'Football', 200);
INSERT INTO CLIENTS.CLIENTS_BY_REC_ID(Record_Num, Client_ID, Client_Name, Client_Surname, Sport_ID, Sport_Type, Abon_Cost) VALUES (8, 1, 'Elena', 'Tarablina', 4, 'Swimming', 100);

INSERT INTO CLIENTS.CLIENTS_BY_SURNAME(Record_Num, Client_ID, Client_Name, Client_Surname, Sport_ID, Sport_Type, Abon_Cost) VALUES (1, 1, 'Elena', 'Tarablina', 1, 'Valleyball', 300);
INSERT INTO CLIENTS.CLIENTS_BY_SURNAME(Record_Num, Client_ID, Client_Name, Client_Surname, Sport_ID, Sport_Type, Abon_Cost) VALUES (2, 2, 'Vyacheslav', 'Zaycev', 2, 'Basketball', 200);
INSERT INTO CLIENTS.CLIENTS_BY_SURNAME(Record_Num, Client_ID, Client_Name, Client_Surname, Sport_ID, Sport_Type, Abon_Cost) VALUES (3, 3, 'Sergey', 'Gorbachev', 3, 'Football', 100);
INSERT INTO CLIENTS.CLIENTS_BY_SURNAME(Record_Num, Client_ID, Client_Name, Client_Surname, Sport_ID, Sport_Type, Abon_Cost) VALUES (4, 4, 'Sergey', 'Svetlakov', 4, 'Swimming', 400);
INSERT INTO CLIENTS.CLIENTS_BY_SURNAME(Record_Num, Client_ID, Client_Name, Client_Surname, Sport_ID, Sport_Type, Abon_Cost) VALUES (5, 5, 'Ilya', 'Bykov', 1, 'Valleyball', 300);
INSERT INTO CLIENTS.CLIENTS_BY_SURNAME(Record_Num, Client_ID, Client_Name, Client_Surname, Sport_ID, Sport_Type, Abon_Cost) VALUES (6, 2, 'Vyacheslav', 'Zaycev', 1, 'Valleyball', 100);
INSERT INTO CLIENTS.CLIENTS_BY_SURNAME(Record_Num, Client_ID, Client_Name, Client_Surname, Sport_ID, Sport_Type, Abon_Cost) VALUES (7, 5, 'Ilya', 'Bykov', 3, 'Football', 200);
INSERT INTO CLIENTS.CLIENTS_BY_SURNAME(Record_Num, Client_ID, Client_Name, Client_Surname, Sport_ID, Sport_Type, Abon_Cost) VALUES (8, 1, 'Elena', 'Tarablina', 4, 'Swimming', 100);

INSERT INTO DATES.ABONEMENT_BY_ID(Abon_ID, Abon_Amount, Abon_Cost) VALUES (1, '3 raza', 300);
INSERT INTO DATES.ABONEMENT_BY_ID(Abon_ID, Abon_Amount, Abon_Cost) VALUES (2, '2 raza', 200);
INSERT INTO DATES.ABONEMENT_BY_ID(Abon_ID, Abon_Amount, Abon_Cost) VALUES (3, '4 raza', 400);
INSERT INTO DATES.ABONEMENT_BY_ID(Abon_ID, Abon_Amount, Abon_Cost) VALUES (4, '1 raz', 100);

INSERT INTO DATES.ABONEMENT_BY_COST(Abon_ID, Abon_Amount, Abon_Cost) VALUES (1, '3 raza', 300);
INSERT INTO DATES.ABONEMENT_BY_COST(Abon_ID, Abon_Amount, Abon_Cost) VALUES (2, '2 raza', 200);
INSERT INTO DATES.ABONEMENT_BY_COST(Abon_ID, Abon_Amount, Abon_Cost) VALUES (3, '4 raza', 400);
INSERT INTO DATES.ABONEMENT_BY_COST(Abon_ID, Abon_Amount, Abon_Cost) VALUES (4, '1 raz', 100);

INSERT INTO DATES.CLIENTS_BY_ID(Record_Num, Client_ID, Client_Name, Client_Surname, Sport_ID, Sport_Type, Abon_Cost) VALUES (1, 1, 'Elena', 'Tarablina', 1, 'Valleyball', 300);
INSERT INTO DATES.CLIENTS_BY_ID(Record_Num, Client_ID, Client_Name, Client_Surname, Sport_ID, Sport_Type, Abon_Cost) VALUES (2, 2, 'Vyacheslav', 'Zaycev', 2, 'Basketball', 200);
INSERT INTO DATES.CLIENTS_BY_ID(Record_Num, Client_ID, Client_Name, Client_Surname, Sport_ID, Sport_Type, Abon_Cost) VALUES (3, 3, 'Sergey', 'Gorbachev', 3, 'Football', 100);
INSERT INTO DATES.CLIENTS_BY_ID(Record_Num, Client_ID, Client_Name, Client_Surname, Sport_ID, Sport_Type, Abon_Cost) VALUES (4, 4, 'Sergey', 'Svetlakov', 4, 'Swimming', 400);
INSERT INTO DATES.CLIENTS_BY_ID(Record_Num, Client_ID, Client_Name, Client_Surname, Sport_ID, Sport_Type, Abon_Cost) VALUES (5, 5, 'Ilya', 'Bykov', 1, 'Valleyball', 300);
INSERT INTO DATES.CLIENTS_BY_ID(Record_Num, Client_ID, Client_Name, Client_Surname, Sport_ID, Sport_Type, Abon_Cost) VALUES (6, 2, 'Vyacheslav', 'Zaycev', 1, 'Valleyball', 100);
INSERT INTO DATES.CLIENTS_BY_ID(Record_Num, Client_ID, Client_Name, Client_Surname, Sport_ID, Sport_Type, Abon_Cost) VALUES (7, 5, 'Ilya', 'Bykov', 3, 'Football', 200);
INSERT INTO DATES.CLIENTS_BY_ID(Record_Num, Client_ID, Client_Name, Client_Surname, Sport_ID, Sport_Type, Abon_Cost) VALUES (8, 1, 'Elena', 'Tarablina', 4, 'Swimming', 100);

INSERT INTO DATES.REG_BY_DATE(Reg_ID, Reg_Date, Client_ID, Abon_Cost) VALUES (1, '2019-10-10', 5, 300);
INSERT INTO DATES.REG_BY_DATE(Reg_ID, Reg_Date, Client_ID, Abon_Cost) VALUES (2, '2019-10-11', 2, 200);
INSERT INTO DATES.REG_BY_DATE(Reg_ID, Reg_Date, Client_ID, Abon_Cost) VALUES (3, '2019-10-12', 3, 100);
INSERT INTO DATES.REG_BY_DATE(Reg_ID, Reg_Date, Client_ID, Abon_Cost) VALUES (4, '2019-10-20', 1, 300);
INSERT INTO DATES.REG_BY_DATE(Reg_ID, Reg_Date, Client_ID, Abon_Cost) VALUES (5, '2019-10-15', 4, 400);
INSERT INTO DATES.REG_BY_DATE(Reg_ID, Reg_Date, Client_ID, Abon_Cost) VALUES (6, '2019-11-09', 2, 100);
INSERT INTO DATES.REG_BY_DATE(Reg_ID, Reg_Date, Client_ID, Abon_Cost) VALUES (7, '2019-11-12', 5, 200);
INSERT INTO DATES.REG_BY_DATE(Reg_ID, Reg_Date, Client_ID, Abon_Cost) VALUES (8, '2019-11-11', 1, 100);

USE CLIENTS;
// 1. Запись с фамилией "Зайцев"
SELECT Client_ID, Client_Name, Client_Surname, Sport_ID, Sport_Type, Abon_Cost
FROM CLIENTS_BY_SURNAME
WHERE Client_Surname='Zaycev' ALLOW FILTERING;

SELECT Client_ID, Client_Name, Client_Surname, Sport_ID, Sport_Type, Abon_Cost
FROM CLIENTS_BY_SURNAME
WHERE Client_ID=3;

// 2. Запись с датой '2019-11-12'
USE DATES;
SELECT Reg_ID, Reg_Date, Client_ID, Abon_Cost
FROM REG_BY_DATE
WHERE Reg_Date='2019-11-12';

// 3. Все записи со стоимостью абонемента 100
SELECT Reg_ID, Reg_Date, Client_ID, Abon_Cost
FROM REG_BY_DATE
WHERE Abon_Cost=100 ALLOW FILTERING;

// 4. Стоимость абонемента с 3 разовым посещением
SELECT Abon_Amount, Abon_Cost
FROM ABONEMENT_BY_COST
WHERE Abon_Amount = '3 raza' ALLOW FILTERING;

// 5. Клиенты со спортом Воллейбол
SELECT Client_Name, Client_Surname, Sport_ID, Sport_Type
FROM CLIENTS_BY_ID
WHERE Sport_Type = 'Valleyball' ALLOW FILTERING;