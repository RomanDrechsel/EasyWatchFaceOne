import Toybox;
import Toybox.Lang;
import Widgets;
using Toybox.Graphics as Gfx;
using Helper.Gfx as HGfx;
using Toybox.Time.Gregorian as D;

module Widgets 
{
    module Indicators
    {
        class Stress extends IndicatorBase
        {
            static var _stressLevel = -1.0;

            private var _textContainer = null as Helper.ExtText;
            private var _texts = [] as Array<Helper.ExtTextPart>;

            private static var _sampleDeltaRise = null;
            private static var _showSampleTime = true;
            private static var _showDelta = true;
            private static var _lastSampleDate = null as Toybox.Time.Moment;

            function initialize()
            {
                if (!IsSmallDisplay)
                {
                    var setting = Application.Properties.getValue("StressA") as Number;
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

                var setting = Application.Properties.getValue("StressD") as Number;
                if (setting != null && setting <= 0)
                {
                    self._showDelta = false;
                }
                else
                {
                    self._showDelta = true;
                }

                $.getView().OnWakeUp.add(self);
            }

            protected function Init(dc as Gfx.Dc, widget as HealthIndicator)
            {
                IndicatorBase.Init(dc, widget);
                self._textContainer = new Helper.ExtText(self._textPosX, self._textPosY, Helper.ExtText.HJUST_CENTER, Helper.ExtText.VJUST_TOP);
            }

            function draw(dc as Gfx.Dc, widget as HealthIndicator)
            {
                IndicatorBase.draw(dc, widget);

                var stress = self.getStressLevel();
                var theme = $.getTheme();

                var color = theme.IconsOff;
                var iconcolor = theme.IconsOff;
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
                        iconcolor = theme.HealthStressIconColor;
                    }

                    var colors = $.getTheme().IndivatorLevel;
                    indicatorcolor = colors[0];
                    if (stress >= 60)
                    {
                        if (stress >= 90)
                        {
                            color = colors[3];
                        }
                        else if (stress >= 80)
                        {
                            color = colors[2];
                        }
                        else
                        {
                            color = colors[1];
                        }
                        indicatorcolor = color;
                        iconcolor = color;
                    }

                    dc.setColor(iconcolor, Gfx.COLOR_TRANSPARENT);
                    dc.drawText(self._iconPosX, self._iconPosY, HGfx.Fonts.Icons, HGfx.ICONS_STRESS, Gfx.TEXT_JUSTIFY_CENTER);

                    var width;

                    if (self._showSampleTime == false)
                    {
                        dc.setColor(color, Gfx.COLOR_TRANSPARENT);
                        dc.drawText(self._textPosX, self._textPosY, HGfx.Fonts.Normal, stress.toNumber().toString(), Gfx.TEXT_JUSTIFY_CENTER);
                        width = dc.getTextWidthInPixels(stress.toNumber().toString(), HGfx.Fonts.Normal);
                    }
                    else
                    {
                        var datestr = "";
                        if (self._lastSampleDate != null)
                        {
                            var ts = Time.now().subtract(self._lastSampleDate).value();
                            if (ts > 120)
                            {
                                datestr = " (" + (ts/60) + "m)";
                            }
                        }

                        if (!IsSmallDisplay)
                        {
                            if (self._texts.size() < 2)
                            {
                                self._texts = [
                                    new Helper.ExtTextPart(stress.toNumber().toString(), color, HGfx.Fonts.Normal),
                                    new Helper.ExtTextPart(datestr, color, HGfx.Fonts.Small)
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
                        
                        width = self._textContainer.draw(self._texts, dc);
                    }
                    if (self._showDelta && self._sampleDeltaRise != null)
                    {
                        var icon = "";
                        if (_sampleDeltaRise == false)
                        {
                            icon = HGfx.ICONS_ARROWDOWN;
                        }
                        else
                        {
                            icon = HGfx.ICONS_ARROWUP;
                        }

                        var offset = -5;
                        if (IsSmallDisplay)
                        {
                            offset = -3;
                        }

                        dc.drawText(self._textPosX - (width / 2) - 5, self._textPosY + (Graphics.getFontAscent(HGfx.Fonts.Normal) / 2) + offset, HGfx.Fonts.Icons, icon, Gfx.TEXT_JUSTIFY_RIGHT);
                    }

                    if (stress >= widget.StressWarningLevel)
                    {
                        var offset = 12;
                        if (IsSmallDisplay)
                        {
                            offset = 18;
                        }
                        widget.DrawAttentionIcon(dc, self._iconPosX - 7, self._iconPosY + offset);
                    }
                    else
                    {
                        widget.HideAttentionIcon();
                    }
                }
                else
                {
                    dc.setColor(color, Gfx.COLOR_TRANSPARENT);
                    dc.drawText(self._iconPosX, self._iconPosY, HGfx.Fonts.Icons, HGfx.ICONS_STRESS, Gfx.TEXT_JUSTIFY_CENTER);
                    dc.drawText(self._textPosX, self._textPosY, HGfx.Fonts.Normal, "-", Gfx.TEXT_JUSTIFY_CENTER);
                }

                widget.drawIndicator(dc, stress / 100.0, indicatorcolor);
            }

            function OnWakeUp()
            {
                self.getStressLevel();
            }

            static function getStressLevel() as Float
            {
                //SAMPLE_VALID = 600
                if (self._lastSampleDate != null && Time.now().subtract(self._lastSampleDate).value() > 5)
                {
                    if ((Toybox has :SensorHistory) && (SensorHistory has :getStressHistory)) 
                    {
                        var hist = SensorHistory.getStressHistory({ "period" => 2, "order" => SensorHistory.ORDER_NEWEST_FIRST});
                        var newest_sample = hist.next();
                        var prev_sample = hist.next();
                        if (newest_sample != null && Time.now().subtract(newest_sample.when).value() <= 600)
                        {
                            if (prev_sample != null && newest_sample.when.subtract(prev_sample.when).value() <= 600)
                            {
                                if (newest_sample.data > prev_sample.data)
                                {
                                    self._sampleDeltaRise = true;
                                }
                                else if (newest_sample.data < prev_sample.data)
                                {
                                    self._sampleDeltaRise = false;
                                }
                                else
                                {
                                    self._sampleDeltaRise = null;
                                }
                            }
                            else
                            {
                                self._sampleDeltaRise = null;
                                self._lastSampleDate = null;
                            }
                            
                            self._stressLevel = newest_sample.data;
                            self._lastSampleDate = newest_sample.when;
                        }
                        else
                        {
                            self._sampleDeltaRise = null;
                            self._lastSampleDate = null;
                            self._stressLevel = -1.0;
                        }
                    }
                    else
                    {
                        self._sampleDeltaRise = null;
                        self._lastSampleDate = null;
                        self._stressLevel = -1.0;
                    }
                }

                /*self._sampleDeltaRise = true;
                self._lastSampleDate = Time.now().subtract(new Time.Duration(345));
                self._stressLevel = 85.0;*/

                return self._stressLevel;
            }
        }
    }
}
