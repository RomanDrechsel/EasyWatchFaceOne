import Toybox.Lang;
import Widgets;
import Toybox.Graphics;
using Helper.Gfx as HGfx;

module Widgets {
    module Indicators {
        class Breath {
            static var MaxRespirationRate as Number = 40;
            private static var _lastRespirationRate as Number = 0;
            private static var _lastSample as Toybox.Time.Moment? = null;

            function draw(dc as Dc, widget as HealthIndicator) {
                if (HGfx.Fonts.Normal == null || HGfx.Fonts.Small == null) {
                    return;
                }
                var breath = self.getBreath();
                var theme = $.getTheme();

                var color = theme.IconsOff;
                var iconcolor = theme.IconsOff;
                var indicatorcolor = color;

                if (breath > 0) {
                    color = Themes.Colors.Text2;
                    iconcolor = Themes.Colors.IconsInTextColor ? color : theme.HealthBreathIconColor;
                    var colors = $.getTheme().IndicatorLevel as Array<Number>;
                    indicatorcolor = colors[0];
                    if (breath >= 20) {
                        if (breath > self.MaxRespirationRate) {
                            color = colors[3];
                        } else if (breath >= self.MaxRespirationRate - 10) {
                            color = colors[2];
                        } else {
                            color = colors[1];
                        }
                        indicatorcolor = color;
                        iconcolor = color;
                    }

                    if (widget.Texts == null || widget.Texts.size() < 2) {
                        widget.Texts = [new Helper.ExtTextPart(breath.toString(), color, HGfx.Fonts.Normal), new Helper.ExtTextPart(" brpm", color, HGfx.Fonts.Small)];
                    } else {
                        widget.Texts[0].Text = breath.toString();
                        widget.Texts[0].Color = color;
                        widget.Texts[1].Color = color;
                    }
                } else {
                    widget.Texts = null;
                }

                widget.DrawIcon(dc, HGfx.ICONS_BREATH, iconcolor);
                widget.DrawText(dc);
                widget.drawIndicator(dc, breath.toFloat() / self.MaxRespirationRate.toFloat(), indicatorcolor);

                if (breath > 0 && breath >= widget.BreathWarningLevel) {
                    widget.DrawAttentionIcon(dc);
                } else {
                    widget.HideAttentionIcon();
                }
            }

            static function getBreath() as Number {
                var info = Toybox.ActivityMonitor.getInfo();
                if (info.respirationRate != null && info.respirationRate > 0) {
                    self._lastRespirationRate = info.respirationRate;
                    self._lastSample = Toybox.Time.now();
                    return self._lastRespirationRate;
                } else if (self._lastSample != null && self._lastRespirationRate != null && Toybox.Time.now().subtract(self._lastSample).value() <= 300) {
                    return self._lastRespirationRate;
                }

                return -1;
            }
        }
    }
}
