package startup;

import controller.Controller;
import view.BlockingInterpreter;

import java.sql.SQLException;

public class Main {
    public static void main(String[] args) {
        try {
            new BlockingInterpreter(new Controller()).handleCmds();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
