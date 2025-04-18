import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Widgets;

module DrawableContainers {
    class WidgetContainer extends WatchUi.Drawable {
        protected var _Widget as WidgetBase? = null;

        function initialize(params as Dictionary) {
            Drawable.initialize(params);
            self.Init();
        }

        function draw(dc as Dc) as Void {
            if (self._Widget != null && self._Widget has :draw) {
                self._Widget.draw(dc);
            }
        }

        function Init() as Void {
            self._Widget = null;
            var params = {
                "X" => self.locX,
                "Y" => self.locY,
                "W" => self.width,
                "H" => self.height,
            };

            self._Widget = WidgetFactory.GetWidget(self.identifier as String, params);
            if (self._Widget == null) {
                self.isVisible = false;
            } else {
                self.isVisible = true;
            }
        }
    }
}
