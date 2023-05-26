import Toybox.Lang;
using Toybox.Graphics as Gfx;
using Helper.Gfx as Draw;

module Widgets 
{
    module Indicators
    {
        class Stress extends IndicatorBase
        {
            private var _stressColors = [
                0x00ad15,
                0xf7fa00,
                0xfa7a00,
                0xfa0000
            ];

            function initialize(widget as Widgets.Heartbeat)
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
                if (stress > 0)
                {
                    color = self._Widget._theme.MainTextColor;
                    iconcolor = color;
                    indicatorcolor = self._stressColors[0];
                    if (stress >= 50)
                    {
                        if (stress >= 90)
                        {
                            color = self._stressColors[3];
                        }
                        else if (stress >= 80)
                        {
                            color = self._stressColors[2];
                        }
                        else
                        {
                            color = self._stressColors[1];
                        }
                        indicatorcolor = color;
                    }

                    dc.setColor(iconcolor, Gfx.COLOR_TRANSPARENT);
                    dc.drawText(self._iconPosX, self._iconPosY, self._Widget._Icons, Draw.ICONS_STRESS, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
                    dc.setColor(color, Gfx.COLOR_TRANSPARENT);
                    dc.drawText(self._textPosX, self._textPosY, self._Widget._Font, stress.toString(), Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
                }
                else
                {
                    dc.setColor(color, Gfx.COLOR_TRANSPARENT);
                    dc.drawText(self._iconPosX, self._iconPosY, self._Widget._Icons, Draw.ICONS_STRESS, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
                    dc.drawText(self._textPosX, self._textPosY, self._Widget._Font, "-", Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
                }

                self._Widget._indicatorDrawing.drawWithColor(dc, stress / 100, indicatorcolor);
            }

            static function getStressLevel() as Number
            {
                if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getStressHistory)) 
                {
                    var hist = Toybox.SensorHistory.getStressHistory({ "period" => 1, "order" => Toybox.SensorHistory.ORDER_NEWEST_FIRST});
                    var sample = hist.next();
                    if (sample != null)
                    {
                        return sample.data.toNumber();
                    }
                }

                return -1;
            }
        }
    }
}
