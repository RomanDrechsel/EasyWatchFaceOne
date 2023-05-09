import Toybox.Graphics;
import Toybox.Lang;

module Widgets 
{
    class WidgetBase
    {
        var locX = 0 as Float;
        var locY = 0 as Float;
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
        }

        function Init();

        function setPosition(posx as Float, posy as Float)
        {
            self.locX = posx;
            self.locY = posy;
        }
    }
}