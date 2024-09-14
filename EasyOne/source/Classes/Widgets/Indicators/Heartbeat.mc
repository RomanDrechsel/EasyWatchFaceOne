import Toybox.Lang;
import Widgets;
using Toybox.Graphics as Gfx;
using Helper.Gfx as HGfx;

module Widgets {
    module Indicators {
        class Heartbeat {
            static var HeartbeatZones as Array<Number> = [];
            static var HeartbeatMin = 0;

            function draw(dc as Gfx.Dc, widget as HealthIndicator) {
                if (HGfx.Fonts.Normal == null || HGfx.Fonts.Small == null) {
                    return;
                }

                var heartrate = self.getHeartrate();
                var theme = $.getTheme();

                var color = theme.IconsOff;
                var iconcolor = theme.IconsOff;
                var indicatorcolor = color;

                if (heartrate > 0) {
                    color = Themes.Colors.Text2;
                    iconcolor = Themes.Colors.IconsInTextColor ? color : theme.HealthHeartIconColor;

                    var colors = $.getTheme().IndivatorLevel;
                    indicatorcolor = colors[0];
                    if (self.HeartbeatZones.size() > 1) {
                        for (var i = 1; i < self.HeartbeatZones.size(); i++) {
                            if (heartrate >= self.HeartbeatZones[i]) {
                                color = colors[i];
                                indicatorcolor = color;
                                iconcolor = color;
                            }
                        }
                    }

                    if (widget.Texts == null || widget.Texts.size() < 2) {
                        widget.Texts = [new Helper.ExtTextPart(heartrate.toString(), color, HGfx.Fonts.Normal), new Helper.ExtTextPart(" bpm", color, HGfx.Fonts.Small)];
                    } else {
                        widget.Texts[0].Text = heartrate.toString();
                        widget.Texts[0].Color = color;
                        widget.Texts[1].Color = color;
                    }
                } else {
                    widget.Texts = null;
                }

                widget.DrawIcon(dc, HGfx.ICONS_HEART, iconcolor);
                widget.DrawText(dc);

                var amount = 0.0;
                if (heartrate >= 40) {
                    amount = (heartrate - self.HeartbeatMin).toFloat() / (self.HeartbeatZones[3] - self.HeartbeatMin).toFloat();
                } else if (heartrate > 0) {
                    amount = 0.001;
                }

                widget.drawIndicator(dc, amount, indicatorcolor);

                if (heartrate > 0 && heartrate >= self.HeartbeatZones[self.HeartbeatZones.size() - 1]) {
                    widget.DrawAttentionIcon(dc);
                } else {
                    widget.HideAttentionIcon();
                }
            }

            public static function getHeartrate() as Number {
                var info = Toybox.Activity.getActivityInfo();
                if (info != null && info.currentHeartRate != null) {
                    return info.currentHeartRate;
                }

                return -1;
            }
        }
    }
}
