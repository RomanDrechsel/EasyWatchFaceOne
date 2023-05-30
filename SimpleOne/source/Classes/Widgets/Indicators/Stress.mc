import Toybox;
import Toybox.Lang;
using Toybox.Graphics as Gfx;
using Helper.Gfx as Draw;

module Widgets 
{
    module Indicators
    {
        class Stress extends IndicatorBase
        {
            function initialize(widget as Widgets.RandomIndicator)
            {
                IndicatorBase.initialize(widget);
            }

            protected function Init(dc as Gfx.Dc)
            {
                IndicatorBase.Init(dc);
            }

            function draw(dc as Gfx.Dc)
            {
                IndicatorBase.draw(dc);

                var stress = self.getStressLevel();

                var color = self._Widget._theme.IconsOff;
                var iconcolor = self._Widget._theme.IconsOff;
                var indicatorcolor = color;
                if (stress > 0.0)
                {
                    color = self._Widget._theme.MainTextColor;
                    iconcolor = color;
                    indicatorcolor = self._Widget.IndicatorColors[0];
                    if (stress >= 50)
                    {
                        if (stress >= 90)
                        {
                            color = self._Widget.IndicatorColors[3];
                        }
                        else if (stress >= 80)
                        {
                            color = self._Widget.IndicatorColors[2];
                        }
                        else
                        {
                            color = self._Widget.IndicatorColors[1];
                        }
                        indicatorcolor = color;
                        iconcolor = color;
                    }

                    dc.setColor(iconcolor, Gfx.COLOR_TRANSPARENT);
                    dc.drawText(self._iconPosX, self._iconPosY, self._Widget.Icons, Draw.ICONS_STRESS, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
                    dc.setColor(color, Gfx.COLOR_TRANSPARENT);
                    dc.drawText(self._textPosX, self._textPosY, self._Widget.Font, stress.toNumber().toString(), Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
                }
                else
                {
                    dc.setColor(color, Gfx.COLOR_TRANSPARENT);
                    dc.drawText(self._iconPosX, self._iconPosY, self._Widget.Icons, Draw.ICONS_STRESS, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
                    dc.drawText(self._textPosX, self._textPosY, self._Widget.Font, "-", Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
                }

                self._Widget.IndicatorDrawing.drawWithColor(dc, stress / 100.0, indicatorcolor);
            }

            static function getStressLevel() as Float
            {
                if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getStressHistory)) 
                {
                    var hist = Toybox.SensorHistory.getStressHistory({ "period" => 1, "order" => Toybox.SensorHistory.ORDER_NEWEST_FIRST});
                    var sample = hist.next();
                    if (sample != null)
                    {
                        return sample.data;
                    }
                }

                return -1.0;
            }
        }
    }
}
