import java.io.Console;
import java.sql.*;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Scanner;

import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

public class HotelDatabase {

    private static final String DB_FILE = "hotel.db";
    private static final String URL = "jdbc:sqlite:" + DB_FILE;
    private static final String dateTimeFormat = "yyyy-MM-dd HH:mm:ss";

    private static Console input; // Create a Scanner object
    private static Connection conn;

    private static String helpMessage = """
            1 - get guest by hotel name
            2 - get rooms below price
            3 - get resources
            4 - get guests at a given hotel by datetime
            5 - get guests by check-out date
            6 - get guests by check-in date
            7 - book room
            8 - get guests by booking date
            9 - get staff by firstname
            10 - get most popular service
            """;

    public static void main(String[] args) {

        input = System.console();
        String command;
        System.out.println("What query would you like to execute?\n(Type h to see list of available queires...)\n");

        while (true) {
            try {
                command = input.readLine("You> ");
                if (command.equals("q")) {
                    System.out.println("bye.");
                    break;
                } else if (command.equals("h")) {
                    System.out.println(helpMessage);
                } else if (command.isBlank()) {
                    continue;
                } else {
                    Class.forName("org.sqlite.JDBC");
                    conn = DriverManager.getConnection(URL);

                    if (command.equals("1")) {
                        String hotel = input.readLine("\nHotel name: ");
                        getGuestsByHotel(conn, hotel);
                    } else if (command.equals("2")) {
                        String hotel = input.readLine("Hotel name: ");
                        int maxPrice = Integer.parseInt(input.readLine("Max price: "));
                        getRoomsBelowPrice(conn, hotel, maxPrice);
                    } else if (command.equals("3")) {
                        getResources(conn);
                    } else if (command.equals("4")) {
                        String hotel = input.readLine("Hotel name: ");
                        String datetime = input.readLine("Date and Time (yyyy-MM-dd HH:mm:ss): ");
                        getGuestsAtHotelByDateTime(conn, hotel, datetime);
                    } else if (command.equals("5")) {
                        String hotel = input.readLine("Hotel name: ");
                        String dateString = input.readLine("Check-out date (yyyy-MM-dd): ");
                        getGuestsByCheckoutDate(conn, hotel, dateString);
                    } else if (command.equals("6")) {
                        String hotel = input.readLine("Hotel name: ");
                        String dateString = input.readLine("Check-in date (yyyy-MM-dd): ");
                        getGuestsByCheckinDate(conn, hotel, dateString);
                    } else if (command.equals("7")) {
                        bookRoom(conn);
                    } else if (command.equals("8")) {
                        String hotel = input.readLine("Hotel name: ");
                        String dateString = input.readLine("Booking date (yyyy-MM-dd): ");
                        getGuestsByBookingDate(conn, hotel, dateString);
                    } else if (command.equals("9")) {
                        String hotel = input.readLine("Hotel name: ");
                        String firstName = input.readLine("First name: ");
                        getStaffByFirstName(conn, hotel, firstName);
                    } else if (command.equals("10")) {
                        String hotel = input.readLine("Hotel name: ");
                        getMostPopularService(conn, hotel);
                    } else {
                        System.out.println(command + " is not a valid command.");
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                // rollbackTransaction(conn);
            } catch (ClassNotFoundException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            } finally {
                closeConnection(conn);
            }
        }
    }

    // private static void rollbackTransaction(Connection conn) {
    //     try {
    //         if (conn != null)
    //             conn.rollback(); // Rollback the transaction in case of an error
    //     } catch (SQLException e) {
    //         e.printStackTrace();
    //     }
    // }

    private static void closeConnection(Connection conn) {
        try {
            if (conn != null)
                conn.close(); // Close the connection
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private static void getGuestsByHotel(Connection conn, String hotel) throws SQLException {
        String query = "SELECT DISTINCT G.FirstName, G.LastName " +
                "FROM Guest G " +
                "JOIN Booking B ON G.GuestID = B.GuestID " +
                "JOIN Hotel H ON B.HotelCode = H.HotelCode " +
                "WHERE H.Name = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, hotel);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                System.out.println(rs.getString("FirstName") + " " + rs.getString("LastName"));
            }
        }
    }

    private static void getRoomsBelowPrice(Connection conn, String hotel, double maxPrice) throws SQLException {
        String query = "SELECT R.RoomNo, R.PricePerNight " +
                "FROM Room R " +
                "JOIN Hotel H ON R.HotelCode = H.HotelCode " +
                "WHERE H.Name = ? AND R.PricePerNight < ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, hotel);
            stmt.setDouble(2, maxPrice);
            ResultSet rs = stmt.executeQuery();
            if (!rs.isBeforeFirst()) {
                System.out.println("No rooms found below the specified price.");
            } else {
                System.out.println("Rooms below the specified price:");
                while (rs.next()) {
                    System.out.println(
                            "RoomNo: " + rs.getInt("RoomNo") + ", PricePerNight: " + rs.getDouble("PricePerNight"));
                }
            }
        }
    }

    private static void getHotelWithMostOccupants(Connection conn) throws SQLException {
        String query = "SELECT H.HotelCode, H.Name, SUM(B.NumAdults) as TotalOccupants " +
                "FROM Hotel H " +
                "LEFT JOIN Booking B ON H.HotelCode = B.HotelCode " +
                "GROUP BY H.HotelCode, H.Name " +
                "ORDER BY TotalOccupants DESC";
        try (Statement stmt = conn.createStatement()) {
            ResultSet rs = stmt.executeQuery(query);
            if (!rs.isBeforeFirst()) {
                System.out.println("No hotels found.");
            } else {
                System.out.println("Hotels ordered by total occupants (descending):");
                while (rs.next()) {
                    System.out.println("HotelCode: " + rs.getInt("HotelCode") +
                            ", Name: " + rs.getString("Name") +
                            ", TotalOccupants: " + rs.getInt("TotalOccupants"));
                }
            }
        }
    }

    private static void getResources(Connection conn) throws SQLException {
        String query = "SELECT R.ResourceID, R.Name, R.Quantity " +
                "FROM Resource R " +
                "ORDER BY R.Quantity DESC";
        try (Statement stmt = conn.createStatement()) {
            ResultSet rs = stmt.executeQuery(query);
            if (!rs.isBeforeFirst()) {
                System.out.println("No resources found.");
            } else {
                System.out.println("Resources ordered by quantity (descending):");
                while (rs.next()) {
                    System.out.println("ResourceID: " + rs.getInt("ResourceID") +
                            ", Name: " + rs.getString("Name") +
                            ", Quantity: " + rs.getString("Quantity"));
                }
            }
        }
    }

    private static void getGuestsAtHotelByDateTime(Connection conn, String hotel, String datetime) throws SQLException {
        // String now = new
        // java.sql.Date(Calendar.getInstance().getTime().getTime()).toString();
        String query = "SELECT DISTINCT G.FirstName, G.LastName, B.CheckinDateTime, B.CheckoutDateTime " +
                "FROM Guest G " +
                "JOIN Booking B ON G.GuestID = B.GuestID " +
                "JOIN Hotel H ON B.HotelCode = H.HotelCode " +
                "WHERE H.Name = ? AND B.CheckinDateTime <= ? AND B.CheckoutDateTime > ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, hotel);
            stmt.setString(2, datetime);
            stmt.setString(3, datetime);
            ResultSet rs = stmt.executeQuery();
            if (!rs.isBeforeFirst()) {
                System.out.println("No guests currently checked in at " + hotel + ".");
            } else {
                System.out.println("Guests currently checked in at " + hotel + ":");
                while (rs.next()) {
                    System.out.println("Name: " + rs.getString("FirstName") + " " + rs.getString("LastName") +
                            ", CheckinDateTime: " + rs.getString("CheckinDateTime") +
                            ", CheckoutDateTime: " + rs.getString("CheckoutDateTime"));
                }
            }
        }
    }

    private static void getGuestsByCheckoutDate(Connection conn, String hotel, String date) throws SQLException {
        String query = "SELECT DISTINCT G.FirstName, G.LastName, B.CheckoutDateTime " +
                "FROM Guest G " +
                "JOIN Booking B ON G.GuestID = B.GuestID " +
                "JOIN Hotel H ON B.HotelCode = H.HotelCode " +
                "WHERE H.Name = ? AND DATE(B.CheckoutDateTime) = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, hotel);
            stmt.setString(2, date);
            ResultSet rs = stmt.executeQuery();
            if (!rs.isBeforeFirst()) {
                System.out.println("No guests checking out on " + date + " at " + hotel + ".");
            } else {
                System.out.println("Guests checking out on " + date + " at " + hotel + ":");
                while (rs.next()) {
                    System.out.println("Name: " + rs.getString("FirstName") + " " + rs.getString("LastName") +
                            ", CheckoutDateTime: " + rs.getString("CheckoutDateTime"));
                }
            }
        }
    }

    private static void getGuestsByCheckinDate(Connection conn, String hotel, String date) throws SQLException {
        String query = "SELECT DISTINCT G.FirstName, G.LastName, B.CheckinDateTime " +
                "FROM Guest G " +
                "JOIN Booking B ON G.GuestID = B.GuestID " +
                "JOIN Hotel H ON B.HotelCode = H.HotelCode " +
                "WHERE H.Name = ? AND DATE(B.CheckinDateTime) = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, hotel);
            stmt.setString(2, date);
            ResultSet rs = stmt.executeQuery();
            if (!rs.isBeforeFirst()) {
                System.out.println("No guests checking in on " + date + " at " + hotel + ".");
            } else {
                System.out.println("Guests checking in on " + date + " at " + hotel + ":");
                while (rs.next()) {
                    System.out.println("Name: " + rs.getString("FirstName") + " " + rs.getString("LastName") +
                            ", CheckinDateTime: " + rs.getString("CheckinDateTime"));
                }
            }
        }
    }

    private static void printRooms(ArrayList<Integer> rooms) {
        for (int room : rooms) {
            System.out.println(room);
        }
    }

    private static String getCurrentDate() {
        DateTime now = new DateTime();
        DateTimeFormatter formatter = DateTimeFormat.forPattern(dateTimeFormat);
        return formatter.print(now);
    }

    private static void bookRoom(Connection conn) throws SQLException {
        String guestQuery = "SELECT GuestID FROM Guest WHERE Email = ?";

        // Guest walks into hotel/guest uses the application
        Console input = System.console(); // Create a Scanner object
        System.out.println("What is the email of the guest?");
        String email = input.readLine("Email: ");

        int GuestID;

        // Retrieve GuestID
        try (PreparedStatement pstmt = conn.prepareStatement(guestQuery)) {
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                GuestID = rs.getInt("GuestID");
            } else {
                System.out.println("\nLooks like this guest does not have an account...");
                String firstName = input.readLine("Firstname: ");
                String lastName = input.readLine("Lastname: ");
                char[] password = input.readPassword("Password: ");
                newGuest(conn, firstName, lastName, email, new String(password));
                rs = pstmt.executeQuery();
                GuestID = rs.getInt("GuestID");
            }
        }
        // Get hotelCode
        String hotel = input.readLine("Hotel name: ");
        int hotelCode = getHotelCodeByName(conn, hotel);
        if (hotelCode != -1) {
            // Book room
            try {
                String bookingDateTime = getCurrentDate();

                System.out.println("What is the check-in and check-out time?");
                String checkIn = input.readLine("Check-in time (yyyy-MM-dd HH:mm:ss): ");
                String checkOut = input.readLine("Check-out time (yyyy-MM-dd HH:mm:ss): ");
                int NumAdults = Integer.parseInt(input.readLine("# of adults: "));

                // Get available RoomNo's
                @SuppressWarnings("unchecked")
                ArrayList<Integer> rooms = getAvailableRoomNo(conn, hotelCode, checkIn, checkOut);
                System.out.println("Available rooms");
                printRooms(rooms);

                int roomNo = Integer.parseInt(input.readLine("Room number: "));
                while (!rooms.contains(roomNo)) {
                    System.out.println("Room is not available. Please select a room from the avaialble rooms below.");
                    printRooms(rooms);
                    roomNo = Integer.parseInt(input.readLine("Room nsumber: "));
                }

                newBooking(conn, hotelCode, roomNo, GuestID, bookingDateTime, checkIn, checkOut, NumAdults);
            } finally {
            }
        }
    }

    private static void getGuestsByBookingDate(Connection conn, String hotel, String date) throws SQLException {
        String query = "SELECT DISTINCT G.FirstName, G.LastName, B.BookingDateTime " +
                "FROM Guest G " +
                "JOIN Booking B ON G.GuestID = B.GuestID " +
                "JOIN Hotel H ON B.HotelCode = H.HotelCode " +
                "WHERE H.Name = ? AND DATE(B.BookingDateTime) = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, hotel);
            stmt.setString(2, date);
            ResultSet rs = stmt.executeQuery();
            if (!rs.isBeforeFirst()) {
                System.out.println("No guests booking on " + date + " at " + hotel + ".");
            } else {
                System.out.println("Guests booking on " + date + " at " + hotel + ":");
                while (rs.next()) {
                    System.out.println("Name: " + rs.getString("FirstName") + " " + rs.getString("LastName") +
                            ", BookingDateTime: " + rs.getString("BookingDateTime"));
                }
            }
        }
    }

    private static void getStaffByFirstName(Connection conn, String hotel, String firstname) throws SQLException {
        String query = "SELECT FirstName, LastName " +
                "FROM Staff " +
                "JOIN Hotel ON Staff.HotelCode = Hotel.HotelCode " +
                "WHERE Hotel.Name = ? AND Staff.FirstName LIKE ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, hotel);
            stmt.setString(2, firstname + "%");
            ResultSet rs = stmt.executeQuery();
            if (!rs.isBeforeFirst()) {
                System.out.println("No staff with Firstname starting with " + firstname + " @ " + hotel + ".");
            } else {
                while (rs.next()) {
                    System.out.println(rs.getString("FirstName") + " " + rs.getString("LastName"));
                }
            }
        }
    }

    private static void getMostPopularService(Connection conn, String hotel) throws SQLException {
        String query = "SELECT S.Name AS ServiceName, COUNT(*) AS NumberOfTimesOrdered " +
                "FROM Service S " +
                "JOIN Bill B ON S.BillNum = B.InvoiceNum " +
                "JOIN Booking BK ON B.BookingID = BK.BookingID " +
                "JOIN Hotel H ON BK.HotelCode = H.HotelCode " +
                "WHERE H.Name = ? " +
                "GROUP BY S.Name " +
                "ORDER BY NumberOfTimesOrdered DESC " +
                "LIMIT 1";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, hotel);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                System.out.println("ServiceName: " + rs.getString("ServiceName") +
                        ", NumberOfTimesOrdered: " + rs.getInt("NumberOfTimesOrdered"));
            }
        }
    }

    private static void newBooking(Connection conn, int hotelCode, int roomNo, int guestID,
            String bookingDateTime, String checkinDateTime,
            String checkoutDateTime, int numAdults) throws SQLException {
        String sql = "INSERT INTO Booking (HotelCode, RoomNo, GuestID, BookingDateTime, CheckinDateTime, "
                + "CheckoutDateTime, NumAdults) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, hotelCode);
            pstmt.setInt(2, roomNo);
            pstmt.setInt(3, guestID);
            pstmt.setString(4, bookingDateTime);
            pstmt.setString(5, checkinDateTime);
            pstmt.setString(6, checkoutDateTime);
            pstmt.setInt(7, numAdults);

            pstmt.executeUpdate();
            System.out.println("Booking created successfully.");
        }
    }

    private static void newGuest(Connection conn, String firstName, String lastName, String email,
            String password) throws SQLException {
        String sql = "INSERT INTO Guest (FirstName, LastName, DOB, Gender, Email, Password, Address, Phone) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, firstName);
            pstmt.setString(2, lastName);
            pstmt.setString(5, email);
            pstmt.setString(6, password);
            pstmt.executeUpdate();
        }
    }

    private static int getHotelCodeByName(Connection conn, String hotel) throws SQLException {
        String sql = "SELECT HotelCode FROM Hotel WHERE Name = ?";
        int hotelCode = -1;

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, hotel);
            try (ResultSet resultSet = pstmt.executeQuery()) {
                if (resultSet.next()) {
                    hotelCode = resultSet.getInt("HotelCode");
                }
            }
        }

        return hotelCode;
    }

    private static ArrayList getAvailableRoomNo(Connection conn, int hotelCode, String checkinDateTime, String checkoutDateTime) throws SQLException {
        // Query to find available rooms
        String sql = "SELECT Room.RoomNo " +
        "FROM Room " +
        "LEFT JOIN Booking " +
        "ON Room.RoomNo = Booking.RoomNo AND Room.HotelCode = Booking.HotelCode " +
        "WHERE Room.HotelCode = ? "  +
        "AND (Booking.CheckoutDateTime <= ? OR Booking.CheckinDateTime >= ?) " +
        "OR Booking.BookingDateTime IS NULL";

        ArrayList<Integer> rooms = new ArrayList<Integer>();

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, hotelCode);
            pstmt.setString(2, checkinDateTime);
            pstmt.setString(2, checkoutDateTime);
            try (ResultSet resultSet = pstmt.executeQuery()) {
                while (resultSet.next()) {
                    int room = resultSet.getInt("RoomNo");
                    rooms.add(room);
                }
            }
        }

        return rooms;
    }
}
