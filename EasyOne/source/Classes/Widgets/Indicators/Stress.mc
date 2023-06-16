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

            private static const SAMPLE_VALID = 1200; //old samples are valid for 20 min
            private static var _lastSample = null as Toybox.Time.Moment;
            private var _showSampleTime = true;

            function initialize(widget as Widgets.HealthIndicator)
            {
                IndicatorBase.initialize(widget);
                var setting = Application.Properties.getValue("ShowStressAge") as Number;
                if (setting != null && setting <= 0)
                {
                    self._showSampleTime = false;
                }
                else
                {
                    self._showSampleTime = true;
                }
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
                    iconcolor = self._Widget._theme.HealthStressIconColor;
                    indicatorcolor = self._Widget.IndicatorColors[0];
                    if (stress >= 60)
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
                    if (self._showSampleTime == false)
                    {
                        dc.setColor(color, Gfx.COLOR_TRANSPARENT);
                        dc.drawText(self._textPosX, self._textPosY, HGfx.Fonts.Normal, stress.toNumber().toString(), Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
                    }
                    else
                    {
                        var datestr = "";
                        if (self._lastSample != null)
                        {
                            var ts = Time.now().subtract(self._lastSample).value();
                            var datestr = " (~" + (ts/60) + "m)";
                        }

                        if (self._texts.size() < 2)
                        {
                            self._texts = [
                                new Helper.ExtTextPart(stress.toNumber().toString(), color, HGfx.Fonts.Normal),
                                new Helper.ExtTextPart(datestr, color, HGfx.Fonts.Tiny)
                            ];
                            self._texts[1].Vjust = Helper.ExtText.VJUST_BOTTOM;
                        }
                        else
                        {
                            self._texts[0].Text = stress.toNumber().toString();
                            self._texts[0].Color = color;
                            self._texts[1].Text = datestr;
                            self._texts[1].Color = color;                            
                        }
                        self._textContainer.draw(self._texts, dc);
                    }

                    if (stress >= self._Widget.StressWarningLevel)
                    {
                        self._Widget.DrawAttentionIcon(dc, self._iconPosX, self._iconPosY);
                    }
                    else
                    {
                        self._Widget.HideAttentionIcon();
                    }
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
                /*self._lastSample = Time.now().subtract(new Time.Duration(100));
                return 95;*/
                if ((Toybox has :SensorHistory) && (SensorHistory has :getStressHistory)) 
                {
                    var hist = SensorHistory.getStressHistory({ "period" => 1, "order" => SensorHistory.ORDER_NEWEST_FIRST});
                    var sample = hist.next();
                    self._lastSample = sample.when;
                    if (sample != null && Time.now().subtract(sample.when).value() <= self.SAMPLE_VALID)
                    {
                        return sample.data;
                    }
                }

                return -1.0;
            }
        }
    }
}
