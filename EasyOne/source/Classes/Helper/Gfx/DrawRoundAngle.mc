using Toybox.Graphics as Gfx;
import Toybox.Lang;

module Helper
{ 
    module Gfx
    {
        class DrawRoundAngle
        {
            enum Justification { JUST_TOPLEFT, JUST_TOPRIGHT, JUST_BOTTOMLEFT, JUST_BOTTOMRIGHT }

            var AnchorX = 0;
            var AnchorY = 0;
            var Width = 100;
            var Height = 100;
            var AngleRadius = 10;

            var BackgroundColor = 0;
            var BarColors = [] as Array<Number>;
            var DotRadius = 5;

            var Thickness = 4; 
            var ThicknessBold = 6;
            var Direction = JUST_BOTTOMLEFT; 

            private var _lineWidth = 4.0;
            private var _lineHeight as Float;
            private var _totalBarLength as Float;
            private var _horLineValue as Float;
            private var _vertLineValue as Float;
            private var _arcValue as Float;

            function initialize(anchorx as Number, anchory as Number, width as Number, height as Number, angleradius as Number)
            {
                if (IsSmallDisplay())
                {
                    self.Thickness = 2;
                    self.ThicknessBold = 4;
                    self.DotRadius = 3;
                    angleradius *= .66666 as Number;
                }

                self.AnchorX = anchorx;
                self.AnchorY = anchory;
                self.Width = width;
                self.Height = height;
                self.AngleRadius = angleradius;

                self.BackgroundColor = getTheme().IndicatorBackground;

                self.Reset();
            }

            function Reset()
            {
                self._lineWidth = self.Width - self.AngleRadius - (self.ThicknessBold / 2);
                self._lineHeight = self.Height - self.AngleRadius - (self.ThicknessBold / 2);
                self._totalBarLength = self._lineWidth + self._lineHeight + ((self.AngleRadius.toFloat() * Toybox.Math.PI * 2.0) / 4.0);                
                self._horLineValue = self._lineWidth / self._totalBarLength;
                self._vertLineValue = self._lineHeight / self._totalBarLength;

                self._arcValue = 1 - self._horLineValue - self._vertLineValue;
            }

            function draw(dc as Gfx.Dc, amount as Float)
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

                if (amount > 0)
                {
                    var factor = 1.0 / self.BarColors.size().toFloat();
                    var color = 0xFFFFFF;
                    var a = 1.0;
                    for (var i = 0; i < self.BarColors.size(); i++)
                    {
                        if (a >= amount)
                        {
                            color = self.BarColors[i];
                        }
                        else
                        {
                            break;
                        }
                        a -= factor;
                    }
                    self.drawWithColor(dc, amount, color);
                }
                else 
                {
                    self.drawWithColor(dc, 0, 0);
                }
            }

            function drawWithColor(dc as Gfx.Dc, amount as Float, color as Number)
            {
                if (self.Direction == JUST_BOTTOMRIGHT)
                {
                    var _TopX = self.AnchorX - (self.DotRadius / 2);
                    var _TopY = self.AnchorY + (self.DotRadius / 2);

                    self.drawSimple(dc, _TopX, _TopY);
                    if (amount > 0)
                    {
                        self.drawCounterClockwise(dc, amount, color, _TopX, _TopY);
                    }
                }
                else if (self.Direction == JUST_BOTTOMLEFT)
                {
                    var _TopX = self.AnchorX + (self.DotRadius / 2);
                    var _TopY = self.AnchorY + (self.DotRadius / 2);
                    self.drawSimple(dc, _TopX, _TopY);
                    if (amount > 0)
                    {
                        self.drawClockwise(dc, amount, color, _TopX, _TopY);
                    }
                }
                else if (self.Direction == JUST_TOPLEFT)
                {
                    var _TopX = self.AnchorX + (self.DotRadius / 2);
                    var _TopY = self.AnchorY + (self.DotRadius / 2);
                    self.drawSimple(dc, _TopX, _TopY);
                }
                else if (self.Direction == JUST_TOPRIGHT)
                {
                    var _TopX = self.AnchorX - (self.DotRadius / 2);
                    var _TopY = self.AnchorY + (self.DotRadius / 2);
                    self.drawSimple(dc, _TopX, _TopY);
                }
            }

            function drawSimple(dc as Gfx.Dc, _TopX as Number, _TopY as Number)
            {
                dc.setColor(self.BackgroundColor, Gfx.COLOR_TRANSPARENT);
                dc.setPenWidth(self.Thickness);

                if (self.Direction == JUST_BOTTOMRIGHT)
                {
                    //From top to right
                    var startx = _TopX;
                    var starty = _TopY;

                    dc.drawLine(startx, starty, startx, starty + self._lineHeight);

                    dc.drawArc(startx - self.AngleRadius, starty + self._lineHeight, self.AngleRadius, Gfx.ARC_CLOCKWISE, 0, 270);

                    startx -= self.AngleRadius;
                    starty += self.AngleRadius + self._lineHeight;
                    dc.drawLine(startx, starty, startx - self._lineWidth, starty);
                }
                else if (self.Direction == JUST_BOTTOMLEFT)
                {
                    //from top to left
                    var startx = _TopX;
                    var starty = _TopY;

                    dc.drawLine(startx, starty, startx, starty + self._lineHeight);

                    dc.drawArc(startx + self.AngleRadius, starty + self._lineHeight, self.AngleRadius, Gfx.ARC_COUNTER_CLOCKWISE, 180, 270);

                    startx += self.AngleRadius;
                    starty += self.AngleRadius + self._lineHeight;
                    dc.drawLine(startx, starty, startx + self._lineWidth, starty);
                }
                else if (self.Direction == JUST_TOPLEFT)
                {
                    //from bottom to right
                    var startx = _TopX;
                    var starty = _TopY + self._lineHeight + self.AngleRadius;

                    dc.drawLine(startx, starty, startx, starty - self._lineHeight);

                    startx += self.AngleRadius;
                    starty -= self._lineHeight;

                    dc.drawArc(startx, starty, self.AngleRadius, Gfx.ARC_CLOCKWISE, 180, 90);

                    starty -= self.AngleRadius;
                    dc.drawLine(startx, starty, startx + self._lineWidth, starty);
                }
                else if (self.Direction == JUST_TOPRIGHT)
                {
                    //from bottom to left
                    dc.setColor(self.BackgroundColor, Gfx.COLOR_TRANSPARENT);
                    dc.setPenWidth(self.Thickness);

                    var startx = _TopX;
                    var starty = _TopY + self._lineHeight + self.AngleRadius;

                    dc.drawLine(startx, starty, startx, starty - self._lineHeight);

                    startx -= self.AngleRadius;
                    starty -= self._lineHeight;

                    dc.drawArc(startx, starty, self.AngleRadius, Gfx.ARC_COUNTER_CLOCKWISE, 0, 90);

                    starty -= self.AngleRadius;
                    dc.drawLine(startx, starty, startx - self._lineWidth, starty);
                }
            }

            private function drawClockwise(dc as Gfx.Dc, amount as Float, color as Number, _TopX as Number, _TopY as Number)
            {
                //Foreground - from right to top
                dc.setColor(color, Gfx.COLOR_TRANSPARENT);
                dc.setPenWidth(self.ThicknessBold);

                var starty = _TopY + self._lineHeight + self.AngleRadius;
                var startx = _TopX + self._lineWidth + self.AngleRadius;
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
                        starty = _TopY + self._lineHeight;
                        startx = _TopX;

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

            private function drawCounterClockwise(dc as Gfx.Dc, amount as Float, color as Number, _TopX as Number, _TopY as Number)
            {
                //Foreground - from Right to top
                dc.setColor(color, Gfx.COLOR_TRANSPARENT);
                dc.setPenWidth(self.ThicknessBold);

                var starty = _TopY + self._lineHeight + self.AngleRadius;
                var startx = _TopX - self._lineWidth - self.AngleRadius;
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
                        starty = _TopY + self._lineHeight;
                        startx = _TopX;

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

            private function drawDot(dc as Gfx.Dc, x as Number, y as Number)
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