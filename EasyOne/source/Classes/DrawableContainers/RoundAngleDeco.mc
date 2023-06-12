import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
using Helper.Gfx as Draw;

module DrawableContainers
{
    class RoundAngleDeco extends Drawable 
    {
        private var _params = null as Dictionary;
        private var _indicatorDrawing = null as Draw.DrawRoundAngle;

        function initialize(params as Dictionary)
        {
            Drawable.initialize(params);

            self._params = params;
            self.onSettingsChanged();
            $.getApp().OnSettings.add(self.method(:onSettingsChanged));
        }

        function draw(dc as Dc) as Void 
        {
            if (self._indicatorDrawing != null)
            {
                self._indicatorDrawing.draw(dc, 0);
            }
        }

        function onSettingsChanged()
        {
            var show = Application.Properties.getValue("ShowDecolines") as Number;
            if (show != null && show > 0)
            {
                var widgetwidth = 150;
                if (self._params[:Width] != null)
                {
                    widgetwidth = self._params[:Width];
                }

                var widgetheight = 200;
                if (self._params[:Height] != null)
                {
                    widgetheight = self._params[:Height];
                }
                self._indicatorDrawing = new Draw.DrawRoundAngle(self.locX, self.locY, widgetwidth, widgetheight, widgetheight / 4);
                if (self._params[:Just] != null && self._params[:Just].equals("right"))
                {
                    self._indicatorDrawing.Direction = Draw.DrawRoundAngle.JUST_TOPRIGHT;
                }
                else
                {
                    self._indicatorDrawing.Direction = Draw.DrawRoundAngle.JUST_TOPLEFT;
                }
            }
            else
            {
                self._indicatorDrawing = null;
            }
        }
    }
}