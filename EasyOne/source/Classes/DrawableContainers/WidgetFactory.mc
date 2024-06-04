import Widgets;
import Toybox.Lang;
import Toybox.Application;
using Toybox.Application.Properties;

module DrawableContainers
{
    class WidgetFactory
    {
        static function GetWidget(pos as String, container_params as Dictionary) as WidgetBase or Null
        {
            switch (pos)
            {
                case "C":
                    return new Widgets.Clock(container_params);
                case "UC":
                    return new Widgets.Date(container_params);
                case "TL":
                    container_params.put("J", Widgets.WIDGET_JUSTIFICATION_LEFT);
                    return self.GetTopWidget(Properties.getValue("WTL") as Number, container_params);
                case "TC":
                    container_params.put("J", Widgets.WIDGET_JUSTIFICATION_CENTER);
                    return self.GetTopWidget(Properties.getValue("WTC") as Number, container_params);
                case "TR":
                    container_params.put("J", Widgets.WIDGET_JUSTIFICATION_RIGHT);
                    return self.GetTopWidget(Properties.getValue("WTR") as Number, container_params);
                case "BL":
                    container_params.put("J", Widgets.WIDGET_JUSTIFICATION_LEFT);
                    return self.GetBottomWidget(Properties.getValue("WBL") as Number, container_params);
                case "BR":
                    container_params.put("J", Widgets.WIDGET_JUSTIFICATION_RIGHT);
                    return self.GetBottomWidget(Properties.getValue("WBR") as Number, container_params);
                case "DTL":
                    container_params.put("J", Widgets.WIDGET_JUSTIFICATION_LEFT);
                    container_params.put("V", Widgets.WIDGET_JUSTIFICATION_TOP);
                    return self.GetDecoWidget(container_params);
                case "DTR":
                    container_params.put("J", Widgets.WIDGET_JUSTIFICATION_RIGHT);
                    container_params.put("V", Widgets.WIDGET_JUSTIFICATION_TOP);
                    return self.GetDecoWidget(container_params);
            }

            return null;
        }

        private static function GetTopWidget(setting as Number, container_params as Dictionary) as WidgetBase or Null
        {
            switch (setting)
            {
                case 1:
                    return new Widgets.BatteryStatus(container_params);
                case 2:
                    return new Widgets.Weather(container_params);
                case 3:
                    return new Widgets.Icons(container_params);
            }
            return null;
        }

        private static function GetBottomWidget(setting as Number, container_params as Dictionary) as WidgetBase or Null
        {
            switch (setting)
            {
                case 1:
                    return new Widgets.Distance(container_params);
                case 2:
                    return new Widgets.HealthIndicator(container_params);
            }

            return self.GetDecoWidget(container_params);
        }

        private static function GetDecoWidget(container_params as Dictionary) as WidgetBase or Null
        {
            var deco = Properties.getValue("Deco") as Number;
            if (deco != null && deco == 1)
            {
                return new Widgets.DecoWidget(container_params);
            }
            return null;
        }
    }
}
