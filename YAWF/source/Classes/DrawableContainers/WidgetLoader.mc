import Widgets;

module DrawableContainers
{
    enum ContainerPosition { WIDGET_CENTER = 0, WIDGET_UPPERCENTER, WIDGET_TOPLEFT }

    class WidgetLoader
    {
        static function GetWidget(pos as ContainerPosition) as WidgetBase
        {
            switch (pos)
            {
                case WIDGET_CENTER:
                    return new Clock();
                case WIDGET_UPPERCENTER:
                    return new Date();
                case WIDGET_TOPLEFT:
                    return new BatteryStatus();
            }

            return new WidgetBase();
        }
    }
}