import Toybox.Application;
using Toybox.Graphics as Gfx;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Helper;
using Toybox.Time.Gregorian as D;

module Widgets 
{
    class Date extends WidgetBase
    { 
        private var _textContainer as ExtText;
        private var _Font = null as FontResource;
        private var _Theme = null as Themes.ThemeSettingsBase;
        private var _Texts = new[3] as Array<ExtTextPart>;

        function initialize(params as Dictionary)
        {
            WidgetBase.initialize(params);
            self._Font = WatchUi.loadResource(Rez.Fonts.DateFont) as FontResource;
            self._Theme =  $.getTheme();

            self._textContainer = new ExtText(self.locX, self.locY, ExtText.HJUST_CENTER, ExtText.VJUST_CENTER);
            self._Texts[0] = new ExtTextPart("", self._Theme.DateWeekdayColor, self._Font);
            self._Texts[1] = new ExtTextPart("", self._Theme.DateDayColor, self._Font);
            self._Texts[2] = new ExtTextPart("", self._Theme.DateYearColor, self._Font);
            self._initialized = true;
        }

        function draw(dc as Gfx.Dc)
        {
            var now = Time.now();
            var time = D.info(now, Time.FORMAT_SHORT);

            self._Texts[0].Text = Helper.Date.ShortWeekyday(time.day_of_week).toLower() + " "; //toLower() because date-font only have lowercase letters to save space
            self._Texts[1].Text = time.day.toString() + "." + Helper.Date.ShortMonth(time.month).toLower() + " ";
            self._Texts[2].Text = time.year.toString();

            self._textContainer.draw(self._Texts, dc);
        }
    }
}