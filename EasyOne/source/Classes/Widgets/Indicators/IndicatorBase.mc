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
                var iconHeight = Graphics.getFontAscent(HGfx.Fonts.Icons);
                var fontHeight = Graphics.getFontAscent(HGfx.Fonts.Small);

                var indicatorPadding = 12;
                if (IsSmallDisplay)
                {
                    indicatorPadding = 8;
                }


                var centerX;
                if (IsSmallDisplay)
                {
                    centerX = widget.locX + (widget.WidgetSize / 2.0);
                }
                else
                {
                    centerX = widget.locX + (widget.WidgetSize / 2.4);
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

                self._textPosY = widget.locY - indicatorPadding - fontHeight - 25;
                self._iconPosY = self._textPosY - iconHeight - 10;

                if (IsSmallDisplay)
                {
                    self._textPosY += 10;
                    self._iconPosY += 18;
                }

                self._initialized = true;
            }
        }
    }
}