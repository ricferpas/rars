package rars.tools;

import java.util.HashSet;
import java.util.Observable;
import java.util.Observer;

import rars.Globals;
import rars.ProgramStatement;
import rars.Settings;
import rars.riscv.hardware.Register;
import rars.riscv.hardware.RegisterFile;
import rars.riscv.hardware.RegisterAccessNotice;
import rars.simulator.Simulator;
import rars.simulator.SimulatorNotice;
import rars.venus.MessagesPane;
import rars.venus.VenusUI;

public class CCDebug {
    private static class State {
        final byte RS_WRITTEN = 0x1;
        final byte RS_SAVED = 0x2;

        byte regStatus[] = new byte[32];
        long regInitialValues[] = new long[32];
        State caller;
        ProgramStatement callerStatement = null;

        public State() {
            for (int i = 0; i < 32; ++i) {
                regInitialValues[i] = RegisterFile.getRegisters()[i].getValueNoNotify();
            }
            writeRegister(REG_RA);
            writeRegister(REG_SP);
        }

        public State(State caller) {
            this();
            this.caller = caller;
        }

        void writeRegister(int r) {
            regStatus[r] |= RS_WRITTEN;
        }

        void uninitializeRegister(int r) {
            regStatus[r] &= ~RS_WRITTEN;
        }

        boolean registerIsWritten(int r) {
            return (regStatus[r] & RS_WRITTEN) != 0;
        }

        void saveRegister(int r) {
            regStatus[r] |= RS_SAVED;
        }

        @SuppressWarnings("unused")
		void unsaveRegister(int r) {
            regStatus[r] &= ~RS_SAVED;
        }

        boolean registerIsSaved(int r) {
            return (regStatus[r] & RS_SAVED) != 0;
        }
    }

    private State state;
    private final Simulator simulator;
    private boolean started = false;

    private final static int argumentRegisters[] = new int[] { 10, 11, 12, 13, 14, 15, 16, 17 };
    private final static int resultRegisters[] = argumentRegisters;

    private static boolean isPreserved(int r) {
        return r == 2 || (r >= 8 && r <= 9) || (r >= 18 && r <= 27);
    }

    private final static int preservedRegisters[] = new int[] { 2, 8, 9, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27 };
    private final static int notPreservedRegisters[] = new int[] { 1, 5, 6, 7, 10, 11, 12, 13, 14, 15, 16, 17, 28, 29, 30, 31 };

    private static int REG_RA = 1;
    private static int REG_SP = 2;

    public CCDebug(Simulator simulator) {
        this.simulator = simulator;
        reset();
        RegisterFile.addRegistersObserver((o, arg) -> {
            if (started) {
                Register r = (Register) o;
                RegisterAccessNotice ran = (RegisterAccessNotice) arg;
                int regno = r.getNumber();
                if (regno < 32) {
                    ProgramStatement cs = getCurrentStatement();
                    if (cs != null) { // cs may be null if a notification is processed after the program has been paused (race condition with the GUI thread)
                        if (ran.getAccessType() == RegisterAccessNotice.WRITE) {
                            if (isPreserved(regno) && !state.registerIsSaved(regno) && !state.registerIsWritten(regno)) {
                                msg("Write of unsaved callee-saved register " + r.getName() + " (" + regno + "). " + generateBacktrace());
                            }
                            state.writeRegister(regno);
                        } else {
                            assert (ran.getAccessType() == RegisterAccessNotice.READ);
                            if (cs.getInstruction().getName().equals("sw") && cs.getOperand(2) == REG_SP) {
                                state.saveRegister(regno);
                            } else if (regno != 0 && !state.registerIsWritten(regno)) {
                                msg("Read of uninitialized register " + r.getName() + " (" + regno + "). " + generateBacktrace());
                            }
                        }
                    }
                }
            }
        });
        simulator.addObserver(new Observer() {
            @Override
            public void update(Observable o, Object arg) {
                SimulatorNotice n = (SimulatorNotice) arg;
                if (n.getAction() == SimulatorNotice.SIMULATOR_CALL && started) {
                    pushState();
                    for (int r : argumentRegisters) {
                        if (state.caller.registerIsWritten(r)) {
                            state.writeRegister(r);
                        }
                    }
                    for (int r : notPreservedRegisters) {
                        state.caller.uninitializeRegister(r);
                    }
                    state.callerStatement = getCurrentStatement();
                } else if (n.getAction() == SimulatorNotice.SIMULATOR_RETURN && started) {
                    if (state.caller == null) {
                        msg("More returns than calls");
                    } else {
                        for (int r : resultRegisters) {
                            if (state.registerIsWritten(r)) {
                                state.caller.writeRegister(r);
                            }
                        }
                    }
                    for (int r : preservedRegisters) {
                        if (state.regInitialValues[r] != RegisterFile.getRegisters()[r].getValueNoNotify()) {
                            msg("Callee-saved register " + RegisterFile.getRegisters()[r].getName() + " (" + r + ") not preserved correctly." + generateBacktrace());
                        }
                    }
                    popState();
                } else if (n.getAction() == SimulatorNotice.SIMULATOR_START) {
                    numErrors = 0;
                    messages.clear();
                    if (Globals.getSettings().getBooleanSetting(Settings.Bool.CC_DEBUG_ENABLED)) {
                        started = true;
                    }
                } else if (n.getAction() == SimulatorNotice.SIMULATOR_STOP) {
                    numErrors = 0;
                    messages.clear();
                    started = false;
                }
            }
        });
    }

    private int numErrors = 0;
    static final int MAX_ERRORS = 1000;
    HashSet<String> messages = new HashSet<String>();
    private static final int MAX_DIFFERENT_MESSAGES = 25;

    private void msg(String msg) {
        if (messages.size() < MAX_DIFFERENT_MESSAGES && numErrors < MAX_ERRORS) {
            VenusUI g = Globals.getGui();
            if (g != null) {
                MessagesPane p = g.getMessagesPane();
                if (p != null) {
                    String m = "Warning" + (getCurrentStatement() != null ? " in " + getCurrentStatement().getSourceFile() + " line " + getCurrentStatement().getSourceLine() : "")
                            + ": " + msg + "\n";
                    numErrors++;
                    if (!messages.contains(m)) {
                        p.postMessage(m);
                        messages.add(m);
                    }
                    if (messages.size() == MAX_DIFFERENT_MESSAGES) {
                        p.postMessage("Warning: Limit of different programming convention's warnings reached (" + MAX_DIFFERENT_MESSAGES
                                + "). No more warnings will be shown.\n");
                        started = false;
                    }
                    if (numErrors == MAX_ERRORS) {
                        p.postMessage("Warning: Limit of detected programming convention's errors reached (" + MAX_ERRORS + "). No more warnings will be shown.\n");
                        started = false;
                    }
                }
            }
        }
    }

    private String generateBacktrace() {
        if (state.callerStatement == null) {
            return "(no calls)";
        } else {
            String r = "Callers: " + state.callerStatement.getSourceLine();
            int n = 1;
            State s = state.caller;
            while (s != null && s.callerStatement != null && n < 25) {
                r += ", " + s.callerStatement.getSourceLine();
                s = s.caller;
                ++n;
            }
            return r;
        }
    }

    public void reset() {
        state = new State();
        numErrors = 0;
        messages.clear();
        pushState(); // main
        state.writeRegister(10); // a0 = argc
        state.writeRegister(11); // a1 = argv
    }

    private void pushState() {
        state = new State(state);
    }

    private void popState() {
        if (state.caller != null) {
            state = state.caller;
        } else {
            state = new State();
        }
    }

    private ProgramStatement getCurrentStatement() {
        return simulator.getCurrentStatement();
    }
}
