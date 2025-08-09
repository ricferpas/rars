package rars.riscv.hardware;

import rars.Globals;

public class Keyboard {
    static int RECEIVER_CONTROL = Memory.memoryMapBaseAddress; //0xffff0000; // keyboard Ready in low-order bit
    static int RECEIVER_DATA = Memory.memoryMapBaseAddress + 4; //0xffff0004; // keyboard character in low-orde

    static final int EXTERNAL_INTERRUPT_KEYBOARD = 0x00000040;

    public static void keyPress(int key) {
        try {
            Globals.memory.setRawWord(RECEIVER_DATA, key & 0xff);
            Globals.memory.setRawWord(RECEIVER_CONTROL, Globals.memory.getRawWord(RECEIVER_CONTROL) | 0x1);
            InterruptController.registerExternalInterrupt(EXTERNAL_INTERRUPT_KEYBOARD);
        } catch (AddressErrorException e) {
            e.printStackTrace(); // FIXME
        }
    }
}
