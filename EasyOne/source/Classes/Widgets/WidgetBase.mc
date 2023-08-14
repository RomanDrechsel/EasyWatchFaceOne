using Toybox.Graphics as Gfx;
import Toybox.Lang;

module Widgets 
{   
    enum { WIDGET_JUSTIFICATION_LEFT = 0, WIDGET_JUSTIFICATION_RIGHT, WIDGET_JUSTIFICATION_CENTER, WIDGET_JUSTIFICATION_TOP, WIDGET_JUSTIFICATION_BOTTOM }

    class WidgetBase
    {
        var locX = 0.0;
        var locY = 0.0;
        var Justification = WIDGET_JUSTIFICATION_LEFT;

        function initialize(container_params as Dictionary)
        {
            var posx = container_params.get("X");
            if (posx != null)
            {
                self.locX = posx.toFloat();
            }
            var posy = container_params.get("Y");
            if (posy != null)
            {
                self.locY = posy.toFloat();
            }

            var just = container_params.get("J") as Number;
            if (just != null)
            {
                self.Justification = just;
            }
        }
    }
}