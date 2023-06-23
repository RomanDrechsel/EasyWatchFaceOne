using Toybox.Graphics as Gfx;
import Toybox.Lang;

module Widgets 
{   
    enum Widget_Justification { WIDGET_JUSTIFICATION_LEFT = 0, WIDGET_JUSTIFICATION_RIGHT, WIDGET_JUSTIFICATION_CENTER, WIDGET_JUSTIFICATION_TOP, WIDGET_JUSTIFICATION_BOTTOM }

    class WidgetBase
    {
        var locX = 0.0;
        var locY = 0.0;
        var Justification = WIDGET_JUSTIFICATION_LEFT as Widget_Justification;
        var VJustification = WIDGET_JUSTIFICATION_TOP as Widget_Justification;

        var _theme = null as Themes.ThemeSettingsBase;

        function initialize(container_params as Dictionary)
        {
            self._theme = $.getTheme();

            var posx = container_params.get(:locX);
            if (posx != null)
            {
                self.locX = posx.toFloat();
            }
            var posy = container_params.get(:locY);
            if (posy != null)
            {
                self.locY = posy.toFloat();
            }

            var just = container_params.get(:Just);
            if (just != null)
            {
                switch (just.toLower())
                {
                    case "left":
                        self.Justification = WIDGET_JUSTIFICATION_LEFT;
                        break;
                    case "right":
                        self.Justification = WIDGET_JUSTIFICATION_RIGHT;
                        break;
                    case "center":
                        self.Justification = WIDGET_JUSTIFICATION_CENTER;
                        break;
                }
            }

            var vjust = container_params.get(:VJust);
            if (vjust != null)
            {
                switch (vjust.toLower())
                {
                    case "top":
                        self.VJustification = WIDGET_JUSTIFICATION_TOP;
                        break;
                    case "bottom":
                        self.VJustification = WIDGET_JUSTIFICATION_BOTTOM;
                        break;
                }
            }
        }

        function draw(dc as Gfx.Dc);
    }
}