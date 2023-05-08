import Toybox.Graphics;
import Toybox.Lang;

module Widgets 
{
    class WidgetBase
    {
        var locX = NaN as Float;
        var locY = NaN as Float;
        protected var _theme = null as Themes.ThemeSettingsBase;

        protected var _initialized = false as Boolean;

        function initialize()
        {
            self._theme = $.getTheme();
        }
        
        function setPosition(posx as Float, posy as Float)
        {
            self.locX = posx;
            self.locY = posy;
        }

        function draw(dc as Dc);
    }
}