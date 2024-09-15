import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

module Helper {
    class ExtText {
        var AnchorX as Number;
        var AnchorY as Number;

        private var _just as Graphics.TextJustification;

        function initialize(posx as Number, posy as Number, just as Graphics.TextJustification) {
            self.AnchorX = posx;
            self.AnchorY = posy;
            self._just = just;
        }

        function draw(texts as Array<ExtTextPart>, dc as Graphics.Dc) as Number {
            if (texts.size() == 0) {
                return 0;
            }

            var dim = self.calcDimensions(texts, dc);
            if (dim[0] <= 0 || dim[1] <= 0) {
                return 0;
            }

            var posx = self.AnchorX;
            if (self._just == Graphics.TEXT_JUSTIFY_CENTER) {
                posx -= dim[0] / 2;
            } else if (self._just == Graphics.TEXT_JUSTIFY_RIGHT) {
                posx -= dim[0];
            }

            for (var i = 0; i < texts.size(); i++) {
                var text = texts[i];
                if (text.Text == null || text.Text.length() == 0 || text.Font == null) {
                    continue;
                }
                var yoffset = dim[1] - Graphics.getFontAscent(text.Font);
                if ($.IsSmallDisplay) {
                    yoffset *= 1.2;
                }

                if (text.Color != null) {
                    dc.setColor(text.Color, Graphics.COLOR_TRANSPARENT);
                }
                dc.drawText(posx, self.AnchorY + yoffset, text.Font, text.Text, Graphics.TEXT_JUSTIFY_LEFT);
                posx += dc.getTextWidthInPixels(text.Text, text.Font);
            }

            return dim[0];
        }

        static function calcDimensions(texts as Array<ExtTextPart>, dc as Graphics.Dc) as Array<Number> {
            var totalwidth = 0;
            var totalheight = 0;
            for (var i = 0; i < texts.size(); i++) {
                if (texts[i].Text == null || texts[i].Text.length() == 0) {
                    continue;
                }
                var width = dc.getTextWidthInPixels(texts[i].Text, texts[i].Font);
                var height = Graphics.getFontAscent(texts[i].Font);
                totalwidth += width;
                if (height > totalheight) {
                    totalheight = height;
                }
            }

            return [totalwidth, totalheight];
        }
    }

    class ExtTextPart {
        var Text as String?;
        var Color as Number?;
        var Font as FontResource?;

        function initialize(text as String?, color as Number?, font as FontResource?) {
            self.Text = text;
            self.Color = color;
            self.Font = font;
        }
    }
}
