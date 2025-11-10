package rars.venus;

import java.awt.*;
import java.awt.event.MouseWheelEvent;
import java.awt.event.MouseWheelListener;

public class ZoomMouseWheelListener implements MouseWheelListener {
    Component item;
    int initial_size = -1;

    int totalNotches = 0;
    int minNotches = -500;
    int maxNotches = 0; // max ammount of reduction

    public ZoomMouseWheelListener(Component c) {
        item = c;
    }

    @Override
    public void mouseWheelMoved(MouseWheelEvent e) {
        if (e.isControlDown()) {
            if (initial_size < 0) {
                initial_size = item.getFont().getSize();
                maxNotches = Math.max(maxNotches, initial_size);
                assert (totalNotches == 0);
            }
            totalNotches = totalNotches + e.getWheelRotation();
            totalNotches = Math.min(Math.max(totalNotches, minNotches), maxNotches);
            int ns = Math.max(1, initial_size - totalNotches);
            var f = item.getFont();
            item.setFont(new Font(f.getName(), f.getStyle(), ns));
        } else {
            // let the parent (posibly a JScrollPane) handle it
            e.getComponent().getParent().dispatchEvent(e);
        }
    }
}