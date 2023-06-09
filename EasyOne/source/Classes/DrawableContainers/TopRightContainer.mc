import Toybox.Lang;
import Widgets;

module DrawableContainers
{
    class TopRightContainer extends BaseContainer 
    {
        function initialize(params as Dictionary)
        {
            BaseContainer.initialize(params);
        }

        protected function getWidget(params) as WidgetBase
        {
            return WidgetLoader.GetWidget(WIDGET_TOPRIGHT, params);
        }
    }
}