import Toybox.Application;
using Toybox.Graphics as Gfx;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Helper;
using Toybox.Time.Gregorian as D;
using Helper.Gfx as HGfx;

module Widgets 
{
    class Date extends WidgetBase
    { 
        private var _textContainer as ExtText;
        private var _Texts = new[3] as Array<ExtTextPart>;

        function initialize(params as Dictionary)
        {
            WidgetBase.initialize(params);

            self._textContainer = new ExtText(self.locX, self.locY, ExtText.HJUST_CENTER, ExtText.VJUST_CENTER);
            self._Texts[0] = new ExtTextPart("", Themes.Colors.DateWeekday, HGfx.Fonts.Date);
            self._Texts[1] = new ExtTextPart("", Themes.Colors.DateDay, HGfx.Fonts.Date);
            self._Texts[2] = new ExtTextPart("", Themes.Colors.DateYear, HGfx.Fonts.Date);
        }

        function draw(dc as Gfx.Dc)
        {
            var now = Time.now();
            var time = D.info(now, Time.FORMAT_SHORT);

            self._Texts[0].Text = Helper.Date.ShortWeekyday(time.day_of_week).toUpper() + " "; //toUpper() because date-font only have uppercase letters to save space
            self._Texts[1].Text = time.day.toString() + "." + Helper.Date.ShortMonth(time.month).toUpper() + " ";
            self._Texts[2].Text = time.year.toString();

            self._textContainer.draw(self._Texts, dc);
        }
    }
}