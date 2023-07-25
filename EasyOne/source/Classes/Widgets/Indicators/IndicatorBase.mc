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
            
            protected var _Widget = null as Widgets.HealthIndicator;

            protected var _iconPosX as Number;
            protected var _iconPosY as Number;
            protected var _textPosX as Number;
            protected var _textPosY as Number;

            function initialize(widget as Widgets.HealthIndicator)
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

                var centerX;
                var centerY;
                if (IsSmallDisplay)
                {
                    centerX = self._Widget.locX + (self._Widget.WidgetWidth / 2.0);
                    centerY = self._Widget.locY + (self._Widget.WidgetHeight / 1.5);
                }
                else
                {
                    centerX = self._Widget.locX + (self._Widget.WidgetWidth / 2.4);
                    centerY = self._Widget.locY + (self._Widget.WidgetHeight / 2.2);
                }

                if (self._Widget.Justification == Widgets.WIDGET_JUSTIFICATION_LEFT)
                {
                    if (IsSmallDisplay)
                    {
                        centerX += 5;
                    }
                    else
                    {
                        centerX += 20;
                    }
                }

                self._iconPosX = centerX;
                self._textPosX = centerX;
                self._iconPosY = centerY - (iconHeight / 2);
                self._textPosY = centerY + (fontHeight / 2) - 5; 

                if (!IsSmallDisplay)
                {
                    self._iconPosY -= 10;
                    self._textPosY += 10;
                }

                self._initialized = true;
            }
        }
    }
}