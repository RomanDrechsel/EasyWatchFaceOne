import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class WFBackground extends WatchUi.Drawable {
    private var _color as Number? = 0;
    private var _image as BitmapResource? = null;

    function initialize(params) {
        Drawable.initialize(params);
        self.Init();

        var view = $.getView();
        if (view != null) {
            view.OnShow.add(self);
            view.OnSleep.add(self);
        }
    }

    function draw(dc as Dc) as Void {
        dc.setAntiAlias(true);
        dc.setColor(Graphics.COLOR_TRANSPARENT, self._color);
        dc.clear();

        if (self._image != null) {
            dc.drawBitmap(0, 0, self._image);
        }
    }

    function Init() {
        var theme = $.getTheme();
        self._color = theme.BackgroundColor;
        self._image = null;

        var bgResource = Helper.Properties.Get("BG", 0) as Number;
        if (bgResource == 0) {
            //theme background
            var bgimage = theme.BackgroundImage;
            if (bgimage != null) {
                self._image = Application.loadResource(bgimage) as BitmapResource;
            }
            self._color = theme.BackgroundColor;
        } else if (bgResource == 1) {
            //system background
            self._color = Graphics.COLOR_TRANSPARENT;
        } else {
            //fixed color
            var colorType = Helper.Properties.Get("BGCT", 0) as Number;
            if (colorType == 0) {
                //predefined color
                var predefined_color = Helper.Properties.Get("BGCPre", 0) as Number;
                var colors = [
                    0, //Black
                    0x2f4f4f, //DarkSlateGrey
                    0x2d2e38, //DarkGrey
                    0x1d1d25, //VeryDark
                    0x490d03, //DarkRed
                    0x000025, //DarkBlue
                    0x123456, //Blue
                ];
                if (predefined_color < colors.size()) {
                    self._color = colors[predefined_color];
                } else if (predefined_color == 666) {
                    self._color = 0x0827f5; //Blue screen of death
                } else {
                    self._color = Graphics.COLOR_TRANSPARENT;
                }
            } else {
                //custom color
                var customcolor = Helper.Properties.Get("BGCCu", "#000000") as String;
                if (customcolor.length() == 0) {
                    self._color = null;
                } else {
                    self._color = Helper.StringUtil.stringReplace(customcolor, "#", "").toNumberWithBase(16);
                }

                if (self._color == null) {
                    self._color = Graphics.COLOR_TRANSPARENT;
                }
            }
        }
    }

    public function OnShow() as Void {
        self.Init();
        $.Log("Background Show");
    }

    public function OnSleep() as Void {
        self._color = null;
        self._image = null;
        $.Log("Background Hide");
    }
}
