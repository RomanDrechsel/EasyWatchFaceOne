using Helper.Gfx as HGfx;
import Toybox.Lang;
using Toybox.Graphics as Gfx;

module Widgets 
{
    class DecoRoundAngle extends WidgetBase
    {
        private var _indicatorDrawing = null as HGfx.DrawRoundAngle;
        private var WidgetHeight = 200;
        private var WidgetWidth = 150;

        function initialize(params as Dictionary) 
        {
            WidgetBase.initialize(params);

            if (params[:Width] != null)
            {
                self.WidgetWidth = params[:Width];
            }

            if (params[:Height] != null)
            {
                self.WidgetHeight = params[:Height];
            }

            var indicatorPosX = self.locX;
            self.locY = self.locY - self.WidgetHeight;
            if (self.Justification == WIDGET_JUSTIFICATION_RIGHT)
            {
                indicatorPosX = self.locX;
                self.locX = self.locX - self.WidgetWidth;
            }

            self._indicatorDrawing = new HGfx.DrawRoundAngle(indicatorPosX, self.locY, self.WidgetWidth, self.WidgetHeight, self.WidgetHeight / 4);
            if (self.Justification == WIDGET_JUSTIFICATION_RIGHT)
            {
                self._indicatorDrawing.Direction = HGfx.DrawRoundAngle.JUST_BOTTOMRIGHT;
                
            }
            else
            {
                self._indicatorDrawing.Direction = HGfx.DrawRoundAngle.JUST_BOTTOMLEFT;
            }
        }

        function draw(dc as Gfx.Dc) as Void 
        {
            self._indicatorDrawing.draw(dc, 0);
        }  
    }
}