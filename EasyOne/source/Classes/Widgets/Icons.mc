using Toybox.Graphics as Gfx;
import Toybox.Lang;
import Toybox.WatchUi;
using Helper.Gfx as HGfx;

module Widgets
{
    class Icons extends WidgetBase
    {
        private var _BTWidth = -1;
        private var _MsgWidth = -1;

        private var _Padding = 12;

        function initialize(params as Dictionary) 
        {
            WidgetBase.initialize(params);
        }

        function draw(dc as Gfx.Dc) as Void 
        {
            if (self._BTWidth < 0 || self._MsgWidth < 0)
            {
                self._BTWidth = dc.getTextWidthInPixels(Helper.Gfx.ICONS_BLUETOOTH, HGfx.Fonts.Icons);
                self._MsgWidth = dc.getTextWidthInPixels(Helper.Gfx.ICONS_NEWMESSAGES, HGfx.Fonts.Icons);

                if (self.Justification == WIDGET_JUSTIFICATION_RIGHT)
                {
                    var width = self._BTWidth + self._MsgWidth + self._Padding;
                    self.locX = self.locX - width;
                }
                else if (self.Justification == WIDGET_JUSTIFICATION_LEFT)
                {
                    self.locX += 10;
                }
                else if (self.Justification == WIDGET_JUSTIFICATION_CENTER)
                {
                    var width = self._BTWidth + self._MsgWidth + self._Padding;
                    self.locX = self.locX - (width / 2);
                }

                self.locY += 10;
            }

            var settings = System.getDeviceSettings();

            //Messages
            var msgCount = settings.notificationCount;
            if (msgCount > 0)
            {
                var msgstr;
                if (msgCount <= 9)
                {
                    msgstr =  msgCount.toString();
                }
                else
                {
                    msgstr = "9+";
                }

                dc.setColor(self._theme.IconsOn, Gfx.COLOR_TRANSPARENT);
                dc.drawText(self.locX, self.locY + 3, HGfx.Fonts.Icons, Helper.Gfx.ICONS_NEWMESSAGES, Gfx.TEXT_JUSTIFY_LEFT);
                dc.drawText(self.locX + 35, self.locY + 9, HGfx.Fonts.Small, msgstr, Gfx.TEXT_JUSTIFY_CENTER);
            }
            else
            {
                dc.setColor(self._theme.IconsOff, Gfx.COLOR_TRANSPARENT);
                dc.drawText(self.locX, self.locY + 3, HGfx.Fonts.Icons, Helper.Gfx.ICONS_NOMESSAGES, Gfx.TEXT_JUSTIFY_LEFT);
            } 

            //Phone connection
            if (settings.phoneConnected == true)
            {
                dc.setColor(self._theme.IconsOn, Gfx.COLOR_TRANSPARENT);
            }
            else
            {
                dc.setColor(self._theme.IconsOff, Gfx.COLOR_TRANSPARENT);
            }            
            dc.drawText(self.locX + self._MsgWidth + self._Padding, self.locY, HGfx.Fonts.Icons, Helper.Gfx.ICONS_BLUETOOTH, Gfx.TEXT_JUSTIFY_LEFT);
        }
    }
}