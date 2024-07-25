PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE Hotel (
                HotelCode INTEGER PRIMARY KEY,
                Name TEXT,
                Address TEXT,
                Postcode TEXT,
                City TEXT,
                Country TEXT,
                NumRooms INTEGER,
                DeskPhone TEXT,
                ManagementPhone TEXT,
                StaffCount INTEGER,
                EstablishmentDate DATE
                );
CREATE TABLE Room (
                RoomNo INTEGER PRIMARY KEY,
                RoomType TEXT,
                HotelCode INTEGER,
                Occupancy INTEGER,
                Services TEXT,
                FOREIGN KEY (HotelCode) REFERENCES Hotel (HotelCode)
                );
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
CREATE TABLE Guest (
                GuestID INTEGER PRIMARY KEY,
                BookingID INTEGER,
                HotelCode INTEGER,
                GuestTitle TEXT,
                FirstName TEXT,
                LastName TEXT,
                DOB DATE,
                Gender TEXT,
                Email TEXT,
                Phone TEXT,
                Password TEXT,
                PassportNo TEXT,
                Address TEXT,
                City TEXT,
                Country TEXT,
                FOREIGN KEY (BookingID) REFERENCES Booking (BookingID),
                FOREIGN KEY (HotelCode) REFERENCES Hotel (HotelCode)
                );
CREATE TABLE Resource (
                ResourceID INTEGER PRIMARY KEY,
                HotelCode INTEGER,
                FOREIGN KEY (HotelCode) REFERENCES Hotel (HotelCode)
                );
CREATE TABLE Expense (
                ExpenseID INTEGER PRIMARY KEY,
                HotelCode INTEGER,
                FOREIGN KEY (HotelCode) REFERENCES Hotel (HotelCode)
                );
CREATE TABLE Booking (
                BookingID INTEGER PRIMARY KEY,
                HotelCode INTEGER,
                RoomNo INTEGER,
                GuestID INTEGER,
                BookingDateTime DATETIME,
                CheckinDateTime DATETIME,
                CheckoutDateTime DATETIME,
                NumAdults INTEGER,
                FOREIGN KEY (HotelCode) REFERENCES Hotel (HotelCode),
                FOREIGN KEY (RoomNo) REFERENCES Room (RoomNo),
                FOREIGN KEY (GuestID) REFERENCES Guest (GuestID)
                );
CREATE TABLE Bill (
                InvoiceNum INTEGER PRIMARY KEY,
                BookingID INTEGER,
                GuestID INTEGER,
                RoomCharge REAL,
                Services TEXT,
                PaymentDate DATE,
                PaymentMode TEXT,
                ExpireDate DATE,
                ChequeNo TEXT,
                Staff TEXT,
                FOREIGN KEY (BookingID) REFERENCES Booking (BookingID),
                FOREIGN KEY (GuestID) REFERENCES Guest (GuestID)
                );
COMMIT;
