import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Widgets;

module CustomDrawables
{
    class DrawableBase extends Drawable 
    {
        protected var _Widget = null as WidgetBase;

        function initialize(params)
        {
            Drawable.initialize(params);
        }

        function draw(dc as Dc) as Void 
        {
            if (self._Widget != null)
            {
                self._Widget.draw(dc);
            }
        }
    }
}