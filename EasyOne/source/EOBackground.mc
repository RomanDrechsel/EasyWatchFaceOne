import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class ESOBackground extends WatchUi.Drawable 
{
    private var _color = 0 as Number;
    private var _image = null as BitmapResource;
    private var _hasScaledBackground = null as Boolean|Object;

    function initialize(params) 
    {
        Drawable.initialize(params);

        self.onSettingsChanged();
        $.getApp().OnSettings.add(self.method(:onSettingsChanged));
    }

    function draw(dc as Dc) as Void 
    {
        dc.setAntiAlias(true);
        dc.setColor(Graphics.COLOR_TRANSPARENT, self._color);
        dc.clear();

        if (self._image != null)
        {
            if (self._hasScaledBackground == null)
            {
                self._hasScaledBackground = dc has :drawScaledBitmap;
            }
            
            if (self._hasScaledBackground)
            {
                dc.drawScaledBitmap(0, 0, dc.getWidth(), dc.getHeight(), self._image);
            }
            else
            {
                var offset_x = (dc.getWidth() - self._image.getWidth()) / 2;
                var offset_y = (dc.getHeight() - self._image.getHeight()) / 2;
                dc.drawBitmap(offset_x, offset_y, self._image);
            }   
        }
    }

    function onSettingsChanged()
    {
        var theme = getTheme();
        
        self._color = theme.BackgroundColor;
        var bgimage = theme.BackgroundImage;
        if (bgimage > 0)
        {
            self._image = Application.loadResource(bgimage) as BitmapResource;
        }
    }
}
