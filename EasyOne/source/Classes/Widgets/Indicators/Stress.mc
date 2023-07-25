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

            private static const SAMPLE_VALID = 600; //old samples are valid for 10 min
            private static var _sampleDelta = 0.0;
            private static var _showSampleTime = true;
            private static var _lastSampleDate = null as Toybox.Time.Moment;
            private static var _stressLevel = -1.0;

            function initialize(widget as Widgets.HealthIndicator)
            {
                IndicatorBase.initialize(widget);
                if (!IsSmallDisplay)
                {
                    var setting = Application.Properties.getValue("StressAge") as Number;
                    if (setting != null && setting <= 0)
                    {
                        self._showSampleTime = false;
                    }
                    else
                    {
                        self._showSampleTime = true;
                    }
                }
                else
                {
                    self._showSampleTime = false;
                }

                $.getView().OnWakeUp.add(self.method(:OnWakeUp));
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
                    color = Themes.Colors.Text2;
                    if (Themes.Colors.IconsInTextColor == true)
                    {
                        iconcolor = color;
                    }
                    else
                    {
                        iconcolor = self._Widget._theme.HealthStressIconColor;
                    }
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
                        if (self._lastSampleDate != null)
                        {
                            var ts = Time.now().subtract(self._lastSampleDate).value();
                            if (ts > 120)
                            {
                                datestr = " (~" + (ts/60) + "m)";
                            }
                        }

                        if (!IsSmallDisplay)
                        {
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
                        }
                        else
                        {
                            //No datestr on small devices
                            if (self._texts.size() < 1)
                            {
                                self._texts = [
                                    new Helper.ExtTextPart(stress.toNumber().toString(), color, HGfx.Fonts.Normal),
                                ];
                            }
                            else
                            {
                                self._texts[0].Text = stress.toNumber().toString();
                                self._texts[0].Color = color;                       
                            }
                        }
                        var width = self._textContainer.draw(self._texts, dc);
                        if (self._sampleDelta != 0.0)
                        {
                            var icon = "";
                            if (self._sampleDelta < 0.0)
                            {
                                icon = HGfx.ICONS_ARROWDOWN;
                            }
                            else
                            {
                                icon = HGfx.ICONS_ARROWUP;
                            }

                            var yOffset;
                            if (IsSmallDisplay)
                            {
                                yOffset = 14;
                            }
                            else
                            {
                                yOffset = 10;
                            }

                            dc.drawText(self._textPosX - (width / 2) - 5, self._textPosY + yOffset, HGfx.Fonts.Icons, icon, Gfx.TEXT_JUSTIFY_RIGHT | Gfx.TEXT_JUSTIFY_VCENTER);
                        }
                    }

                    if (stress >= self._Widget.StressWarningLevel)
                    {
                        self._Widget.DrawAttentionIcon(dc, self._iconPosX - 7, self._iconPosY);
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

            function OnWakeUp()
            {
                if ((Toybox has :SensorHistory) && (SensorHistory has :getStressHistory)) 
                {
                    var hist = SensorHistory.getStressHistory({ "period" => 2, "order" => SensorHistory.ORDER_NEWEST_FIRST});
                    var newest_sample = hist.next();
                    var prev_sample = hist.next();
                    if (newest_sample != null && Time.now().subtract(newest_sample.when).value() <= self.SAMPLE_VALID)
                    {
                        if (prev_sample != null && newest_sample.when.subtract(prev_sample.when).value() <= self.SAMPLE_VALID)
                        {
                            self._sampleDelta = newest_sample.data - prev_sample.data;
                        }
                        else
                        {
                            self._sampleDelta = 0.0;
                            self._lastSampleDate = null;
                        }
                        
                        self._stressLevel = newest_sample.data;
                    }
                    else
                    {
                        self._sampleDelta = 0.0;
                        self._lastSampleDate = null;
                    }
                }

                self._stressLevel = -1.0;
            }

            static function getStressLevel() as Float
            {
                return self._stressLevel;
            }
        }
    }
}
