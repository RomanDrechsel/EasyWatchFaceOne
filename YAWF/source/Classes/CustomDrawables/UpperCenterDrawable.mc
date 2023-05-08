import Toybox.WatchUi;
import Toybox.Lang;
import Widgets;

module CustomDrawables
{
    class UpperCenterDrawable extends DrawableBase 
    {
        function initialize(params as Dictionary)
        {
            DrawableBase.initialize(params);      
        }

        protected function getWidget() as WidgetBase
        {
            return WidgetLoader.GetWidget(WIDGET_UPPERCENTER);
        }
    }
}