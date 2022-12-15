package integration;

public class DAOException extends Exception {

    public DAOException(String reason) {
        super(reason);
    }

    public DAOException(String reason, Throwable rootCause) {
        super(reason, rootCause);
    }
}
