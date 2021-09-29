MATCH (n) DETACH DELETE n;

//Clients
CREATE
(Client1:client {pol:'female', name:'Elena', surname:'Tarablina'}),
(Client2:client {pol:'male', name:'Vyacheslav', surname:'Zaycev'}),
(Client3:client {pol:'male', name:'Sergey', surname:'Gorbachev'}),
(Client4:client {pol:'male', name:'Sergey', surname:'Svetlakov'}),
(Client5:client {pol:'male', name:'Ilya', surname:'Bykov'}),
(Client6:client {pol:'female', name:'Svetlana', surname:'Bykova'}),
(Client7:client {pol:'male', name:'Roman', surname:'Biryukov'}),
(Client8:client {pol:'female', name:'Natalya', surname:'Vasilyeva'}),
(Client9:client {pol:'male', name:'Nikolay', surname:'Luzhkov'}),
(Client10:client {pol:'male', name:'Sergey', surname:'Titov'})

//Trainers
CREATE
(Trainer1:trainer {name:'Aleksey', surname:'Ivanov'}),
(Trainer2:trainer {name:'Valentina', surname:'Rybkina'}),
(Trainer3:trainer {name:'Ivan', surname:'Korolev'}),
(Trainer4:trainer {name:'Alexander', surname:'Pronin'}),
(Trainer5:trainer {name:'Olga', surname:'Malkina'}),
(Trainer6:trainer {name:'Mykhail', surname:'Strelov'}),
(Trainer7:trainer {name:'Ivan', surname:'Lebedev'}),
(Trainer8:trainer {name:'Alexander', surname:'Kurpatov'}),
(Trainer9:trainer {name:'Dmitriy', surname:'Baranov'}),
(Trainer10:trainer {name:'Inna', surname:'Popova'})

//Abonements
CREATE
(Abon1:abon {amount:'1 retry in week', cost:100}),
(Abon2:abon {amount:'2 retry in week', cost:250}),
(Abon3:abon {amount:'3 retry in week', cost:300}),
(Abon4:abon {amount:'4 retry in week', cost:500}),
(Abon5:abon {amount:'5 retry in week', cost:650})

//Sports
CREATE
(Sport1:sport {type:'Valleyball'}),
(Sport2:sport {type:'Baseball'}),
(Sport3:sport {type:'Basketball'}),
(Sport4:sport {type:'Football'}),
(Sport5:sport {type:'Swimming'})

//Relations Client to Trainer
CREATE
(Client1)-[:TRAINING {amountVisits:1}]->(Trainer1),
(Client2)-[:TRAINING {amountVisits:0}]->(Trainer5),
(Client3)-[:TRAINING {amountVisits:3}]->(Trainer3),
(Client4)-[:TRAINING {amountVisits:2}]->(Trainer4),
(Client5)-[:TRAINING {amountVisits:3}]->(Trainer8),
(Client6)-[:TRAINING {amountVisits:4}]->(Trainer9),
(Client7)-[:TRAINING {amountVisits:3}]->(Trainer6),
(Client8)-[:TRAINING {amountVisits:2}]->(Trainer10),
(Client9)-[:TRAINING {amountVisits:1}]->(Trainer3),
(Client10)-[:TRAINING {amountVisits:5}]->(Trainer7)

//Relations Client to Abonement
CREATE
(Client1)-[:BYING]->(Abon2),
(Client2)-[:BYING]->(Abon3),
(Client3)-[:BYING]->(Abon1),
(Client4)-[:BYING]->(Abon4),
(Client5)-[:BYING]->(Abon5),
(Client6)-[:BYING]->(Abon3),
(Client7)-[:BYING]->(Abon2),
(Client8)-[:BYING]->(Abon1),
(Client9)-[:BYING]->(Abon1),
(Client10)-[:BYING]->(Abon1)

//Relations Client to Sport
CREATE
(Client1)-[:SPORT]->(Sport1),
(Client2)-[:SPORT]->(Sport3),
(Client3)-[:SPORT]->(Sport2),
(Client4)-[:SPORT]->(Sport2),
(Client5)-[:SPORT]->(Sport4),
(Client6)-[:SPORT]->(Sport5),
(Client7)-[:SPORT]->(Sport3),
(Client8)-[:SPORT]->(Sport5),
(Client9)-[:SPORT]->(Sport2),
(Client10)-[:SPORT]->(Sport4)

//Relations Trainer to Sport
CREATE
(Trainer1)-[:SPORTTR]->(Sport1),
(Trainer2)-[:SPORTTR]->(Sport1),
(Trainer3)-[:SPORTTR]->(Sport2),
(Trainer4)-[:SPORTTR]->(Sport2),
(Trainer5)-[:SPORTTR]->(Sport3),
(Trainer6)-[:SPORTTR]->(Sport3),
(Trainer7)-[:SPORTTR]->(Sport4),
(Trainer8)-[:SPORTTR]->(Sport4),
(Trainer9)-[:SPORTTR]->(Sport5),
(Trainer10)-[:SPORTTR]->(Sport5);