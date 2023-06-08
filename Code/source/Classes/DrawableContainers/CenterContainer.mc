import Toybox.Lang;
import Widgets;

module DrawableContainers
{
    class CenterContainer extends BaseContainer 
    {
        function initialize(params as Dictionary)
        {
            BaseContainer.initialize(params);
        }

        protected function getWidget(params) as WidgetBase
        {
            return WidgetLoader.GetWidget(WIDGET_CENTER, params);
        }
    }
}