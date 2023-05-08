import Widgets;

module CustomDrawables
{
    enum DrawablePosition { WIDGET_CENTER = 0, WIDGET_UPPERCENTER }

    class WidgetLoader
    {
        static function GetWidget(pos as DrawablePosition) as Widgets.WidgetBase
        {
            switch (pos)
            {
                case WIDGET_CENTER:
                    return new Widgets.Clock();
                case WIDGET_UPPERCENTER:
                    return new Widgets.Date();
            }

            return new Widgets.WidgetBase();
        }
    }
}