using Helper.Gfx as HGfx;
import Toybox.Lang;
using Toybox.Graphics as Gfx;

module Widgets
{
    class DecoWidget extends WidgetBase
    {
        private var _size;
        private var _pos;

        function initialize(params as Dictionary)
        {
            WidgetBase.initialize(params);

            self._size = params.get("W");
            if (self._size == null)
            {
                self._size = 130;
            }

            var vertJust = params.get("V");
            if (vertJust == null)
            {
                vertJust = WIDGET_JUSTIFICATION_TOP;
            }

            if (vertJust != WIDGET_JUSTIFICATION_TOP)
            {
                self.locY = self.locY - self._size;
            }

            if (self.Justification == WIDGET_JUSTIFICATION_RIGHT)
            {
                if (vertJust == WIDGET_JUSTIFICATION_TOP)
                {
                    self._pos = HGfx.DrawRoundAngle.JUST_TOPRIGHT;
                }
                else
                {
                    self._pos = HGfx.DrawRoundAngle.JUST_BOTTOMRIGHT;
                }
            }
            else
            {
                if (vertJust == WIDGET_JUSTIFICATION_TOP)
                {
                    self._pos = HGfx.DrawRoundAngle.JUST_TOPLEFT;
                }
                else
                {
                    self._pos = HGfx.DrawRoundAngle.JUST_BOTTOMLEFT;
                }
            }
        }

        function draw(dc as Gfx.Dc) as Void
        {
            HGfx.DrawRoundAngle.Configure(self.locX, self.locY, self._size, self._size, self._pos);
            HGfx.DrawRoundAngle.draw(dc, 0.0, 0);
        }
    }
}
