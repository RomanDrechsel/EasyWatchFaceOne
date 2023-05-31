import Toybox;
import Toybox.Lang;
using Toybox.Graphics as Gfx;
using Helper.Gfx as HGfx;
using Toybox.Time.Gregorian as D;

module Widgets 
{
    module Indicators
    {
        class Stress extends IndicatorBase
        {
            private var _textContainer = null as Helper.ExtText;
            private var _texts = [] as Array<Helper.ExtTextPart>;
            private static var _lastSample = null as Time.Moment;

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
                    dc.drawText(self._iconPosX, self._iconPosY, HGfx.Fonts.Icons, HGfx.ICONS_STRESS, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
                    //dc.setColor(color, Gfx.COLOR_TRANSPARENT);
                    //dc.drawText(self._textPosX, self._textPosY, HGfx.Fonts.Small, stress.toNumber().toString(), Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);

                    var sampletime = "";
                    if (self._lastSample != null)
                    {
                        var info = D.info(self._lastSample, Time.FORMAT_SHORT);
                        sampletime = info.hour.format("%02d") + ":" + info.min.format("%02d");
                    }

                    if (self._texts.size() < 2)
                    {
                        self._texts = [
                            new Helper.ExtTextPart(stress.toNumber().toString(), color, HGfx.Fonts.Normal),
                            new Helper.ExtTextPart(sampletime, color, HGfx.Fonts.Small)
                        ];
                        self._texts[1].Vjust = Helper.ExtText.VJUST_BOTTOM;
                    }
                    else
                    {
                        self._texts[0].Text = stress.toNumber().toString();
                        self._texts[1].Text = sampletime;
                    }
                    self._textContainer.draw(self._texts, dc);
                }
                else
                {
                    dc.setColor(color, Gfx.COLOR_TRANSPARENT);
                    dc.drawText(self._iconPosX, self._iconPosY, HGfx.Fonts.Icons, HGfx.ICONS_STRESS, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
                    dc.drawText(self._textPosX, self._textPosY, HGfx.Fonts.Normal, "-", Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
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
                        self._lastSample = sample.when;
                        return sample.data;
                    }
                }

                return -1.0;
            }
        }
    }
}
