using Toybox.Graphics as Gfx;
import Toybox.Lang;

module Helper
{ 
    module Gfx
    {
        class DrawArc
        {
            var locX = 0;
            var locY = 0;
            var Radius = 10;
            var Thickness = 1;
            var Direction = Gfx.ARC_CLOCKWISE;
            var StartDeg = 90;
            var LengthDeg = 120;
            var Parts = 1;
            var PartSeparatorWidth = 3;

            function initialize(posx as Number, posy as Number, radius as Number, thickness as Number, startdeg as Number, length as Number, direction as Gfx.ArcDirection)
            {
                self.locX = posx;
                self.locY = posy;
                self.Radius = radius;
                self.Thickness = thickness;
                self.Direction = direction;
                self.StartDeg = startdeg;
                self.LengthDeg = length;
            }

            function draw(dc as Gfx.Dc, percent as Float|Number, color as Number)
            {
                if (percent instanceof Float == false)
                {
                    percent = percent.toFloat();
                }
                
                var length = self.LengthDeg * (percent / 100) as Float;
                if (self.Direction == Gfx.ARC_COUNTER_CLOCKWISE)
                {
                    length *= -1;
                }
                var end = self.StartDeg - length;

                dc.setColor(color, Gfx.COLOR_TRANSPARENT);
                dc.setPenWidth(self.Thickness);
                if (self.Parts <= 1)
                {
                    //no part separation
                    dc.drawArc(self.locX, self.locY, self.Radius, self.Direction , self.StartDeg, end);
                }
                else
                {
                    var deg = self.StartDeg;
                    var partdeg = self.LengthDeg / self.Parts; //length of a part
                    partdeg -= self.PartSeparatorWidth;

                    for (var i = 0; i < self.Parts; i++)
                    {
                        var partend = deg - partdeg;
                        if (i == self.Parts - 1)
                        {
                            partend -= self.PartSeparatorWidth;
                        }
                        if (self.Direction == Gfx.ARC_COUNTER_CLOCKWISE)
                        {
                            partend = deg + partdeg;
                            if (i == self.Parts - 1)
                            {
                                partend += self.PartSeparatorWidth;
                            }
                            if (partend > end)
                            {
                                partend = end;
                            }
                        }
                        else
                        {
                            if (partend < end)
                            {
                                partend = end;
                            }
                        }
                        
                        dc.drawArc(self.locX, self.locY, self.Radius, self.Direction, deg, partend);
                        if (self.Direction == Gfx.ARC_COUNTER_CLOCKWISE)
                        {
                            deg += partdeg + self.PartSeparatorWidth;
                            if (deg >= end)
                            {
                                break;
                            }
                        }
                        else
                        {
                            deg -= partdeg + self.PartSeparatorWidth;
                            if (deg <= end)
                            {
                                break;
                            }
                        }                    
                    }                
                }
            }
        }
    }
}