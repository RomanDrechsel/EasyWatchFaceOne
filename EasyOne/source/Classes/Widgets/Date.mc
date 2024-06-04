import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Helper.Gfx;
import Toybox.Time.Gregorian;

module Widgets
{
    class Date extends WidgetBase
    {
        private var _textContainer as Helper.ExtText;
        private var _texts as Array<Helper.ExtTextPart> or Null;
        private var _dateFormat as Number;

        function initialize(params as Dictionary)
        {
            WidgetBase.initialize(params);
            self._textContainer = new Helper.ExtText(self.locX, self.locY, Graphics.TEXT_JUSTIFY_CENTER);
            var setting = Application.Properties.getValue("DF") as Number;
            if (setting != null)
            {
                self._dateFormat = setting;
            }
            else
            {
                self._dateFormat = 1;
            }
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
                self._texts.add(new Helper.ExtTextPart(null, Themes.Colors.DateWeekday, Gfx.Fonts.Date));
                self._texts.add(new Helper.ExtTextPart(null, Themes.Colors.DateDay, Gfx.Fonts.Date));
                self._texts.add(new Helper.ExtTextPart(null, Themes.Colors.DateYear, Gfx.Fonts.Date));
            }
            else
            {
                self._texts[0].Font = Gfx.Fonts.Date;
                self._texts[1].Font = Gfx.Fonts.Date;
                self._texts[2].Font = Gfx.Fonts.Date;
            }

            if (IsSmallDisplay)
            {
                if (Gfx.Fonts.DateFontProp == 0 || Gfx.Fonts.DateFontProp == 50 || Gfx.Fonts.DateFontProp == 90)
                {
                    self._textContainer.AnchorY = self.locY - 7;
                }
                else if (Gfx.Fonts.DateFontProp == 2)
                {
                    self._textContainer.AnchorY = self.locY - 2;
                }
                else if (Gfx.Fonts.DateFontProp == 70)
                {
                    self._textContainer.AnchorY = self.locY - 8;
                }
                else if (Gfx.Fonts.DateFontProp == 80)
                {
                    self._textContainer.AnchorY = self.locY - 12;
                }
                else if (Gfx.Fonts.DateFontProp == -1)
                {
                    self._textContainer.AnchorY = self.locY + 2;
                }
            }
            else
            {
                if (Gfx.Fonts.DateFontProp == 0 || Gfx.Fonts.DateFontProp == 90)
                {
                    self._textContainer.AnchorY = self.locY - 10;
                }
                else if (Gfx.Fonts.DateFontProp == 1 || Gfx.Fonts.DateFontProp == 2 || Gfx.Fonts.DateFontProp == 50)
                {
                    self._textContainer.AnchorY = self.locY - 5;
                }
                else if (Gfx.Fonts.DateFontProp == 70)
                {
                    self._textContainer.AnchorY = self.locY - 10;
                }
                else if (Gfx.Fonts.DateFontProp == 80)
                {
                    self._textContainer.AnchorY = self.locY - 15;
                }
                else if (Gfx.Fonts.DateFontProp == -1 && [System.LANGUAGE_CHS, System.LANGUAGE_CHT].indexOf(System.getDeviceSettings().systemLanguage) >= 0)
                {
                    self._textContainer.AnchorY = self.locY - 5;
                }
            }

            var time;
            if (self._dateFormat <= 2)
            {
                time = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
            }
            else
            {
                time = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
            }

            var day = time.day.format("%02d");
            var month;
            if (time.month instanceof Number)
            {
                month = time.month.format("%02d");
            }
            else
            {
                month = time.month.toUpper();
            }
            var year = time.year.toString();

            if (self._dateFormat <= 2)
            {
                //toUpper() because date-font only have uppercase letters to save memory
                self._texts[0].Text = time.day_of_week.toUpper() + " ";
            }
            else
            {
                self._texts[0].Text = null;
            }

            if (self._dateFormat == 1)
            {
                self._texts[1] = new Helper.ExtTextPart(day + "." + month + " ", Themes.Colors.DateDay, Gfx.Fonts.Date);
                self._texts[2] = new Helper.ExtTextPart(year, Themes.Colors.DateYear, Gfx.Fonts.Date);
            }
            else if (self._dateFormat == 2)
            {
                self._texts[1] = new Helper.ExtTextPart(month + " " + day + " ", Themes.Colors.DateDay, Gfx.Fonts.Date);
                self._texts[2] = new Helper.ExtTextPart(year, Themes.Colors.DateYear, Gfx.Fonts.Date);
            }
            else if (self._dateFormat == 3)
            {
                self._texts[1] = new Helper.ExtTextPart(day + "." + month + ".", Themes.Colors.DateDay, Gfx.Fonts.Date);
                self._texts[2] = new Helper.ExtTextPart(year, Themes.Colors.DateYear, Gfx.Fonts.Date);
            }
            else if (self._dateFormat == 4)
            {
                self._texts[1] = new Helper.ExtTextPart(month + "/" + day + "/", Themes.Colors.DateDay, Gfx.Fonts.Date);
                self._texts[2] = new Helper.ExtTextPart(year, Themes.Colors.DateYear, Gfx.Fonts.Date);
            }
            else if (self._dateFormat == 5)
            {
                self._texts[1] = new Helper.ExtTextPart(year, Themes.Colors.DateYear, Gfx.Fonts.Date);
                self._texts[2] = new Helper.ExtTextPart("/" + month + "/" + day, Themes.Colors.DateDay, Gfx.Fonts.Date);
            }

            //in some languages, the day_of_week string is too long to be displayed ...
            if (Helper.ExtText.calcDimensions(self._texts, dc)[0] > dc.getWidth() * 0.9)
            {
                self._texts[0].Text = null;
            }

            self._textContainer.draw(self._texts, dc);
        }
    }
}
