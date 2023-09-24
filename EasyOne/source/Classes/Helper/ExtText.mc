import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

module Helper 
{
    class ExtText
    {
        var AnchorX = NaN as Number;
        var AnchorY = NaN as Number;

        private var _just = Graphics.TEXT_JUSTIFY_CENTER;
        private var _width = 0;
        private var _height = 0;

        function initialize(posx as Number, posy as Number, just as Graphics.TextJustification)
        {
            self.AnchorX = posx;
            self.AnchorY = posy;
            self._just = just;
        }

        function draw(texts as Array<ExtTextPart>, dc as Graphics.Dc) as Number
        {
            if (texts.size() == 0)
            {
                return;
            }

            self.calcDimensions(texts, dc);
            if (self._width <= 0 || self._height <= 0)
            {
                return;
            }

            var posx = self.AnchorX as Number;
            if (self._just == Graphics.TEXT_JUSTIFY_CENTER)
            {
                posx -= (self._width / 2);
            }
            else if (self._just == Graphics.TEXT_JUSTIFY_RIGHT)
            {
                posx -= self._width;
            }

            for (var i = 0; i < texts.size(); i++)
            {
                var text = texts[i];
                var h = Graphics.getFontAscent(text.Font);
                var yoffset = self._height - h;
                if (IsSmallDisplay)
                {
                    yoffset *= 1.2;
                }

                dc.setColor(text.Color, Graphics.COLOR_TRANSPARENT);
                dc.drawText(posx, self.AnchorY + yoffset, text.Font, text.Text, Graphics.TEXT_JUSTIFY_LEFT);
                posx += dc.getTextWidthInPixels(text.Text.toString(), text.Font);
            }

            return self._width;
        }

        private function calcDimensions(texts as Array<ExtTextPart>, dc as Graphics.Dc)
        {
            self._width = 0;
            self._height = 0;
            for(var i = 0; i < texts.size(); i++)
            {
                var width = dc.getTextWidthInPixels(texts[i].Text.toString(), texts[i].Font);
                var height = Graphics.getFontAscent(texts[i].Font);
                self._width += width;
                if (height > self._height)
                {
                    self._height = height;
                }
            }
        }
    }

    class ExtTextPart
    {
        var Text as String;
        var Color as Number;
        var Font as FontResource;

        function initialize(text as String, color as Number, font as FontResource)
        {
            self.Text = text;
            self.Color = color;
            self.Font = font;
        }        
    }
}