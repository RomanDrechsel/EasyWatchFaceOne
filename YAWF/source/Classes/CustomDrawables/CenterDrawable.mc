import Toybox.WatchUi;
import Toybox.Lang;

module CustomDrawables
{
    class CenterDrawable extends DrawableBase 
    {
        function initialize(params as Dictionary)
        {
            DrawableBase.initialize(params);

            self._Widget = WidgetLoader.GetWidget(WIDGET_CENTER);
            if (self._Widget != null)
            {
                self._Widget.setPosition(self.locX, self.locY);
            }
        }
    }
}