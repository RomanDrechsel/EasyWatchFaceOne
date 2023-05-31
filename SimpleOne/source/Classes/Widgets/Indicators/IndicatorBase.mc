import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
using Helper.Gfx as HGfx;

module Widgets 
{
    module Indicators
    {
        class IndicatorBase 
        {
            protected var _initialized = false;
            
            protected var _Widget = null as Widgets.RandomIndicator;

            protected var _iconPosX as Number;
            protected var _iconPosY as Number;
            protected var _textPosX as Number;
            protected var _textPosY as Number;

            function initialize(widget as Widgets.RandomIndicator)
            {
                self._Widget = widget;
            }

            function draw(dc as Dc)
            {
                if (self._initialized == false)
                {
                    self.Init(dc);
                }
            }

            protected function Init(dc as Dc)
            {
                var iconHeight = dc.getFontHeight(HGfx.Fonts.Icons);
                var fontHeight = dc.getFontHeight(HGfx.Fonts.Small);
                var centerX = self._Widget.locX + (self._Widget.WidgetWidth / 2.4);
                var centerY = self._Widget.locY + (self._Widget.WidgetHeight / 2.2);

                self._iconPosX = centerX;
                self._iconPosY = centerY - (iconHeight / 2) - 5;
                self._textPosX = centerX;
                self._textPosY = centerY + (fontHeight / 2) + 5;

                self._initialized = true;
            }
        }
    }
}