using Helper.Gfx as HGfx;
import Toybox.Lang;
using Toybox.Graphics as Gfx;

module Widgets 
{
    class DecoWidget extends WidgetBase
    {
        private var _indicatorDrawing = null as HGfx.DrawRoundAngle;

        function initialize(params as Dictionary) 
        {
            WidgetBase.initialize(params);

            var width = params.get("W");
            if (width == null)
            {
                width = 130;
            }

            var height = params.get("H");
            if (height == null)
            {
                height = 150;
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

            self._indicatorDrawing = new HGfx.DrawRoundAngle(self.locX, self.locY, width, height);
            if (self.Justification == WIDGET_JUSTIFICATION_RIGHT)
            {
                if (vertJust == WIDGET_JUSTIFICATION_TOP)
                {
                    self._indicatorDrawing.Direction = HGfx.DrawRoundAngle.JUST_TOPRIGHT;
                }
                else
                {
                    self._indicatorDrawing.Direction = HGfx.DrawRoundAngle.JUST_BOTTOMRIGHT;
                }
            }
            else
            {
                if (vertJust == WIDGET_JUSTIFICATION_TOP)
                {
                    self._indicatorDrawing.Direction = HGfx.DrawRoundAngle.JUST_TOPLEFT;
                }
                else
                {
                    self._indicatorDrawing.Direction = HGfx.DrawRoundAngle.JUST_BOTTOMLEFT;
                }
            }
        }

        function draw(dc as Gfx.Dc) as Void 
        {
            self._indicatorDrawing.draw(dc, 0);
        }  
    }
}