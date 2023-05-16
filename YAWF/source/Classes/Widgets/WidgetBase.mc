import Toybox.Graphics;
import Toybox.Lang;

module Widgets 
{   
    enum Widget_Justification { WIDGET_JUSTIFICATION_LEFT = 0, WIDGET_JUSTIFICATION_RIGHT, WIDGET_JUSTIFICATION_TOP, WIDGET_JUSTIFICATION_BOTTOM }

    class WidgetBase
    {
        var locX = 0 as Float;
        var locY = 0 as Float;
        var Justification = WIDGET_JUSTIFICATION_LEFT as Widget_Justification;
        var VJustification = WIDGET_JUSTIFICATION_TOP as Widget_Justification;

        protected var _theme = null as Themes.ThemeSettingsBase;
        protected var _initialized = false as Boolean;

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

        function Init();

        function setPosition(posx as Float, posy as Float)
        {
            self.locX = posx;
            self.locY = posy;
        }
    }
}