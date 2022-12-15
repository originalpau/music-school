package model;

public class InstrumentsException extends Exception{

    public InstrumentsException(String reason) {
        super(reason);
    }

    public InstrumentsException(String reason, Throwable rootCause) {
        super(reason, rootCause);
    }
}
