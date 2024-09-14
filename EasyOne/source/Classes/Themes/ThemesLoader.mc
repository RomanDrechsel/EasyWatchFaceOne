import Toybox.Lang;
import Toybox.Application;

module Themes {
    class ThemesLoader {
        static var Theme as ThemeSettingsBase? = null;

        static function loadTheme() as Void {
            var theme = Helper.Properties.Get("Th", -1) as Number;

            switch (theme) {
                default:
                case 0:
                    self.Theme = new DarkBlue();
                    break;
                case 1:
                    self.Theme = new Fire();
                    break;
                case 2:
                    self.Theme = new Sunset();
                    break;
                case 3:
                    self.Theme = new BlackAndWhite();
                    break;
                case 666:
                    self.Theme = new BSoD();
                    break;
            }
            $.Log("Loaded Theme " + theme.toString());
        }
    }
}

function getTheme() as Themes.ThemeSettingsBase {
    if (Themes.ThemesLoader.Theme == null) {
        Themes.ThemesLoader.loadTheme();
    }
    return Themes.ThemesLoader.Theme;
}
