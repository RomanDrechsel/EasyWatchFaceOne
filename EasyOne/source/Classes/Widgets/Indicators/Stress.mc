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
        class Stress
        {
            static var _stressLevel = -1.0;

            private var _color = Gfx.COLOR_WHITE;
            private var _iconColor = Gfx.COLOR_WHITE;
            private var _indicatorColor = Gfx.COLOR_WHITE;
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
            }

            function draw(dc as Gfx.Dc, widget as HealthIndicator)
            {
                widget.DrawIcon(dc, HGfx.ICONS_STRESS, self._iconColor);
                var width = widget.DrawText(dc);

                if (self._stressLevel > 0.0)
                {
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

                        dc.setColor(self._color, Graphics.COLOR_TRANSPARENT);
                        dc.drawText(widget.TextContainer.AnchorX - (width / 2) - 5, widget.TextContainer.AnchorY + (Graphics.getFontAscent(HGfx.Fonts.Normal) / 2) + offset, HGfx.Fonts.Icons, icon, Gfx.TEXT_JUSTIFY_RIGHT);
                    }

                    if (self._stressLevel >= widget.StressWarningLevel)
                    {
                        widget.DrawAttentionIcon(dc);
                    }
                    else
                    {
                        widget.HideAttentionIcon();
                    }

                    widget.drawIndicator(dc, self._stressLevel / 100.0, self._indicatorColor);
                }
            }

            function calcColor(widget as HealthIndicator) as Void
            {
                var theme = $.getTheme();

                self._color = Themes.Colors.Text2;
                self._iconColor = theme.IconsOff;
                self._indicatorColor = theme.IconsOff;

                if (Themes.Colors.IconsInTextColor == true)
                {
                    self._iconColor = self._color;
                }
                else
                {
                    self._iconColor = theme.HealthStressIconColor;
                }

                var colors = $.getTheme().IndivatorLevel;
                self._indicatorColor = colors[0];
                if (self._stressLevel >= 60)
                {
                    if (self._stressLevel >= 90)
                    {
                        self._color = colors[3];
                    }
                    else if (self._stressLevel >= 80)
                    {
                        self._color = colors[2];
                    }
                    else
                    {
                        self._color = colors[1];
                    }
                    self._indicatorColor = self._color;
                    self._iconColor = self._color;
                }

                if (self._stressLevel > 0.0)
                {
                    if (widget.Texts == null || widget.Texts.size() < 1)
                    {
                        widget.Texts = [
                            new Helper.ExtTextPart(self._stressLevel.toNumber().toString(), self._color, HGfx.Fonts.Normal),
                        ];
                    }
                    else
                    {
                        widget.Texts[0].Text = self._stressLevel.toNumber().toString();
                        widget.Texts[0].Color = self._color;
                    }

                    if (self._showSampleTime == true && !IsSmallDisplay)
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

                        if (widget.Texts.size() < 2)
                        {
                            widget.Texts.add(new Helper.ExtTextPart(datestr, self._color, HGfx.Fonts.Small));
                        }
                        else
                        {
                            widget.Texts[1].Text = datestr;
                            widget.Texts[1].Color = self._color;
                        }
                    }
                }
                else
                {
                    widget.Texts = null;
                }
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

                /*self._sampleDeltaRise = false;
                self._lastSampleDate = Time.now().subtract(new Time.Duration(345));
                self._stressLevel = 85.0;*/

                return self._stressLevel;
            }
        }
    }
}
