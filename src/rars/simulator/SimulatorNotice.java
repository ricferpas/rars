package rars.simulator;

import rars.ProgramStatement;
import rars.SimulationException;
import rars.venus.run.RunSpeedPanel;

/**
 * Object provided to Observers of the Simulator.
 * They are notified at important phases of the runtime simulator,
 * such as start and stop of simulation.
 *
 * @author Pete Sanderson
 * @version January 2009
 */

public class SimulatorNotice {
    private int action;
    private int maxSteps;
    private Simulator.Reason reason;
    private boolean done;
    private SimulationException exception;
    private double runSpeed;
    private long programCounter;
    private ProgramStatement statement;

    public static final int SIMULATOR_START = 0;
    public static final int SIMULATOR_STOP = 1;
    public static final int SIMULATOR_CALL  = 2;
    public static final int SIMULATOR_RETURN  = 3;

    /**
     * Constructor will be called only within this package, so assume
     * address and length are in valid ranges.
     */
    public SimulatorNotice(int action, int maxSteps, double runSpeed, long programCounter, Simulator.Reason reason, SimulationException se, boolean done, ProgramStatement statement) {
        this.action = action;
        this.maxSteps = maxSteps;
        this.runSpeed = runSpeed;
        this.programCounter = programCounter;
        this.reason = reason;
        this.exception = se;
        this.done = done;
	this.statement = statement;
    }

    public int getAction() {
        return this.action;
    }

    public int getMaxSteps() {
        return this.maxSteps;
    }

    public double getRunSpeed() {
        return this.runSpeed;
    }

    public long getProgramCounter() {
        return this.programCounter;
    }

    public Simulator.Reason getReason() {
        return this.reason;
    }

    public SimulationException getException() {
        return this.exception;
    }

    public boolean getDone() {
        return this.done;
    }

    /**
     * String representation indicates access type, address and length in bytes
     */
    public String toString() {
        return ((getAction() == SIMULATOR_START) ? "START " : getAction() == SIMULATOR_STOP ? "STOP:  " : getAction() == SIMULATOR_CALL ? "CALL:  " : "RETURN:  ") + "Max Steps "
                + this.maxSteps + " " + "Speed " + ((this.runSpeed == rars.venus.run.RunSpeedPanel.UNLIMITED_SPEED) ? "unlimited " : "" + this.runSpeed + " inst/sec") + "Prog Ctr "
                + this.programCounter;
    }
}
