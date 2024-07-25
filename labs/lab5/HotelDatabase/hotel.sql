PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE Staff (
                StaffID INTEGER PRIMARY KEY,
                HotelCode INTEGER,
                FirstName TEXT,
                LastName TEXT,
                DOB DATE,
                Gender TEXT,
                Email TEXT,
                Phone TEXT,
                Password TEXT,
                Position TEXT,
                Salary REAL,
                FOREIGN KEY (HotelCode) REFERENCES Hotel (HotelCode)
                );
INSERT INTO Staff VALUES(1,1,'Bethan','Ramirez',NULL,'M','bramirez@hotel.com',NULL,'$2b$12$r7b.2pj7WfBm3JiHGQsQr.J96CRNoLUafwtCXdLiBW/diI64fCI.C',NULL,NULL);
INSERT INTO Staff VALUES(2,1,'Eoin','Colon',NULL,'M','eoin.colon@hotel.com',NULL,'$2b$12$DnLwxMa21nv5tIl/dldz7uUpLfWzPqYN4fk3ZmGTfU23yXTzOMVP6',NULL,NULL);
INSERT INTO Staff VALUES(3,1,'Pablo','Rivers',NULL,'M','pablo.rivers@hotel.com',NULL,'$2b$12$nyrSDwO1cSMd8VEt4tRhSe71u1mi7zSkFQMMTg/u4gILCFupDwYF6',NULL,NULL);
INSERT INTO Staff VALUES(4,1,'Richard','Gilmore',NULL,'M','richard.gilmore@hotel.com',NULL,'$2b$12$iMtAxDvhkThUugFNAs1erunaBi416zrb0IajY0tBp4e2VinNN3g1S',NULL,NULL);
INSERT INTO Staff VALUES(5,1,'Zahraa','Woodward',NULL,'F','zwoodward@hotel.com',NULL,'$2b$12$hQCcjv31Gantt.i4DzGLGOOkIMhEf8mo.SkLBjV3PFb4KSi9J2euu',NULL,NULL);
INSERT INTO Staff VALUES(6,1,'Abigail','Rivera',NULL,'F','abigail.rivera@hotel.com',NULL,'$2b$12$QnAMdbcx5YBotDfOcXZj8ujhVLwN4KTezSAmphfHTBuGLOZYnrLXG',NULL,NULL);
INSERT INTO Staff VALUES(7,2,'Marco','Clements',NULL,'M','mclements@hotel.com',NULL,'$2b$12$Drs/KX6XP/WIHTBfgazkeO5nqvKIbb/QzwS6IdZnKKydpcHRO9VSq',NULL,NULL);
INSERT INTO Staff VALUES(8,2,'Teresa','Zamora',NULL,'F','tzamora@hotel.com',NULL,'$2b$12$z1OBIUpcXbq.Y3Gs3j1oSOlwaquX1iAvbWf5koa4wjLEyRudRDJxK',NULL,NULL);
INSERT INTO Staff VALUES(9,2,'Leanne','Davies',NULL,'F','ldavies@hotel.com',NULL,'$2b$12$7N8.hEbaVha8da/lKOld6uLpPkal9biNj1Uqent8.1LwrTr345v1W',NULL,NULL);
INSERT INTO Staff VALUES(10,3,'Shakira','Luna',NULL,'F','shakira.luna@hotel.com',NULL,'$2b$12$iigjxuH.sGRfrtEI5xO3iepEYEk3r0gk1DtGtlSmeCMx3dcmZrWI.',NULL,NULL);
CREATE TABLE Room (
                RoomNo INT NOT NULL,
                HotelCode INTEGER NOT NULL,
                RoomType TEXT, PricePerNight REAL, NumBeds INTEGER,
                PRIMARY KEY (HotelCode, RoomNo)
                FOREIGN KEY (HotelCode) REFERENCES Hotel (HotelCode)
                );
INSERT INTO Room VALUES(1,1,'Guest',81.999999999999999998,1);
INSERT INTO Room VALUES(2,1,'Guest',145.0,2);
INSERT INTO Room VALUES(3,1,'Guest',81.999999999999999998,1);
INSERT INTO Room VALUES(4,1,'Office',81.999999999999999998,1);
INSERT INTO Room VALUES(5,1,'Public',81.999999999999999998,1);
INSERT INTO Room VALUES(1,2,'Guest',81.999999999999999998,1);
INSERT INTO Room VALUES(2,2,'Guest',145.0,2);
INSERT INTO Room VALUES(3,2,'Guest',81.999999999999999998,1);
INSERT INTO Room VALUES(4,2,'Office',81.999999999999999998,1);
INSERT INTO Room VALUES(5,2,'Public',81.999999999999999998,1);
CREATE TABLE Guest (
                GuestID INTEGER PRIMARY KEY,
                FirstName TEXT NOT NULL,
                LastName TEXT NOT NULL,
                DOB DATE,
                Gender TEXT,
                Email TEXT NOT NULL,
                Password TEXT NOT NULL,
                Address TEXT,
                Phone TEXT
                );
INSERT INTO Guest VALUES(1,'Irene','Miles',NULL,'F','irene.miles@gmail.com','irenemiles',NULL,NULL);
INSERT INTO Guest VALUES(2,'Phoebe','Mayer',NULL,'F','phoebe.mayer@gmail.com','phoebemayer',NULL,NULL);
INSERT INTO Guest VALUES(3,'Cara','Leblanc',NULL,'F','cara.leblanc@gmail.com','caraleblanc',NULL,NULL);
INSERT INTO Guest VALUES(4,'Bonnie','Webb',NULL,'F','bonnie.webb@gmail.com','bonniewebb',NULL,NULL);
INSERT INTO Guest VALUES(5,'Earle','Khan',NULL,'M','earle.khan@gmail.com','earlekhan',NULL,NULL);
INSERT INTO Guest VALUES(6,'Ruben','Reeves',NULL,'M','ruben.reeves@gmail.com','rubenreeves',NULL,NULL);
INSERT INTO Guest VALUES(7,'Brian','Black',NULL,'M','brian.black@gmail.com','brianblack',NULL,NULL);
INSERT INTO Guest VALUES(8,'Antoinette','Trujillo',NULL,'F','antoinette.trujillo@gmail.com','antoinettetrujillo',NULL,NULL);
INSERT INTO Guest VALUES(9,'Kristina','Clements',NULL,'F','kristina.clements@gmail.com','kristinaclements',NULL,NULL);
INSERT INTO Guest VALUES(10,'David','Oconner',NULL,'M','david.oconner@gmail.com','davidoconner',NULL,NULL);
INSERT INTO Guest VALUES(11,'Zohraan','Badar',NULL,NULL,'z1badar@torontomu.ca','abdurr_6621*',NULL,NULL);
CREATE TABLE Resource (
                ResourceID INTEGER PRIMARY KEY,
                HotelCode INTEGER NOT NULL,
                Name TEXT NOT NULL,
                Quantity TEXT,
                FOREIGN KEY (HotelCode) REFERENCES Hotel (HotelCode)
                );
INSERT INTO Resource VALUES(1,1,'Bread','4');
INSERT INTO Resource VALUES(2,1,'Coffee','20');
INSERT INTO Resource VALUES(3,1,'Egg','120');
INSERT INTO Resource VALUES(4,1,'Lettuce','50');
INSERT INTO Resource VALUES(5,1,'Hand-soap','34');
INSERT INTO Resource VALUES(6,1,'Dish-soap','22');
INSERT INTO Resource VALUES(7,2,'Vacuum','12');
INSERT INTO Resource VALUES(8,2,'Pillow','40');
INSERT INTO Resource VALUES(9,3,'Bed-sheet','14');
INSERT INTO Resource VALUES(10,3,'Walkie-Talkie','15');
CREATE TABLE Expense (
                ExpenseID INTEGER PRIMARY KEY,
                HotelCode INTEGER NOT NULL,
                Name TEXT NOT NULL,
                Amount REAL NOT NULL,
                FOREIGN KEY (HotelCode) REFERENCES Hotel (HotelCode)
                );
INSERT INTO Expense VALUES(1,1,'Resupply bread',50.0);
INSERT INTO Expense VALUES(2,1,'Resupply coffee',60.0);
INSERT INTO Expense VALUES(3,1,'Guest speaker event',150.0);
INSERT INTO Expense VALUES(4,2,'Resupply broom',24.0);
INSERT INTO Expense VALUES(5,2,'Resupply towel',70.0);
INSERT INTO Expense VALUES(6,2,'Resupply carrot',45.0);
INSERT INTO Expense VALUES(7,3,'Resupply bed sheet',76.999999999999999998);
INSERT INTO Expense VALUES(8,3,'Resupply back-up keys',12.0);
INSERT INTO Expense VALUES(9,3,'Resupply back-up monitors',400.0);
INSERT INTO Expense VALUES(10,3,'Cisco network testing service',120.0);
CREATE TABLE Booking (
                BookingID INTEGER PRIMARY KEY,
                HotelCode INTEGER NOT NULL,
                RoomNo INTEGER NOT NULL,
                GuestID INTEGER NOT NULL,
                BookingDateTime DATETIME NOT NULL,
                CheckinDateTime DATETIME NOT NULL,
                CheckoutDateTime DATETIME NOT NULL,
                NumAdults INTEGER NOT NULL,
                FOREIGN KEY (HotelCode) REFERENCES Hotel (HotelCode),
                FOREIGN KEY (RoomNo) REFERENCES Room (RoomNo),
                FOREIGN KEY (GuestID) REFERENCES Guest (GuestID)
                );
INSERT INTO Booking VALUES(1,1,2,3,'2024-04-10 12:00:00','2024-05-01 14:00:00','2024-05-05 10:00:00',2);
INSERT INTO Booking VALUES(2,1,1,1,'2024-03-06 16:30:22','2024-03-06 16:30:22','2024-03-08 16:30:22',1);
INSERT INTO Booking VALUES(3,1,2,2,'2024-03-06 16:30:22','2024-03-06 16:30:22','2024-03-09 16:30:22',2);
INSERT INTO Booking VALUES(4,1,3,3,'2024-03-06 16:30:22','2024-03-06 16:30:22','2024-03-10 16:30:22',1);
INSERT INTO Booking VALUES(5,1,4,4,'2024-03-06 16:30:22','2024-03-06 16:30:22','2024-03-11 16:30:22',1);
INSERT INTO Booking VALUES(6,1,5,5,'2024-03-06 16:30:22','2024-03-06 16:30:22','2024-03-12 16:30:22',1);
INSERT INTO Booking VALUES(7,2,1,6,'2024-03-06 16:30:22','2024-03-06 16:30:22','2024-03-13 16:30:22',2);
INSERT INTO Booking VALUES(8,2,2,7,'2024-03-06 16:30:22','2024-03-06 16:30:22','2024-03-14 16:30:22',1);
INSERT INTO Booking VALUES(9,2,3,8,'2024-03-06 16:30:22','2024-03-06 16:30:22','2024-03-15 16:30:22',1);
INSERT INTO Booking VALUES(10,2,4,9,'2024-03-06 16:30:22','2024-03-06 16:30:22','2024-03-16 16:30:22',2);
INSERT INTO Booking VALUES(11,2,5,10,'2024-03-06 16:30:22','2024-03-06 16:30:22','2024-03-17 16:30:22',1);
INSERT INTO Booking VALUES(12,2,2,11,'2024-03-26 17:33:02','2024-03-26 17:15:00','2024-03-31 17:15:00',2);
CREATE TABLE Bill (
                InvoiceNum INTEGER PRIMARY KEY,
                BookingID INTEGER NOT NULL,
                Amount REAL NOT NULL,
                PaidDate DATE,
                PaymentMode TEXT,
                ExpireDate DATE NOT NULL,
                FOREIGN KEY (BookingID) REFERENCES Booking (BookingID)
                );
INSERT INTO Bill VALUES(1,1,100.0,'2024-04-10','Debit','2024-04-15');
INSERT INTO Bill VALUES(2,2,150.0,'2024-04-10','Debit','2024-04-15');
INSERT INTO Bill VALUES(3,3,120.0,'2024-04-12','Debit','2024-04-17');
INSERT INTO Bill VALUES(4,4,80.0,'2024-04-10','Debit','2024-04-15');
INSERT INTO Bill VALUES(5,5,200.0,'2024-04-10','Debit','2024-04-15');
INSERT INTO Bill VALUES(6,6,179.99999999999999999,'2024-04-12','Debit','2024-04-17');
INSERT INTO Bill VALUES(7,7,90.0,'2024-04-10','Debit','2024-04-15');
INSERT INTO Bill VALUES(8,8,110.0,'2024-04-10','Debit','2024-04-15');
INSERT INTO Bill VALUES(9,9,129.99999999999999999,'2024-04-12','Debit','2024-04-17');
INSERT INTO Bill VALUES(10,10,95.0,'2024-04-12','Debit','2024-04-17');
CREATE TABLE Service (
                ID INTEGER PRIMARY KEY,
                BillNum INTEGER NOT NULL,
                Name TEXT NOT NULL,
                Cost REAL,
                Description TEXT,
                FOREIGN KEY (BillNum) REFERENCES Bill (InvoiceNum)
                );
INSERT INTO Service VALUES(1,1,'Room Service',25.0,'Food and drinks delivered to the room');
INSERT INTO Service VALUES(2,1,'WiFi Access',10.0,'High-speed internet access');
INSERT INTO Service VALUES(3,2,'Room Service',20.0,'Food and drinks delivered to the room');
INSERT INTO Service VALUES(4,3,'Laundry',15.0,'Cleaning and ironing of clothes');
INSERT INTO Service VALUES(5,3,'Room Service',30.0,'Food and drinks delivered to the room');
INSERT INTO Service VALUES(6,4,'WiFi Access',12.0,'High-speed internet access');
INSERT INTO Service VALUES(7,5,'Laundry',17.999999999999999999,'Cleaning and ironing of clothes');
INSERT INTO Service VALUES(8,6,'Room Service',22.0,'Food and drinks delivered to the room');
INSERT INTO Service VALUES(9,7,'WiFi Access',8.0,'High-speed internet access');
INSERT INTO Service VALUES(10,8,'Laundry',20.0,'Cleaning and ironing of clothes');
CREATE TABLE IF NOT EXISTS "Hotel" (
    HotelCode INTEGER PRIMARY KEY,
    Address TEXT,
    Postcode TEXT,
    City TEXT,
    Country TEXT,
    NumRooms INTEGER,
    DeskPhone TEXT,
    ManagementPhone TEXT,
    StaffCount INTEGER,
    EstablishmentDate DATE
, Name TEXT);
INSERT INTO Hotel VALUES(1,'4944 Germantown Ave, Philadelphia, Pennsylvania, United States','PA 19144','Philadelphia','USA',345,'+12673686167',NULL,NULL,NULL,'Germantown Hotel');
INSERT INTO Hotel VALUES(2,'874-A Weston Rd, York, ON','M6N 3R6','York','Canada',455,'+14162435320',NULL,NULL,NULL,'Weston Hotel');
INSERT INTO Hotel VALUES(3,'41 Lebovic Ave Unit A110, Scarborough, ON','M1L 0H2','Scarborough','Canada',277,'+14162859973',NULL,NULL,NULL,'Scarborough Hotel');
INSERT INTO Hotel VALUES(4,'1172 Walkley Rd, Ottawa, ON','K1V 2P7','Ottawa','Canada',510,'+16135239600',NULL,NULL,NULL,'Ottawa Hotel');
INSERT INTO Hotel VALUES(5,'2 Whitehall Ct, London, United Kingdom','SW1A 2EJ','London','United Kingdom',332,'+442075235062',NULL,NULL,NULL,'London Hotel');
INSERT INTO Hotel VALUES(6,'4 Woodcock St, Birmingham, United Kingdom','B7 4BL','Birmingham','United Kingdom',510,'+441218206000',NULL,NULL,NULL,'Birmingham Hotel');
INSERT INTO Hotel VALUES(7,'19 Loughborough Rd, Leicester, United Kingdom','LE4 5LJ','Leicester','United Kingdom',82,'+441162682626',NULL,NULL,NULL,'Leicester Hotel');
INSERT INTO Hotel VALUES(8,'4289, Al Hajlah, Makkah, Saudi Arabia','24231','Makkah','Saudi Arabia',602,'+966125768888',NULL,NULL,NULL,'Makkah Hotel');
INSERT INTO Hotel VALUES(9,'JPRC+PF3, Omar Almukhtar St, Al Amal, Riyadh, Saudi Arabia','11561','Riyadh','Saudi Arabia',188,'+966114024121',NULL,NULL,NULL,'Riyadh Hotel');
INSERT INTO Hotel VALUES(10,'Mutlaq Abbas Munawir St, Kuwait City, Kuwait','','Kuwait City','Kuwait',734,'+96522262000',NULL,NULL,NULL,'Kuwait City Hotel');
INSERT INTO Hotel VALUES(11,'Al Mahatta - Al Qasimia - Sharjah - United Arab Emirates','89XR+V9XAl','Sharjah','United Arab Emirates',221,'+97165066222',NULL,NULL,NULL,'Sharjah Hotel');
CREATE UNIQUE INDEX idx_unique_name ON Hotel (Name);
COMMIT;
