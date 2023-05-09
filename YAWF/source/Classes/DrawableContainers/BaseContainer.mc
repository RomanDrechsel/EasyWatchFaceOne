import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Widgets;

module DrawableContainers
{
    class BaseContainer extends Drawable 
    {
        protected var _Widget = null as WidgetBase;

        function initialize(params as Dictionary)
        {
            Drawable.initialize(params);
            self._Widget = self.getWidget();
            
            if (self._Widget != null)
            {
                self._Widget.setPosition(self.locX, self.locY);
            }
        }

        function draw(dc as Dc) as Void 
        {
            if (self._Widget != null)
            {
                self._Widget.draw(dc);
            }
        }

        protected function getWidget();
    }
}