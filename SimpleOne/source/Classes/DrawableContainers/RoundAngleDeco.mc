import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
using Helper.Gfx as Draw;

module DrawableContainers
{
    class RoundAngleDeco extends Drawable 
    {
        private var _WidgetHeight = 200;
        private var _WidgetWidth = 150;

        private var _indicatorLineWidth = 4;
        private var _indicatorDotRadius = 5;
        private var _indicatorDrawing = null as Draw.DrawRoundAngle;

        function initialize(params as Dictionary)
        {
            Drawable.initialize(params);

            if (params[:Width] != null)
            {
                self._WidgetWidth = params[:Width];
            }

            if (params[:Height] != null)
            {
                self._WidgetHeight = params[:Height];
            }

            self._indicatorDrawing = new Draw.DrawRoundAngle(self.locX, self.locY, self._WidgetWidth, self._WidgetHeight, self._WidgetHeight / 4);
            self._indicatorDrawing.BackgroundColor = getTheme().IndicatorBackground;
            self._indicatorDrawing.Thickness = self._indicatorLineWidth;
            self._indicatorDrawing.DotRadius = self._indicatorDotRadius;
            if (params[:Just] != null && params[:Just].equals("right"))
            {
                self._indicatorDrawing.Direction = Draw.DrawRoundAngle.JUST_TOPRIGHT;
            }
            else
            {
                self._indicatorDrawing.Direction = Draw.DrawRoundAngle.JUST_TOPLEFT;
            }
        }

        function draw(dc as Dc) as Void 
        {
            self._indicatorDrawing.draw(dc, 0);
        }
    }
}