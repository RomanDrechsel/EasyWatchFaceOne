import Toybox.Lang;
import Widgets;

module DrawableContainers
{
    class BottomLeftContainer extends BaseContainer 
    {
        function initialize(params as Dictionary)
        {
            BaseContainer.initialize(params);
        }

        protected function getWidget(params) as WidgetBase
        {
            return WidgetFactory.GetWidget(WIDGET_BOTTOMLEFT, params);
        }
    }
}