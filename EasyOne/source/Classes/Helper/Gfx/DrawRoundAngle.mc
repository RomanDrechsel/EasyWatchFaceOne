import Toybox.Lang;
import Toybox.Math;
using Toybox.Graphics as Gfx;

module Helper
{ 
    module Gfx
    {
        class DrawRoundAngle
        {
            enum Justification { JUST_TOPLEFT = 0, JUST_TOPRIGHT, JUST_BOTTOMLEFT, JUST_BOTTOMRIGHT }

            static var AnchorX = 0;
            static var AnchorY = 0;
            static var Width = 100;
            static var Height = 100;
            static var AngleRadius = 10;

            static var BarColors = [] as Array<Number>;
            static var DotRadius = 5;

            static var Thickness = 4; 
            static var ThicknessBold = 6;
            static var Justification = JUST_TOPLEFT; 

            private static var _lineWidth = 4;
            private static var _lineHeight as Float;
            private static var _totalBarLength as Float;
            private static var _horLineValue as Float;
            private static var _vertLineValue as Float;
            private static var _arcValue as Float;

            static function Configure(anchorx as Number, anchory as Number, width as Number, height as Number, just as Justification)
            {
                self.Justification = just;
                var angleradius = height / 5;
                if (IsSmallDisplay)
                {
                    self.Thickness = 2;
                    self.ThicknessBold = 4;
                    self.DotRadius = 3;
                    angleradius = (angleradius * .6666).toNumber();
                }

                self.AnchorX = anchorx;
                self.AnchorY = anchory;
                self.Width = width;
                self.Height = height;
                self.AngleRadius = angleradius;

                self._lineWidth = self.Width - self.AngleRadius - (self.ThicknessBold / 2);
                self._lineHeight = self.Height - self.AngleRadius - (self.ThicknessBold / 2);
                self._totalBarLength = self._lineWidth + self._lineHeight + ((self.AngleRadius.toFloat() * Toybox.Math.PI * 2.0) / 4.0);                
                self._horLineValue = self._lineWidth / self._totalBarLength;
                self._vertLineValue = self._lineHeight / self._totalBarLength;

                self._arcValue = 1 - self._horLineValue - self._vertLineValue;
            }

            static function draw(dc as Gfx.Dc, amount as Float, color as Number)
            {
                //clamp
                if (amount > 1.0)
                {
                    amount = 1.0;
                }
                if (amount < 0.0)
                {
                    amount = 0.0;
                }

                if (self.Justification == JUST_BOTTOMRIGHT)
                {
                    var topX = self.AnchorX - (self.DotRadius / 2);
                    var topY = self.AnchorY + (self.DotRadius / 2);

                    self.drawSimple(dc, topX, topY);
                    if (amount > 0)
                    {
                        self.drawCounterClockwise(dc, amount, color, topX, topY);
                    }
                }
                else if (self.Justification == JUST_BOTTOMLEFT)
                {
                    var topX = self.AnchorX + (self.DotRadius / 2);
                    var topY = self.AnchorY + (self.DotRadius / 2);
                    self.drawSimple(dc, topX, topY);
                    if (amount > 0)
                    {
                        self.drawClockwise(dc, amount, color, topX, topY);
                    }
                }
                else if (self.Justification == JUST_TOPLEFT)
                {
                    var topX = self.AnchorX + (self.DotRadius / 2);
                    var topY = self.AnchorY + (self.DotRadius / 2);
                    self.drawSimple(dc, topX, topY);
                }
                else if (self.Justification == JUST_TOPRIGHT)
                {
                    var topX = self.AnchorX - (self.DotRadius / 2);
                    var topY = self.AnchorY + (self.DotRadius / 2);
                    self.drawSimple(dc, topX, topY);
                }
            }

            static function drawSimple(dc as Gfx.Dc, topX as Number, topY as Number)
            {
                dc.setColor($.getTheme().IndicatorBackground, Gfx.COLOR_TRANSPARENT);
                dc.setPenWidth(self.Thickness);

                if (self.Justification == JUST_BOTTOMRIGHT)
                {
                    //From top to right
                    var startx = topX;
                    var starty = topY;

                    dc.drawLine(startx, starty, startx, starty + self._lineHeight);
                    dc.drawArc(startx - self.AngleRadius, starty + self._lineHeight, self.AngleRadius, Gfx.ARC_CLOCKWISE, 0, 270);
                    startx -= self.AngleRadius;
                    starty += self.AngleRadius + self._lineHeight;
                    dc.drawLine(startx, starty, startx - self._lineWidth, starty);
                }
                else if (self.Justification == JUST_BOTTOMLEFT)
                {
                    //from top to left
                    var startx = topX;
                    var starty = topY;

                    dc.drawLine(startx, starty, startx, starty + self._lineHeight);

                    dc.drawArc(startx + self.AngleRadius, starty + self._lineHeight, self.AngleRadius, Gfx.ARC_COUNTER_CLOCKWISE, 180, 270);

                    startx += self.AngleRadius;
                    starty += self.AngleRadius + self._lineHeight;
                    dc.drawLine(startx, starty, startx + self._lineWidth, starty);
                }
                else if (self.Justification == JUST_TOPLEFT)
                {
                    //from bottom to right
                    var startx = topX;
                    var starty = topY + self._lineHeight + self.AngleRadius;

                    dc.drawLine(startx, starty, startx, starty - self._lineHeight);

                    startx += self.AngleRadius;
                    starty -= self._lineHeight;

                    dc.drawArc(startx, starty, self.AngleRadius, Gfx.ARC_CLOCKWISE, 180, 90);

                    starty -= self.AngleRadius;
                    dc.drawLine(startx, starty, startx + self._lineWidth, starty);
                }
                else if (self.Justification == JUST_TOPRIGHT)
                {
                    //from bottom to left
                    dc.setColor($.getTheme().IndicatorBackground, Gfx.COLOR_TRANSPARENT);
                    dc.setPenWidth(self.Thickness);

                    var startx = topX;
                    var starty = topY + self._lineHeight + self.AngleRadius;

                    dc.drawLine(startx, starty, startx, starty - self._lineHeight);

                    startx -= self.AngleRadius;
                    starty -= self._lineHeight;

                    dc.drawArc(startx, starty, self.AngleRadius, Gfx.ARC_COUNTER_CLOCKWISE, 0, 90);

                    starty -= self.AngleRadius;
                    dc.drawLine(startx, starty, startx - self._lineWidth, starty);
                }
            }

            private static function drawClockwise(dc as Gfx.Dc, amount as Float, color as Number, topX as Number, topY as Number)
            {
                //Foreground - from right to top
                dc.setColor(color, Gfx.COLOR_TRANSPARENT);
                dc.setPenWidth(self.ThicknessBold);

                var starty = topY + self._lineHeight + self.AngleRadius;
                var startx = topX + self._lineWidth + self.AngleRadius;
                var width = self._lineWidth;
                if (amount <= self._horLineValue)
                {
                    //only a part of the line
                    width *= (amount / self._horLineValue);
                }

                dc.drawLine(startx, starty, startx - width, starty);

                if (amount > self._horLineValue)
                {
                    //Draw arc
                    startx -= self._lineWidth;
                    var rest = (amount - self._horLineValue);
                    var deg = 1 / (self._arcValue / rest) * 90;
                    if (deg > 90)
                    {
                        deg = 90;
                    }
                    dc.drawArc(startx, starty - self.AngleRadius, self.AngleRadius, Gfx.ARC_CLOCKWISE, 270, 270 - deg);

                    if (amount > self._horLineValue + self._arcValue)
                    {
                        //draw vertical line
                        starty = topY + self._lineHeight;
                        startx = topX;

                        var height = self._lineHeight;
                        if (amount < 1.0)
                        {
                            rest = amount - self._arcValue - self._horLineValue;
                            height *= (rest / self._vertLineValue);
                        }
                        dc.drawLine(startx, starty, startx, starty - height);
                        self.drawDot(dc, startx, starty - height);
                    }
                    else
                    {
                        //dot on arc
                        var y = Math.sin(Math.toRadians(270 - deg)) * self.AngleRadius;
                        var x = Math.cos(Math.toRadians(270 - deg)) * self.AngleRadius;
                        self.drawDot(dc, startx + x, starty - self.AngleRadius - y);
                    }
                }
                else
                {
                    self.drawDot(dc, startx - width, starty);
                }
            }

            private static function drawCounterClockwise(dc as Gfx.Dc, amount as Float, color as Number, topX as Number, topY as Number)
            {
                //Foreground - from Right to top
                dc.setColor(color, Gfx.COLOR_TRANSPARENT);
                dc.setPenWidth(self.ThicknessBold);

                var starty = topY + self._lineHeight + self.AngleRadius;
                var startx = topX - self._lineWidth - self.AngleRadius;
                var width = self._lineWidth;
                if (amount < self._horLineValue)
                {
                    //only a part of the line
                    width *= (amount / self._horLineValue);
                }
                dc.drawLine(startx, starty, startx + width, starty);

                if (amount > self._horLineValue)
                {
                    //Draw arc
                    startx += self._lineWidth;
                    var rest = (amount - self._horLineValue);
                    var deg = 1 / (self._arcValue / rest) * 90;
                    if (deg > 90)
                    {
                        deg = 90;
                    }

                    if (deg > 1.0)
                    {
                        dc.drawArc(startx, starty - self.AngleRadius, self.AngleRadius, Gfx.ARC_COUNTER_CLOCKWISE, 270, 270 + deg);
                    }                    

                    if (amount > self._horLineValue + self._arcValue)
                    {
                        //draw vertical line
                        starty = topY + self._lineHeight;
                        startx = topX;

                        var height = self._lineHeight;
                        if (amount < 1.0)
                        {
                            rest = amount - self._arcValue - self._horLineValue;
                            height *= (rest / self._vertLineValue);
                        }
                        dc.drawLine(startx, starty, startx, starty - height);
                        self.drawDot(dc, startx, starty - height);
                    }
                    else
                    {
                        //dot on arc
                        var y = Math.sin(Math.toRadians(270 + deg)) * self.AngleRadius;
                        var x = Math.cos(Math.toRadians(270 + deg)) * self.AngleRadius;
                        self.drawDot(dc, startx + x, starty - self.AngleRadius - y);
                    }
                }
                else
                {
                    self.drawDot(dc, startx + width, starty);
                }
            }

            private static function drawDot(dc as Gfx.Dc, x as Number, y as Number)
            {
                if (self.DotRadius <= 0)
                {
                    return;
                }

                dc.fillCircle(x, y, self.DotRadius);
            }
        }
    }
}