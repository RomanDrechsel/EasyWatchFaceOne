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
                var theme = Application.Properties.getValue("Th") as Number;
                switch (theme)
                {
                    default:
                    case 0:
                        self._theme = new DarkBlue();
                        break;
                    case 1:
                        self._theme = new Fire();
                        break;
                    case 2:
                        self._theme = new Sunset();
                        break;
                    case 3:
                        self._theme = new BlackAndWhite();
                        break;
                    case 666:
                        self._theme = new BSoD();
                        break;
                }
            }

            if (self._theme == null)
            {
                self._theme = new ThemeSettingsBase();
            }

            return self._theme;
        }

        static function ResetTheme()
        {
            self._theme = null;
        }
    }
}
