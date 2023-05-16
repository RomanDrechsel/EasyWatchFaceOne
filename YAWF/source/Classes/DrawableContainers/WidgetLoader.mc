import Widgets;
import Toybox.Lang;

module DrawableContainers
{
    enum ContainerPosition { WIDGET_CENTER = 0, WIDGET_UPPERCENTER, WIDGET_TOPLEFT, WIDGET_TOPRIGHT, WIDGET_BOTTOMLEFT }

    class WidgetLoader
    {
        static function GetWidgetWithoutParams(pos as ContainerPosition) as WidgetBase
        {
            return self.GetWidget(pos, {});
        }

        static function GetWidget(pos as ContainerPosition, container_params as Dictionary) as WidgetBase
        {
            switch (pos)
            {
                case WIDGET_CENTER:
                    return new Clock(container_params);
                case WIDGET_UPPERCENTER:
                    return new Date(container_params);
                case WIDGET_TOPLEFT:
                    return new BatteryStatus(container_params);
                case WIDGET_TOPRIGHT:
                    return new Icons(container_params);
                case WIDGET_BOTTOMLEFT:
                    return new Distance(container_params);
            }

            return new WidgetBase();
        }
    }
}