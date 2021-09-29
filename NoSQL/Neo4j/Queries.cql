//Вся база
MATCH (n) RETURN n;

//Все клиенты мужского пола
MATCH (c:client) WHERE c.pol='male' RETURN c.name+' '+c.surname AS Males;

//Все клиенты с именем Сергей
MATCH (c:client) WHERE c.name='Sergey' RETURN count(c.name) AS Count_clients_with_SergeyName;

//Клиенты в соответствии с тренерами и видами спорта
MATCH (c:client)-[:TRAINING]->(t:trainer)-[:SPORTTR]->(s:sport) RETURN c.name+' '+c.surname AS NameClient, t.name+' '+t.surname AS NameTrainer, s.type AS SportType;

//Все клиенты, занимающиеся Баскетболом и Футболом (поиск через узлы тренеров)
MATCH (c:client)-[:TRAINING]->(t:trainer)-[:SPORTTR]->(s:sport) WHERE s.type IN ['Baseball', 'Football'] RETURN c.name+' '+c.surname AS NameClient, t.name+' '+t.surname AS NameTrainer, s.type AS SportType;

//Клиенты, посетившие тренера 3 раза
MATCH (c:client)-[tr:TRAINING]->(t:trainer)  WHERE tr.amountVisits=3 RETURN c.name+' '+c.surname AS NameClient, t.name+' '+t.surname AS NameTrainer, tr.amountVisits AS AmountVisits;