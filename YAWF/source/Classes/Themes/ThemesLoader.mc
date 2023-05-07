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
                        self._theme = new BlackAndBlue();
                        break;
                }
            }

            return self._theme;
        }
    }
}
