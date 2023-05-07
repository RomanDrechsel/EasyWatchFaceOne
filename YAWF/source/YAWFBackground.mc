import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class YAWFBackground extends WatchUi.Drawable 
{
    private var _color = 0 as Number;

    function initialize(params) 
    {
        Drawable.initialize(params);

        self._color = getTheme().BackgroundColor;
    }

    function draw(dc as Dc) as Void 
    {
        dc.setColor(Graphics.COLOR_TRANSPARENT, self._color);
        dc.clear();
    }
}
