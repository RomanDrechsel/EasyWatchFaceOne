import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class YAWFBackground extends WatchUi.Drawable {

    function initialize(params) 
    {
        Drawable.initialize(params);
    }

    function draw(dc as Dc) as Void 
    {
        dc.setColor(Graphics.COLOR_TRANSPARENT, getApp().getProperty("BackgroundColor") as Number);
        dc.clear();
    }

}
