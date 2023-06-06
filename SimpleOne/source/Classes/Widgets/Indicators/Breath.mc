import Toybox.Lang;
using Toybox.Graphics as Gfx;
using Helper.Gfx as HGfx;

module Widgets 
{
    module Indicators
    {
        class Breath extends IndicatorBase
        {
            static var MaxRespirationRate = 40.0;
            private static var _lastRespirationRate = null as Float;
            private static var _lastSample = null as Toybox.Time.Moment;

            private static const SAMPLE_VALID = 300; //old samples are valid for 5 min

            private var _textContainer = null as Helper.ExtText;
            private var _texts = [] as Array<Helper.ExtTextPart>;

            function initialize(widget as Widgets.HealthIndicator)
            {
                IndicatorBase.initialize(widget);
            }

            protected function Init(dc as Gfx.Dc)
            {
                IndicatorBase.Init(dc);
                self._textContainer = new Helper.ExtText(self._textPosX, self._textPosY, Helper.ExtText.HJUST_CENTER, Helper.ExtText.VJUST_CENTER);
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
                    iconcolor = color;
                    indicatorcolor = self._Widget.IndicatorColors[0];
                    if (breath >= 20)
                    {
                        if (breath > self.MaxRespirationRate)
                        {
                            color = self._Widget.IndicatorColors[3];
                        }
                        else if (breath > self.MaxRespirationRate - 10)
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
                    dc.drawText(self._iconPosX, self._iconPosY, HGfx.Fonts.Icons, HGfx.ICONS_BREATH, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
                    if (self._texts.size() < 2)
                    {
                        self._texts = [
                            new Helper.ExtTextPart(breath.toString(), color, HGfx.Fonts.Normal),
                            new Helper.ExtTextPart(" brpm", color, HGfx.Fonts.Small)
                        ];
                        self._texts[1].Vjust = Helper.ExtText.VJUST_BOTTOM;
                    }
                    else
                    {
                        self._texts[0].Text = breath.toString();
                        self._texts[0].Color = color;
                        self._texts[1].Color = color;
                    }
                    
                    self._textContainer.draw(self._texts, dc);
                }
                else
                {
                    dc.setColor(color, Gfx.COLOR_TRANSPARENT);
                    dc.drawText(self._iconPosX, self._iconPosY, HGfx.Fonts.Icons, HGfx.ICONS_BREATH, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
                    dc.drawText(self._textPosX, self._textPosY, HGfx.Fonts.Normal, "-", Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
                }

                self._Widget.IndicatorDrawing.drawWithColor(dc, breath.toFloat() / self.MaxRespirationRate, indicatorcolor);
            }

            static function getBreath() as Number
            {
                var info = Toybox.ActivityMonitor.getInfo();
                if (info.respirationRate != null)
                {
                    self._lastRespirationRate = info.respirationRate;
                    self._lastSample = Toybox.Time.now();
                    return self._lastRespirationRate;
                }
                else if (self._lastSample != null && self._lastRespirationRate != null && Toybox.Time.now().subtract(self._lastSample).value() <= self.SAMPLE_VALID)
                {
                    //last RespirationRate is valid 
                    return self._lastRespirationRate;
                }

                return -1;
            }
        }
    }
}