import Toybox;
import Toybox.Lang;
import Widgets;
using Toybox.Graphics as Gfx;
using Helper.Gfx as HGfx;
using Toybox.Time.Gregorian as D;

module Widgets {
    module Indicators {
        class Stress {
            var Name = "Stress";
            static var _stressLevel = 0;
            private var _color = Gfx.COLOR_WHITE;
            private var _iconColor = Gfx.COLOR_WHITE;
            private var _indicatorColor = Gfx.COLOR_WHITE;
            private static var _sampleDeltaRise as Boolean? = null;
            private static var _showSampleTime as Boolean;
            private static var _showDelta as Boolean;
            private static var _lastSampleDate as Toybox.Time.Moment? = null;
            function initialize() {
                self._showSampleTime = !IsSmallDisplay && (Helper.Properties.Get("StressA", 0) as Number) > 0;
                self._showDelta = (Helper.Properties.Get("StressD", 1) as Number) > 0;
            }

            function draw(dc as Gfx.Dc, widget as HealthIndicator) {
                if (HGfx.Fonts.Icons == null || HGfx.Fonts.Normal == null) {
                    return;
                }
                widget.DrawIcon(dc, HGfx.ICONS_STRESS, self._iconColor);
                var width = widget.DrawText(dc);

                if (self._stressLevel > 0) {
                    //delta icon
                    if (self._showDelta && self._sampleDeltaRise != null) {
                        var icon = self._sampleDeltaRise ? HGfx.ICONS_ARROWUP : HGfx.ICONS_ARROWDOWN;
                        var offset = IsSmallDisplay ? -3 : -5;

                        dc.setColor(self._color, Graphics.COLOR_TRANSPARENT);
                        dc.drawText(widget.TextContainer.AnchorX - (width / 2).toNumber() - 5, widget.TextContainer.AnchorY + (Graphics.getFontAscent(HGfx.Fonts.Normal) / 2).toNumber() + offset, HGfx.Fonts.Icons, icon, Gfx.TEXT_JUSTIFY_RIGHT);
                    }

                    if (self._stressLevel >= widget.StressWarningLevel) {
                        widget.DrawAttentionIcon(dc);
                    } else {
                        widget.HideAttentionIcon();
                    }

                    widget.drawIndicator(dc, self._stressLevel.toFloat() / 100.0, self._indicatorColor);
                }
            }

            function calcColor(widget as HealthIndicator) {
                var theme = $.getTheme();

                self._color = Themes.Colors.Text2;
                self._indicatorColor = theme.IconsOff;
                self._iconColor = Themes.Colors.IconsInTextColor ? self._color : theme.HealthStressIconColor;

                var colors = $.getTheme().IndivatorLevel;
                self._indicatorColor = colors[0];
                if (self._stressLevel >= 60) {
                    if (self._stressLevel >= 90) {
                        self._color = colors[3];
                    } else if (self._stressLevel >= 80) {
                        self._color = colors[2];
                    } else {
                        self._color = colors[1];
                    }
                    self._indicatorColor = self._color;
                    self._iconColor = self._color;
                }

                if (self._stressLevel > 0 && HGfx.Fonts.Normal != null) {
                    if (widget.Texts == null || widget.Texts.size() < 1) {
                        widget.Texts = [new Helper.ExtTextPart(self._stressLevel.toString(), self._color, HGfx.Fonts.Normal)];
                    } else {
                        widget.Texts[0].Text = self._stressLevel.toString();
                        widget.Texts[0].Color = self._color;
                    }

                    if (self._showSampleTime == true && !IsSmallDisplay && HGfx.Fonts.Small != null) {
                        var datestr = "";
                        if (self._lastSampleDate != null) {
                            var ts = Time.now().subtract(self._lastSampleDate).value();
                            if (ts > 120) {
                                datestr = " (" + (ts / 60).toNumber() + "m)";
                            }
                        }

                        if (widget.Texts.size() < 2) {
                            widget.Texts.add(new Helper.ExtTextPart(datestr, self._color, HGfx.Fonts.Small));
                        } else {
                            widget.Texts[1].Text = datestr;
                            widget.Texts[1].Color = self._color;
                        }
                    }
                } else {
                    widget.Texts = null;
                }
            }

            static function getStressLevel() as Number {
                self._sampleDeltaRise = null;
                self._stressLevel = 0;

                var sample_valid = 1800; // 30 min
                if ((self._lastSampleDate == null || Toybox.Time.now().subtract(self._lastSampleDate).value() > 5) && Toybox.SensorHistory has :getStressHistory) {
                    var hist = Toybox.SensorHistory.getStressHistory({ "period" => 2, "order" => Toybox.SensorHistory.ORDER_NEWEST_FIRST });
                    var newest_sample = hist.next();
                    var prev_sample = hist.next();
                    if (newest_sample != null && Toybox.Time.now().subtract(newest_sample.when).value() <= sample_valid) {
                        if (prev_sample != null && newest_sample.when.subtract(prev_sample.when).value() <= sample_valid) {
                            if (newest_sample.data > prev_sample.data) {
                                self._sampleDeltaRise = true;
                            } else if (newest_sample.data < prev_sample.data) {
                                self._sampleDeltaRise = false;
                            } else {
                                self._sampleDeltaRise = null;
                            }
                        } else {
                            self._lastSampleDate = null;
                        }

                        self._stressLevel = newest_sample.data.toNumber();
                        self._lastSampleDate = newest_sample.when;
                    } else {
                        self._lastSampleDate = null;
                    }
                } else {
                    self._lastSampleDate = null;
                }

                /*self._sampleDeltaRise = true;
                self._lastSampleDate = Time.now().subtract(new Time.Duration(645));
                self._stressLevel = 92;*/

                return self._stressLevel;
            }
        }
    }
}
