import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Helper;
import Helper.Gfx;
import Toybox.Time.Gregorian;

module Widgets 
{
    class Date extends WidgetBase
    { 
        private var _textContainer as ExtText;
        private var _texts;

        function initialize(params as Dictionary)
        {
            WidgetBase.initialize(params);
            self._textContainer = new ExtText(self.locX, self.locY, Graphics.TEXT_JUSTIFY_CENTER);
        }

        function draw(dc as Dc)
        {
            if (Gfx.Fonts.Date == null)
            {
                self._texts = null;
                return;
            }
            else if (self._texts == null)
            {
                self._texts = [];
                self._texts.add(new ExtTextPart("", Themes.Colors.DateWeekday, Gfx.Fonts.Date));
                self._texts.add(new ExtTextPart("", Themes.Colors.DateDay, Gfx.Fonts.Date));
                self._texts.add(new ExtTextPart("", Themes.Colors.DateYear, Gfx.Fonts.Date));
            }
            else
            {
                self._texts[0].Font = Gfx.Fonts.Date;
                self._texts[1].Font = Gfx.Fonts.Date;
                self._texts[2].Font = Gfx.Fonts.Date;
            }

            if (Gfx.Fonts.DateFontRez == 0)
            {
                self._textContainer.AnchorY = self.locY - 5;
            }
            else if (Gfx.Fonts.DateFontRez == 2)
            {
                self._textContainer.AnchorY = self.locY - 5;
            }

            var time = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);

            var systemlang = System.getDeviceSettings().systemLanguage;
            if (systemlang!= System.LANGUAGE_GRE)
            {
                self._texts[0].Text = time.day_of_week.toUpper() + " "; //toUpper() because date-font only have uppercase letters to save memory
            }
            else
            {
                self._texts[0].Text = "";
            }
            
            self._texts[1].Text = time.day.toString() + "." + time.month.toUpper() + " ";
            self._texts[2].Text = time.year.toString();

            self._textContainer.draw(self._texts, dc);
        }
    }
}