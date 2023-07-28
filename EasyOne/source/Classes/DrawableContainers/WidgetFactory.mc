import Widgets;
import Toybox.Lang;
import Toybox.Application;

module DrawableContainers
{
    enum ContainerPosition { WIDGET_CENTER = 0, WIDGET_UPPERCENTER, WIDGET_DECO, WIDGET_TOPLEFT, WIDGET_TOPCENTER, WIDGET_TOPRIGHT, WIDGET_BOTTOMLEFT, WIDGET_BOTTOMRIGHT }

    class WidgetFactory
    {
        static function GetWidget(pos as ContainerPosition, container_params as Dictionary) as WidgetBase
        {
            switch (pos)
            {
                case WIDGET_CENTER:
                    return new Clock(container_params);
                case WIDGET_UPPERCENTER:
                    return new Date(container_params);
                case WIDGET_TOPLEFT:
                    return self.GetTopWidget(Properties.getValue("WTL") as Number, container_params);    
                case WIDGET_TOPCENTER:
                    return self.GetTopWidget(Properties.getValue("WTC") as Number, container_params);
                case WIDGET_TOPRIGHT:
                    return self.GetTopWidget(Properties.getValue("WTR") as Number, container_params);
                case WIDGET_BOTTOMLEFT:
                    return self.GetBottomWidget(Properties.getValue("WBL") as Number, container_params);
                case WIDGET_BOTTOMRIGHT:
                    return self.GetBottomWidget(Properties.getValue("WBR") as Number, container_params);
                case WIDGET_DECO:
                    container_params.put("V", Widgets.WIDGET_JUSTIFICATION_TOP);
                    return self.GetDecoWidget(container_params);
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

            container_params.put("V", Widgets.WIDGET_JUSTIFICATION_BOTTOM);
            return self.GetDecoWidget(container_params);
        }

        private static function GetDecoWidget(container_params as Dictionary) as WidgetBase
        {
            var deco = Properties.getValue("Deco") as Number;
            if (deco != null && deco == 1)
            {
                return new DecoWidget(container_params);
            }
            return null;
        }
    }
}