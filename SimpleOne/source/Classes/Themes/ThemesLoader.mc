import Toybox.Lang;
import Toybox.Application;

module Themes
{
    class ThemesLoader
    {
        private static var _theme = null as ThemeSettingsBase;

        static function getTheme() as ThemeSettingsBase
        {
            if (self._theme == null)
            {
                var theme = Application.Properties.getValue("Theme") as Number;
                switch (theme)
                {
                    default:
                    case 0:
                        self._theme = new DarkBlue();
                        break;
                    case 1:
                        self._theme = new DarkGrey();
                        break;
                    case 2:
                        self._theme = new DarkRed();
                        break;
                }
            }

            return self._theme;
        }
    }
}
