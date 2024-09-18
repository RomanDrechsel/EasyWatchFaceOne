using Toybox.Graphics as Gfx;
import Toybox.Lang;
import Toybox.WatchUi;
using Helper.Gfx as HGfx;

module Widgets {
    class Icons extends WidgetBase {
        function initialize(params as Dictionary) {
            WidgetBase.initialize(params);
        }

        function draw(dc as Gfx.Dc) as Void {
            if (HGfx.Fonts.Icons == null) {
                return;
            }
            var btWidth = dc.getTextWidthInPixels(Helper.Gfx.ICONS_BLUETOOTH, HGfx.Fonts.Icons);
            var msgWidth = dc.getTextWidthInPixels(Helper.Gfx.ICONS_NEWMESSAGES, HGfx.Fonts.Icons);
            var padding = IsSmallDisplay ? 8 : 12;

            var posX = self.locX;
            if (self.Justification == WIDGET_JUSTIFICATION_RIGHT) {
                posX = self.locX - btWidth - msgWidth - padding;
            } else if (self.Justification == WIDGET_JUSTIFICATION_LEFT) {
                posX += 15;
            } else if (self.Justification == WIDGET_JUSTIFICATION_CENTER) {
                var width = btWidth + msgWidth + padding;
                posX = self.locX - width / 2;
            }

            var posY = IsSmallDisplay ? self.locY + 10 : self.locY + 17;
            var settings = System.getDeviceSettings();
            var theme = $.getTheme();

            //Messages
            var msgCount = settings.notificationCount;
            if (msgCount > 0) {
                var msgstr;
                if (msgCount <= 9) {
                    msgstr = msgCount.toString();
                } else {
                    msgstr = "9+";
                }

                var xOffset = IsSmallDisplay ? 23 : 35;
                var yOffset = IsSmallDisplay ? 9 : 10;

                dc.setColor(theme.IconsOn, Gfx.COLOR_TRANSPARENT);
                if (HGfx.Fonts.Small != null) {
                    dc.drawText(posX, posY + 3, HGfx.Fonts.Icons, Helper.Gfx.ICONS_NEWMESSAGES, Gfx.TEXT_JUSTIFY_LEFT);
                    dc.drawText(posX + xOffset, posY + yOffset, HGfx.Fonts.Small, msgstr, Gfx.TEXT_JUSTIFY_CENTER);
                } else {
                    dc.drawText(posX, posY + 3, HGfx.Fonts.Icons, Helper.Gfx.ICONS_NOMESSAGES, Gfx.TEXT_JUSTIFY_LEFT);
                }
            } else {
                dc.setColor(theme.IconsOff, Gfx.COLOR_TRANSPARENT);
                dc.drawText(posX, posY + 3, HGfx.Fonts.Icons, Helper.Gfx.ICONS_NOMESSAGES, Gfx.TEXT_JUSTIFY_LEFT);
            }

            //Phone connection
            if (settings.phoneConnected == true) {
                dc.setColor(theme.IconsOn, Gfx.COLOR_TRANSPARENT);
            } else {
                dc.setColor(theme.IconsOff, Gfx.COLOR_TRANSPARENT);
            }
            dc.drawText(posX + msgWidth + padding, posY, HGfx.Fonts.Icons, Helper.Gfx.ICONS_BLUETOOTH, Gfx.TEXT_JUSTIFY_LEFT);
        }
    }
}
