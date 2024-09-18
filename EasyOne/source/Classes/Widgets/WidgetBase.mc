import Toybox.Lang;

module Widgets {
    enum {
        WIDGET_JUSTIFICATION_LEFT = 0,
        WIDGET_JUSTIFICATION_RIGHT,
        WIDGET_JUSTIFICATION_CENTER,
        WIDGET_JUSTIFICATION_TOP,
        WIDGET_JUSTIFICATION_BOTTOM,
    }

    class WidgetBase {
        var locX = 0;
        var locY = 0;
        var Justification = WIDGET_JUSTIFICATION_LEFT;

        function initialize(container_params as Dictionary) {
            self.locX = container_params.get("X");
            if (self.locX == null) {
                self.locX = 0;
            }
            self.locY = container_params.get("Y");
            if (self.locY == null) {
                self.locY = 0;
            }

            self.Justification = container_params.get("J") as Number;
            if (self.Justification == null) {
                self.Justification = WIDGET_JUSTIFICATION_LEFT;
            }
        }
    }
}
