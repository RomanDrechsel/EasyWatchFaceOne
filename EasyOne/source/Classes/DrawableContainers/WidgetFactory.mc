import Widgets;
import Toybox.Lang;
import Toybox.Application;

module DrawableContainers
{
    enum ContainerPosition { WIDGET_CENTER = 0, WIDGET_UPPERCENTER, WIDGET_TOPLEFT, WIDGET_TOPCENTER, WIDGET_TOPRIGHT, WIDGET_BOTTOMLEFT, WIDGET_BOTTOMRIGHT }

    class WidgetFactory
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
                    return self.GetTopWidget(Properties.getValue("WidgetTopLeft") as Number, container_params);    
                case WIDGET_TOPCENTER:
                    return self.GetTopWidget(Properties.getValue("WidgetTopCenter") as Number, container_params);
                case WIDGET_TOPRIGHT:
                    return self.GetTopWidget(Properties.getValue("WidgetTopRight") as Number, container_params);
                case WIDGET_BOTTOMLEFT:
                    return self.GetBottomWidget(Properties.getValue("WidgetBottomLeft") as Number, container_params);
                case WIDGET_BOTTOMRIGHT:
                    return self.GetBottomWidget(Properties.getValue("WidgetBottomRight") as Number, container_params);
            }

            return null;
        }

        private static function GetTopWidget(setting as Number, container_params as Dictionary) as WidgetBase
        {
            switch (setting)
            {
                case 1:
                    return new BatteryStatus(container_params);
                case 2:
                    return new Weather(container_params);
                case 3:
                    return new Icons(container_params);
            }
            return null;
        }

        private static function GetBottomWidget(setting as Number, container_params as Dictionary) as WidgetBase
        {
            switch (setting)
            {
                case 1:
                    return new Distance(container_params);
                case 2:
                    return new HealthIndicator(container_params);
            }

            var deco = Properties.getValue("ShowDecolines") as Number;
            if (deco != null && deco == 1)
            {
                return new DecoRoundAngle(container_params);
            }
            return null;
        }
    }
}