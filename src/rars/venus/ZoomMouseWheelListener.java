package rars.venus;

import java.awt.*;
import java.awt.event.MouseWheelEvent;
import java.awt.event.MouseWheelListener;

public class ZoomMouseWheelListener implements MouseWheelListener {
    Component item;
    int initial_size = -1;

    int totalNotches = 0;
    int minNotches = -500;
    int maxNotches = 0; // max amount of reduction

    public ZoomMouseWheelListener(Component c) {
        item = c;
    }

    public void resetInitialSize() { // should be called when the base font changes
        initial_size = item.getFont().getSize();
        maxNotches = Math.max(maxNotches, initial_size);
        totalNotches = 0;
    }

    @Override
    public void mouseWheelMoved(MouseWheelEvent e) {
        if (e.isControlDown()) {
            if (initial_size < 0) {
                assert (totalNotches == 0);
                resetInitialSize();
            }
            totalNotches = totalNotches + e.getWheelRotation();
            totalNotches = Math.min(Math.max(totalNotches, minNotches), maxNotches);
            int ns = Math.max(1, initial_size - totalNotches);
            var f = item.getFont();
            var nf = new Font(f.getName(), f.getStyle(), ns);
            item.setFont(nf);
        } else {
            // let the parent (possibly a JScrollPane) handle it
            e.getComponent().getParent().dispatchEvent(e);
        }
    }
}