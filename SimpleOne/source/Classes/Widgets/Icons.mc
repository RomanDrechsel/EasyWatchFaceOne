using Toybox.Graphics as Gfx;
import Toybox.Lang;
import Toybox.WatchUi;

module Widgets
{
    class Icons extends WidgetBase
    {
        private var _Icons = null as FontResource;
        private var _MsgFont = null as FontResource;
        private var _BTWidth = -1 as Number;
        private var _MsgWidth = -1 as Number;

        private var _Padding = 12 as Number;

        function initialize(params as Dictionary) 
        {
            WidgetBase.initialize(params);

            self._Icons = WatchUi.loadResource(Rez.Fonts.Icons) as FontResource;
            self._MsgFont = WatchUi.loadResource(Rez.Fonts.Small) as FontResource;
        }

        function draw(dc as Gfx.Dc) as Void 
        {
            if (self._BTWidth < 0 || self._MsgWidth < 0)
            {
                self._BTWidth = dc.getTextWidthInPixels(Helper.Gfx.ICONS_BLUETOOTH, self._Icons);
                self._MsgWidth = dc.getTextWidthInPixels(Helper.Gfx.ICONS_NEWMESSAGES, self._Icons);

                if (self.Justification == WIDGET_JUSTIFICATION_RIGHT)
                {
                    var width = self._BTWidth + self._MsgWidth + self._Padding;
                    self.locX = self.locX - width;
                }
            }

            var settings = System.getDeviceSettings();

            //Messages
            var msgCount = settings.notificationCount;
            if (msgCount > 0)
            {
                dc.setColor(self._theme.IconsOn, Gfx.COLOR_TRANSPARENT);
                dc.drawText(self.locX, self.locY + 3, self._Icons, Helper.Gfx.ICONS_NEWMESSAGES, Gfx.TEXT_JUSTIFY_LEFT);
                dc.drawText(self.locX + 35, self.locY + 9, self._MsgFont, msgCount.toString(), Gfx.TEXT_JUSTIFY_CENTER);
            }
            else
            {
                dc.setColor(self._theme.IconsOff, Gfx.COLOR_TRANSPARENT);
                dc.drawText(self.locX, self.locY + 3, self._Icons, Helper.Gfx.ICONS_NOMESSAGES, Gfx.TEXT_JUSTIFY_LEFT);
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
            dc.drawText(self.locX + self._MsgWidth + self._Padding, self.locY, self._Icons, Helper.Gfx.ICONS_BLUETOOTH, Gfx.TEXT_JUSTIFY_LEFT);
        }
    }
}