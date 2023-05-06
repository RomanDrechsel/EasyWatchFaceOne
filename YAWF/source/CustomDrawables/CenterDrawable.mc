import Toybox.WatchUi;

module CustomDrawables
{
    class CenterDrawable extends DrawableBase 
    {
        function initialize(params)
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