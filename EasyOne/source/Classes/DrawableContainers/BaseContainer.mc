import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Widgets;

module DrawableContainers
{
    class BaseContainer extends Drawable 
    {
        protected var _Widget = null as WidgetBase;
        protected var _params = null as Dictionary;

        function initialize(params as Dictionary)
        {
            Drawable.initialize(params);
            self._params = params;
            self.onSettingsChanged();
            $.getApp().OnSettings.add(self.method(:onSettingsChanged));
        }

        function draw(dc as Dc) as Void 
        {
            if (self._Widget != null)
            {
                self._Widget.draw(dc);
            }
        }

        function onSettingsChanged()
        {
            //reload Widget...
            self._Widget = self.getWidget(self._params);
        }
    }
}