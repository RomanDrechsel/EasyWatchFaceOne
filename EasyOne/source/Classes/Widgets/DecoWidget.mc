using Helper.Gfx as HGfx;
import Toybox.Lang;
using Toybox.Graphics as Gfx;

module Widgets 
{
    class DecoWidget extends WidgetBase
    {
        private var _width;
        private var _height;
        private var _pos;

        function initialize(params as Dictionary) 
        {
            WidgetBase.initialize(params);

            self._width = params.get("W");
            if (self._width == null)
            {
                self._width = 130;
            }

            self._height = params.get("H");
            if (self._height == null)
            {
                self._height = 150;
            }

            var vertJust = params.get("V");
            if (vertJust == null)
            {
                vertJust = WIDGET_JUSTIFICATION_TOP;
            }

            if (vertJust != WIDGET_JUSTIFICATION_TOP)
            {
                self.locY = self.locY - height;
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
            HGfx.DrawRoundAngle.Configure(self.locX, self.locY, self._width, self._height, self._pos);
            HGfx.DrawRoundAngle.draw(dc, 0, 0);
        }  
    }
}