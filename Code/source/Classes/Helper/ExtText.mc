using Toybox.Graphics as Gfx;
import Toybox.Lang;
import Toybox.WatchUi;

module Helper 
{
    class ExtText
    {
        enum H_JUSTIFICATION { HJUST_CENTER, HJUST_LEFT, HJUST_RIGHT }
        enum V_JUSTIFICATION { VJUST_CENTER, VJUST_TOP, VJUST_BOTTOM }

        var AnchorX = NaN as Number;
        var AnchorY = NaN as Number;
        var Hjust = HJUST_CENTER as H_JUSTIFICATION;
        var Vjust = VJUST_CENTER as V_JUSTIFICATION;

        private var _width = 0 as Number;
        private var _height = 0 as Number;

        function initialize(posx as Number, posy as Number, hjust as H_JUSTIFICATION, vjust as V_JUSTIFICATION)
        {
            self.AnchorX = posx;
            self.AnchorY = posy;
            self.Hjust = hjust;
            self.Vjust = vjust;
        }

        function draw(texts as Array<ExtTextPart>, dc as Gfx.Dc)
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
            if (self.Hjust == HJUST_CENTER)
            {
                posx -= (self._width / 2);
            }
            else if (self.Hjust == HJUST_RIGHT)
            {
                posx -= self._width;
            }

            var posy = self.AnchorY as Number;
            if (self.Vjust == VJUST_CENTER)
            {
                posy -= (self._height / 2);
            }
            else if (self.Vjust == VJUST_BOTTOM)
            {
                posy -= self._height;
            }
            
            for(var i = 0; i < texts.size(); i++)
            {
                var text = texts[i];

                var yoffset = 0;
                if (text.Vjust != VJUST_TOP)
                {
                    var h = dc.getFontHeight(text.Font);
                    if (text.Vjust == VJUST_CENTER)
                    {
                        yoffset = (self._height - h) / 2;
                    }
                    if (text.Vjust == VJUST_BOTTOM)
                    {
                        yoffset = self._height - h;
                    }
                }

                dc.setColor(text.Color, text.BackgroundColor);
                dc.drawText(posx, posy + yoffset, text.Font, text.Text, Gfx.TEXT_JUSTIFY_LEFT);
                posx += dc.getTextWidthInPixels(text.Text.toString(), text.Font);
            }
        }

        private function calcDimensions(texts as Array<ExtTextPart>, dc as Gfx.Dc)
        {
            self._width = 0;
            self._height = 0;
            for(var i = 0; i < texts.size(); i++)
            {
                var d = dc.getTextDimensions(texts[i].Text.toString(), texts[i].Font);
                self._width += d[0];
                if (d[1] > self._height)
                {
                    self._height = d[1];
                }
            }
        }
    }

    class ExtTextPart
    {
        var Text as String;
        var Color = Gfx.COLOR_BLACK as Number;
        var Font as FontResource;
        var BackgroundColor = Gfx.COLOR_TRANSPARENT as Number;
        var Vjust = ExtText.VJUST_TOP as ExtText.V_JUSTIFICATION;

        function initialize(text as String, color as Number, font as FontResource)
        {
            self.Text = text;
            self.Color = color;
            self.Font = font;
        }        
    }
}