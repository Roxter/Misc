# MongoDB

Проекты по NoSQL на СУБД MongoDB. Выполняется на MongoDB 4.2.16 x64.
СУБД MongoDB можно скачать по ссылке https://fastdl.mongodb.org/win32/mongodb-win32-x86_64-2012plus-4.2.16-signed.msi
После установки MongoDB запустить файлы Start_Server.bat, Gym.bat, Univer.bat.

Gym - База с данными по клиентам спортзала, состоящая из коллекции Clients.
Коллекция Clients состоит из полей:
	имя (first_name),
	фамилия (last_name),
	вид спорта (sport_type),
	пол (pol),
	тип абонемента (abon_type),
	цена абонемента (abon_price),
	контактный номер (phone).

Univer - База с данными по преподавателям и студентам университета, состоящая из коллекций Guy, Course, Sport, Country
Коллекция Guy состоит из полей:
	имя (name),
	фамилия (surname),
	номер курса (course),
	вид спорта (sports),
	посещенные страны (visited) [Название страны(country), Время пребывания(timesAmount)].
Коллекция Course состоит из полей:
	название (name),
	длительность (duration),
	студенты курса (students),
	преподаватели курса (teachers).
Коллекция Sport состоит из полей:
	вид спорта (name).
Коллекция Country состоит из полей:
	название (name),
	столица (capital),
	численность населения (population).

Запросы к базам хранятся в запускаемых файлах