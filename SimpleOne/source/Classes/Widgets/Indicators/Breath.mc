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
            private var _lastRespirationRate = 0.0 as Float;

            private var _textContainer = null as Helper.ExtText;
            private var _texts = [] as Array<Helper.ExtTextPart>;

            function initialize(widget as Widgets.RandomIndicator)
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
                if (breath < 0.0 && self._lastRespirationRate > 0.0)
                {
                    breath = self._lastRespirationRate;
                }
                
                if (breath > 0.0)
                {
                    self._lastRespirationRate = breath;
                }

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
                    //dc.setColor(color, Gfx.COLOR_TRANSPARENT);
                    //dc.drawText(self._textPosX, self._textPosY, HGfx.Fonts.Small, breath.toString(), Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
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
                    return info.respirationRate;
                }

                return -1;
            }
        }
    }
}