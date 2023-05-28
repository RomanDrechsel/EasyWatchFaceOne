import Toybox.Lang;
using Toybox.Graphics as Gfx;
using Helper.Gfx as Draw;

module Widgets 
{
    module Indicators
    {
        class Breath extends IndicatorBase
        {
            static var MaxRespirationRate = 40.0;

            private var _BreathColors = [
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
            
                var breath = self.getBreath();

                var color = self._Widget._theme.IconsOff;
                var iconcolor = self._Widget._theme.IconsOff;
                var indicatorcolor = color;
                if (breath > 0.0)
                {
                    color = self._Widget._theme.MainTextColor;
                    indicatorcolor = self._stressColors[0];
                    if (breath >= 20)
                    {
                        if (breath > self.MaxRespirationRate)
                        {
                            color = self._stressColors[3];
                        }
                        else if (breath > self.MaxRespirationRate - 10)
                        {
                            color = self._stressColors[2];
                        }
                        else
                        {
                            color = self._stressColors[1];
                        }
                        indicatorcolor = color;
                        iconcolor = color;
                    }

                    dc.setColor(iconcolor, Gfx.COLOR_TRANSPARENT);
                    dc.drawText(self._iconPosX, self._iconPosY, self._Widget._Icons, Draw.ICONS_BREATH, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
                    dc.setColor(color, Gfx.COLOR_TRANSPARENT);
                    dc.drawText(self._textPosX, self._textPosY, self._Widget._Font, breath.toString(), Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
                }
                else
                {
                    dc.setColor(color, Gfx.COLOR_TRANSPARENT);
                    dc.drawText(self._iconPosX, self._iconPosY, self._Widget._Icons, Draw.ICONS_BREATH, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
                    dc.drawText(self._textPosX, self._textPosY, self._Widget._Font, "-", Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
                }

                self._Widget._indicatorDrawing.drawWithColor(dc, breath.toFloat() / self.MaxRespirationRate, indicatorcolor);
            }

            static function getBreath() as Number
            {
                return 30;
                
                var info = Toybox.ActivityMonitor.getInfo();
                if (info.respirationRate != null)
                {
                    return info.respirationRate;
                }

                return -1;
            }
        }
    }
}