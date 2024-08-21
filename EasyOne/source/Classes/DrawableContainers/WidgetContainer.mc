import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Widgets;

module DrawableContainers
{
    class WidgetContainer extends Drawable 
    {
        protected var _Widget = null as WidgetBase;

        function initialize(params as Dictionary)
        {
            Drawable.initialize(params);
            self.Init();
        }

        function draw(dc as Dc) as Void 
        {
            if (self._Widget != null)
            {
                self._Widget.draw(dc);
            }
        }

        function Init() as Void
        {
            self._Widget = null;
            var params = {
                "X" => self.locX,
                "Y" => self.locY,
                "W" => self.width,
                "H" => self.height
            };

            self._Widget = WidgetFactory.GetWidget(self.identifier, params);
            if (self._Widget == null)
            {
                self.isVisible = false;
            }
            else
            {
                self.isVisible = true;
            }
        }
    }
}