package integration;

import model.Instruments;
import model.Student;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class DAO {
    private Connection connection;
    private PreparedStatement readInstrument;
    private PreparedStatement readInstrumentById;
    private PreparedStatement readInstrumentByIdLock;
    private PreparedStatement readStudentRentals;
    private PreparedStatement createRentalStmt;
    private PreparedStatement updateInstrumentStmt;
    private PreparedStatement updateRentalStmt;

    public DAO() throws SQLException {
        connectToDB();
        prepareStatement();
    }

    public List<Instruments> listInstrumentsByKind(String kind) throws DAOException{
        String failureMsg = " Could not search for specified instruments.";
        ResultSet result = null;
        List<Instruments> instruments = new ArrayList<>();
        try{
            readInstrument.setString(1,kind);
            result = readInstrument.executeQuery();
            while(result.next()) {
                instruments.add(new Instruments(result.getString("id"),
                        result.getString("kind"),
                        result.getString("brand"),
                        result.getInt("price"),
                        result.getBoolean("isAvailable")));
            }
            connection.commit();
        } catch (SQLException sqle) {
        handleException(failureMsg, sqle);
    } finally {
        closeResultSet(failureMsg, result);
    }
        return instruments;
    }

    public Instruments findInstrById(Integer InstrumentId, boolean lock) throws DAOException {
        PreparedStatement stmtToExecute;
        if(lock) {
            stmtToExecute = readInstrumentByIdLock;
        } else {
            stmtToExecute = readInstrumentById;
        }
        String failureMsg = "Could not search for specified instrument.";
        ResultSet result = null;
        try {
            stmtToExecute.setInt(1, InstrumentId);
            result = stmtToExecute.executeQuery();
            if(result.next()) {
                return new Instruments(result.getString("id"),
                        result.getString("kind"),
                        result.getString("brand"),
                        result.getInt("price"),
                        result.getBoolean("isAvailable"));
            }

            if (!lock) {
                connection.commit();
            }
        } catch (SQLException e) {
            handleException(failureMsg, e);
        } finally {
            closeResultSet(failureMsg, result);
        }
        return null;
    }

    public Student checkStudentRentals(String personNo) throws DAOException{
        String failureMsg = "Could not search for specified student.";
        ResultSet result = null;
        try {
            readStudentRentals.setString(1, personNo);
            result = readStudentRentals.executeQuery();
            if(result.next()) {
                return new Student(result.getInt("count"), result.getInt("student_id"));
            }
        } catch (SQLException e) {
            handleException(failureMsg, e);
        } finally {
            closeResultSet(failureMsg, result);
        }
        return null;
    }

    public void createRental(Integer instrumentId, Integer studentId) throws DAOException{
        String failureMsg = "Could not create new rental";
        int updatedRows = 0;
        try {
            createRentalStmt.setInt(1, instrumentId);
            createRentalStmt.setInt(2, studentId);
            createRentalStmt.setTimestamp(3,Timestamp.valueOf(LocalDateTime.now()));
            updatedRows = createRentalStmt.executeUpdate();

            if(updatedRows != 1) {
                handleException(failureMsg, null);
            }

            updateInstrumentStmt.setBoolean(1, false);
            updateInstrumentStmt.setInt(2, instrumentId);
            updatedRows = updateInstrumentStmt.executeUpdate();

            if(updatedRows != 1) {
                handleException(failureMsg, null);
            }

            connection.commit();
        } catch (SQLException e) {
            handleException(failureMsg, e);
        }
    }

    public void updateInstrumentStatus(Integer instrumentId, boolean status) throws DAOException{
        String failureMsg = "Could not update instrument status.";
        int updatedRows = 0;

        try {
            updateInstrumentStmt.setBoolean(1, status);
            updateInstrumentStmt.setInt(2, instrumentId);
            updatedRows = updateInstrumentStmt.executeUpdate();

            if(updatedRows != 1) {
                handleException(failureMsg, null);
            }

            connection.commit();
        } catch (SQLException e) {
            handleException(failureMsg, e);
        }
    }

    public void updateRental(Integer instrId, Integer studentId) throws DAOException {
        String failureMsg = "Could not update rental";
        int updatedRows = 0;
        try {
            updateRentalStmt.setTimestamp(1,Timestamp.valueOf(LocalDateTime.now()));
            updateRentalStmt.setInt(2,instrId);
            updateRentalStmt.setInt(3,studentId);
            updatedRows = updateRentalStmt.executeUpdate();

            if(updatedRows != 1) {
                handleException(failureMsg, null);
            }
        } catch (SQLException e) {
            handleException(failureMsg, e);
        }
    }

    private void connectToDB() throws SQLException {
        connection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/bank",
                "postgres", "postgres");
        connection.setAutoCommit(false);
    }

    private void prepareStatement() throws SQLException {
        readInstrument = connection.prepareStatement("select * from rental_instrument where isAvailable=true and kind=?");
        readInstrumentByIdLock = connection.prepareStatement("select * from rental_instrument where id=? for update");
        readInstrumentById = connection.prepareStatement("select * from rental_instrument where id=?");
        readStudentRentals = connection.prepareStatement("select count(*), student_id from student_rental_instrument r\n" +
                "inner join student on student.id = r.student_id\n" +
                "where person_number = ? and return_date is null\n" +
                "group by r.student_id");
        createRentalStmt = connection.prepareStatement("insert into student_rental_instrument " +
                "(rental_instrument_id, student_id, checkout_date) " +
                "values (?, ?, ?)");
        updateInstrumentStmt = connection.prepareStatement("update rental_instrument set isAvailable=? where id = ?");
        updateRentalStmt = connection.prepareStatement("update student_rental_instrument\n" +
                "set return_date = ?\n" +
                "where rental_instrument_id = ? and student_id = ?");
    }

    private void handleException(String failureMsg, Exception cause) throws DAOException {
        String completeFailureMsg = failureMsg;
        try {
            connection.rollback();
        } catch (SQLException rollbackExc) {
            completeFailureMsg = completeFailureMsg + ". Also failed to rollback transaction because of: " + rollbackExc.getMessage();
        }

        if(cause != null) {
            throw new DAOException(completeFailureMsg, cause);
        } else {
            throw new DAOException(completeFailureMsg);
        }
    }

    private void closeResultSet(String failureMsg, ResultSet result) throws DAOException {
        try {
            result.close();
        } catch (Exception e) {
            throw new DAOException(failureMsg + " Could not close result set.", e);
        }
    }

    public void commit() throws DAOException {
        try {
            connection.commit();
        } catch (SQLException e) {
            handleException("Failed to commit", e);
        }
    }
}
