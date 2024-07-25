import sqlite3
import subprocess

DB_FILE = 'hotel.db'
DUMP_FILE = 'hotel_dump.sql'


def create_dump():
    # Use subprocess to execute the SQLite .dump command
    subprocess.run(['sqlite3', DB_FILE, '.dump'], stdout=open(DUMP_FILE, 'w'))


def connect():
    conn = sqlite3.connect(DB_FILE)
    conn.execute("PRAGMA foreign_keys = ON")

    return conn


def create_hotel(conn):
    cur = conn.cursor()

    cur.execute("""CREATE TABLE IF NOT EXISTS Hotel (
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
                )""")


def create_room(conn):
    cur = conn.cursor()

    cur.execute("""CREATE TABLE IF NOT EXISTS Room (
                RoomNo INTEGER PRIMARY KEY,
                RoomType TEXT,
                HotelCode INTEGER,
                Occupancy INTEGER,
                Services TEXT,
                FOREIGN KEY (HotelCode) REFERENCES Hotel (HotelCode)
                )""")
    

def create_staff(conn):
    cur = conn.cursor()

    cur.execute("""CREATE TABLE IF NOT EXISTS Staff (
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
                )""")
    

def create_guest(conn):
    cur = conn.cursor()

    cur.execute("""CREATE TABLE IF NOT EXISTS Guest (
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
                )""")
    

def create_resource(conn):
    cur = conn.cursor()

    cur.execute("""CREATE TABLE IF NOT EXISTS Resource (
                ResourceID INTEGER PRIMARY KEY,
                HotelCode INTEGER,
                FOREIGN KEY (HotelCode) REFERENCES Hotel (HotelCode)
                )""")
    

def create_expense(conn):
    cur = conn.cursor()

    cur.execute("""CREATE TABLE IF NOT EXISTS Expense (
                ExpenseID INTEGER PRIMARY KEY,
                HotelCode INTEGER,
                FOREIGN KEY (HotelCode) REFERENCES Hotel (HotelCode)
                )""")


def create_booking(conn):
    cur = conn.cursor()

    cur.execute("""CREATE TABLE IF NOT EXISTS Booking (
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
                )""")
    

def create_bill(conn):
    cur = conn.cursor()

    cur.execute("""CREATE TABLE IF NOT EXISTS Bill (
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
                )""")
    

def main():
    conn = connect()
    create_hotel(conn=conn)
    create_room(conn=conn)
    create_staff(conn=conn)
    create_guest(conn=conn)
    create_resource(conn=conn)
    create_expense(conn=conn)
    create_booking(conn=conn)
    create_bill(conn=conn)
    create_dump()
    conn.commit()
    conn.close()


if __name__ == "__main__":
    main()
