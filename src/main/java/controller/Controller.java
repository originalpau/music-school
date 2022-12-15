package controller;

import integration.DAO;
import integration.DAOException;
import model.Instruments;
import model.InstrumentsException;
import model.Student;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class Controller {
    private final DAO dao;

    public Controller() throws SQLException {
        dao = new DAO();
    }

    public List<? extends Instruments> getInstrumentsByKind(String kind) throws InstrumentsException {
        if (kind == null) {
            return new ArrayList<>();
        }
        try {
            return dao.listInstrumentsByKind(kind);
        } catch (Exception e) {
            throw new InstrumentsException("Could not close result set", e);
        }
    }

    public void rent(Integer instrumentId, String personNo) throws InstrumentsException, DAOException {
        String failureMsg = "Could not rent instrument " + instrumentId + " for " + personNo;
        try {
            Student student = dao.checkStudentRentals(personNo);
            Instruments instr = dao.findInstrById(instrumentId, true);
            if(instr.getStatus() && (student.getCount() < 2)) {
                dao.createRental(instrumentId, student.getStudent_id());
            }
        } catch (Exception e){
            commitOngoingTransaction(failureMsg);
            throw e;
        }
    }

    public void terminateRental(Integer instrId, String personNo) throws InstrumentsException {
        String failureMsg = "Could not terminate rental of " + instrId + " for " + personNo;

        try {
            Student student = dao.checkStudentRentals(personNo);
            dao.updateRental(instrId, student.getStudent_id());
            dao.updateInstrumentStatus(instrId, true);

        } catch (Exception e) {
            throw new InstrumentsException(failureMsg, e);
        }
    }

    private void commitOngoingTransaction(String failureMsg) throws InstrumentsException {
        try {
            dao.commit();
        } catch (DAOException bdbe) {
            throw new InstrumentsException(failureMsg, bdbe);
        }
    }
}
