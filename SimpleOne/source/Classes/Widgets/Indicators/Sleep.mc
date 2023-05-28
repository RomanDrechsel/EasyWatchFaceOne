import Toybox.Lang;
using Toybox.Graphics as Gfx;
using Helper.Gfx as Draw;

module Widgets 
{
    module Indicators
    {
        class Sleep extends IndicatorBase
        {
            function initialize(widget as Widgets.Heartbeat)
            {
                IndicatorBase.initialize(widget);
            }

            protected function Init(dc as Gfx.Dc)
            {
                IndicatorBase.Init(dc);
            }

            function draw(dc as Gfx.Dc)
            {
                IndicatorBase.draw(dc);
            }
        }
    }
}