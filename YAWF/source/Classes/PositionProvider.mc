import Toybox.Lang;
import Toybox.Graphics;

class PositionProvider
{
    public static enum 
    {
        Center, TopLeft, Top, TopRight, BottomLeft, Bottom, BottomRight
    }

    public static function GetPositionXWithPercentage(pos, desired_width_percent) as Number
    {
        var dc = getViewDC() as Toybox.Graphics.Dc;
        var x = 0;
        switch (pos)
        {
            case :TopRight:
            case :BottomRight:
                x = dc.getWidth();
                break;
            case :Center:
            case :Top:
            case :Bottom:
                x = dc.getWidth() / 2;
                break;
        }

        if (desired_width_percent != 0)
        {
            x -= (dc.getWidth() / 100 * desired_width_percent);
        }

        return x;
    }

    public static function GetPositionYWithPercentage(pos, desired_height_percent) as Number
    {
        var dc = getViewDC() as Toybox.Graphics.Dc;
        var y = 0;
        switch (pos)
        {
            case :BottomRight:
            case :Bottom:
            case :BottomLeft:
                y = dc.getHeight();
                break;
            case :Center:
                y = dc.getHeight() / 2;
                break;
        }

        if (desired_height_percent != 0)
        {
            y -= (dc.getHeight() / 100 * desired_height_percent);
        }

        return y;
    }

    public static function GetPositionX(pos) as Number
    {
        return PositionProvider.GetPositionXWithPercentage(pos, 0);
    }

    public static function GetPositionY(pos) as Number
    {
        return PositionProvider.GetPositionYWithPercentage(pos, 0);
    }

    public static function GetPosition(pos) as Array
    {
        return [PositionProvider.GetPositionX(pos), PositionProvider.GetPositionY(pos)];
    }
}