import Widgets;
import Toybox.Lang;

module CustomDrawables
{
    enum DrawablePosition { WIDGET_CENTER = 0 }

    class WidgetLoader
    {
        static function GetWidget(pos) as WidgetBase
        {
            switch (pos)
            {
                case WIDGET_CENTER:
                    return new Clock();
            }

            return new WidgetBase();
        }
    }
}