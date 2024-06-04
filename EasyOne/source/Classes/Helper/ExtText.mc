import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

module Helper {
    class ExtText {
        var AnchorX as Number;
        var AnchorY as Number;

        private var _just = Graphics.TEXT_JUSTIFY_CENTER;

        function initialize(posx as Number, posy as Number, just as Graphics.TextJustification) {
            self.AnchorX = posx;
            self.AnchorY = posy;
            self._just = just;
        }

        function draw(texts as Array<ExtTextPart>, dc as Graphics.Dc) as Number {
            if (texts.size() == 0) {
                return;
            }

            var dim = self.calcDimensions(texts, dc);
            if (dim[0] <= 0 || dim[1] <= 0) {
                return;
            }

            var posx = self.AnchorX;
            if (self._just == Graphics.TEXT_JUSTIFY_CENTER) {
                posx -= dim[0] / 2;
            } else if (self._just == Graphics.TEXT_JUSTIFY_RIGHT) {
                posx -= dim[0];
            }

            for (var i = 0; i < texts.size(); i++) {
                var text = texts[i];
                if (text.Text == null || text.Text.length() <= 0) {
                    continue;
                }
                var yoffset = dim[1] - Graphics.getFontAscent(text.Font);
                if (IsSmallDisplay) {
                    yoffset *= 1.2;
                }

                dc.setColor(text.Color, Graphics.COLOR_TRANSPARENT);
                dc.drawText(posx, self.AnchorY + yoffset, text.Font, text.Text, Graphics.TEXT_JUSTIFY_LEFT);
                posx += dc.getTextWidthInPixels(text.Text.toString(), text.Font);
            }

            return dim[0];
        }

        static function calcDimensions(texts as Array<ExtTextPart>, dc as Graphics.Dc) as Array<Number> {
            var totalwidth = 0;
            var totalheight = 0;
            for (var i = 0; i < texts.size(); i++) {
                if (texts[i].Text == null || texts[i].Text.length() <= 0) {
                    continue;
                }
                var width = dc.getTextWidthInPixels(texts[i].Text.toString(), texts[i].Font);
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
        var Text as Lang.String?;
        var Color as Number;
        var Font as FontResource;

        function initialize(text as Lang.String?, color as Number, font as FontResource) {
            self.Text = text;
            self.Color = color;
            self.Font = font;
        }
    }
}
