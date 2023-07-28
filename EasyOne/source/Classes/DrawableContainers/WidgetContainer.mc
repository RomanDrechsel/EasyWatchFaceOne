import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Widgets;

module DrawableContainers
{
    class WidgetContainer extends Drawable 
    {
        protected var _Widget = null as WidgetBase;

        function initialize(params as Dictionary)
        {
            Drawable.initialize(params);
            self.onSettingsChanged();
            $.getApp().OnSettings.add(self.method(:onSettingsChanged));
        }

        function draw(dc as Dc) as Void 
        {
            if (self._Widget != null)
            {
                self._Widget.draw(dc);
            }
        }

        function onSettingsChanged()
        {
            self._Widget = null;

            var params = {
                "X" => self.locX,
                "Y" => self.locY,
                "W" => self.width,
                "H" => self.height
            };
            var widget = null;

            switch (self.identifier)
            {
                case "C":
                    widget = WIDGET_CENTER;
                    break;
                case "UC":
                    widget = WIDGET_UPPERCENTER;
                    break;
                case "DTL":
                    widget = WIDGET_DECO;
                    params.put("V", Widgets.WIDGET_JUSTIFICATION_TOP);
                    params.put("J", Widgets.WIDGET_JUSTIFICATION_LEFT);
                    break;
                case "TL":
                    widget = WIDGET_TOPLEFT;
                    params.put("J", Widgets.WIDGET_JUSTIFICATION_LEFT);
                    break;
                case "TC":
                    widget = WIDGET_TOPCENTER;
                    params.put("J", Widgets.WIDGET_JUSTIFICATION_CENTER);
                    break;
                case "TR":
                    widget = WIDGET_TOPRIGHT;
                    params.put("J", Widgets.WIDGET_JUSTIFICATION_RIGHT);
                    break;
                case "DTR":
                    widget = WIDGET_DECO;
                    params.put("V", Widgets.WIDGET_JUSTIFICATION_TOP);
                    params.put("J", Widgets.WIDGET_JUSTIFICATION_RIGHT);
                    break;
                case "BL":
                    widget = WIDGET_BOTTOMLEFT;
                    params.put("J", Widgets.WIDGET_JUSTIFICATION_LEFT);
                    break;
                case "BR":
                    widget = WIDGET_BOTTOMRIGHT;
                    params.put("J", Widgets.WIDGET_JUSTIFICATION_RIGHT);
                    break;
            }

            if (widget != null)
            {
                self._Widget = WidgetFactory.GetWidget(widget, params);
            }            
        }
    }
}