import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Widgets;
using Helper.Gfx as HGfx;

module Widgets 
{
    module Indicators
    {
        class IndicatorBase 
        {
            protected var _initialized = false;
            protected var _iconPosX as Number;
            protected var _iconPosY as Number;
            protected var _textPosX as Number;
            protected var _textPosY as Number;

            function draw(dc as Dc, widget as HealthIndicator)
            {
                if (self._initialized == false)
                {
                    self.Init(dc, widget);
                }
            }

            protected function Init(dc as Dc, widget as HealthIndicator)
            {
                var iconHeight = dc.getFontHeight(HGfx.Fonts.Icons);
                var fontHeight = dc.getFontHeight(HGfx.Fonts.Small);

                var centerX;
                var centerY;
                if (IsSmallDisplay)
                {
                    centerX = widget.locX + (widget.WidgetWidth / 2.0);
                    centerY = widget.locY + (widget.WidgetHeight / 1.5);
                }
                else
                {
                    centerX = widget.locX + (widget.WidgetWidth / 2.4);
                    centerY = widget.locY + (widget.WidgetHeight / 2.2);
                }

                if (widget.Justification == Widgets.WIDGET_JUSTIFICATION_LEFT)
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
                self._iconPosY = centerY - (iconHeight / 2) - 10;
                self._textPosY = centerY + (fontHeight / 2) - 5; 

                if (!IsSmallDisplay)
                {
                    self._textPosY += 10;
                }

                self._initialized = true;
            }
        }
    }
}