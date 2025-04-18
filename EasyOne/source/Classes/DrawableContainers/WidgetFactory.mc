import Widgets;
import Toybox.Lang;

module DrawableContainers {
    class WidgetFactory {
        static function GetWidget(pos as String, container_params as Dictionary?) as WidgetBase? {
            if (container_params == null) {
                container_params = {};
            }
            switch (pos) {
                case "C":
                    return new Widgets.Clock(container_params);
                case "UC":
                    return new Widgets.Date(container_params);
                case "TL":
                    container_params.put("J", Widgets.WIDGET_JUSTIFICATION_LEFT);
                    return self.GetTopWidget(Helper.Properties.Get("WTL", 1) as Number, container_params);
                case "TC":
                    container_params.put("J", Widgets.WIDGET_JUSTIFICATION_CENTER);
                    return self.GetTopWidget(Helper.Properties.Get("WTC", 2) as Number, container_params);
                case "TR":
                    container_params.put("J", Widgets.WIDGET_JUSTIFICATION_RIGHT);
                    return self.GetTopWidget(Helper.Properties.Get("WTR", 3) as Number, container_params);
                case "BL":
                    container_params.put("J", Widgets.WIDGET_JUSTIFICATION_LEFT);
                    return self.GetBottomWidget(Helper.Properties.Get("WBL", 1) as Number, container_params);
                case "BR":
                    container_params.put("J", Widgets.WIDGET_JUSTIFICATION_RIGHT);
                    return self.GetBottomWidget(Helper.Properties.Get("WBR", 2) as Number, container_params);
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

        private static function GetTopWidget(setting as Number, container_params as Dictionary) as WidgetBase? {
            switch (setting) {
                case 1:
                    return new Widgets.BatteryStatus(container_params);
                case 2:
                    return new Widgets.Weather(container_params);
                case 3:
                    return new Widgets.Icons(container_params);
            }
            return null;
        }

        private static function GetBottomWidget(setting as Number, container_params as Dictionary) as WidgetBase? {
            switch (setting) {
                case 1:
                    return new Widgets.Distance(container_params);
                case 2:
                    return new Widgets.HealthIndicator(container_params);
            }

            container_params.put("V", Widgets.WIDGET_JUSTIFICATION_BOTTOM);
            return self.GetDecoWidget(container_params);
        }

        private static function GetDecoWidget(container_params as Dictionary) as WidgetBase? {
            if ((Helper.Properties.Get("Deco", 1) as Number) == 1) {
                return new Widgets.DecoWidget(container_params);
            }
            return null;
        }
    }
}
