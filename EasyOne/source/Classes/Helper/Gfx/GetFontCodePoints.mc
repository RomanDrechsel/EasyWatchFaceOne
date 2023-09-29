import Toybox.Lang;
import Toybox.Application;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.System;

(:debug)
module Helper
{ 
    module Gfx
    {
        var lastlang = null;
        function GetFontCodePoints() as Void
        {
            if (lastlang == System.getDeviceSettings().systemLanguage)
            {
                return; 
            }

            lastlang = System.getDeviceSettings().systemLanguage;
            var lang = getLang(lastlang);

            var codepoints = [];

            var chars = " 0123456789.".toCharArray();
            for (var i = 0; i < chars.size(); i++)
            {
                if (codepoints.indexOf(chars[i]) < 0)
                {
                    codepoints.add(chars[i]);
                }
            }

            //Weekdays 
            if (lang != "GRE")
            {
                var day = 1;
                while (day <= 7)
                {
                    var options = {
                        :year   => 1970,
                        :month  => 1,
                        :day    => day,
                        :hour   => 12
                    };

                    var date = Gregorian.moment(options);
                    var info = Gregorian.utcInfo(date, Time.FORMAT_MEDIUM);

                    chars = info.day_of_week.toUpper().toCharArray();
                    for (var i = 0; i < chars.size(); i++)
                    {
                        if (codepoints.indexOf(chars[i]) < 0)
                        {
                            codepoints.add(chars[i]);
                        }
                    }

                    day++;
                }
            }

            var month = 1;
            while (month <= 12)
            {
                var options = {
                    :year   => 1970,
                    :month  => month,
                    :day    => 1,
                    :hour   => 12
                };

                var date = Gregorian.moment(options);
                var info = Gregorian.utcInfo(date, Time.FORMAT_MEDIUM);

                chars = info.month.toUpper().toCharArray();
                for (var i = 0; i < chars.size(); i++)
                {
                    if (codepoints.indexOf(chars[i]) < 0)
                    {
                        codepoints.add(chars[i]);
                    }
                }

                month++;
            }

            codepoints = MergeSort.Sort(codepoints);
            System.println(lang + ": " + codepoints.size() + " Codepoints");

            var storage = Application.Storage.getValue("codepoints");
            if (storage == null)
            {
                storage = {};
            }

            if (storage.hasKey(lang))
            {
                storage[lang] = codepoints;
            }
            else
            {
                storage.put(lang, codepoints);
            }

            Application.Storage.setValue("codepoints", storage);

            //OutputLatin(storage);
            OutputGreek(storage);
            //OutputCyrillic(storage);
        }

        function OutputLatin(storage as Dictionary) as Void
        {
            var latin = [ "ARA", "HRV", "CES", "DAN", "DUT", "DEU", "ENG", "EST", "FIN", "HUN", "IND", "ITA", "LIT", "ZSM", "NOB", "POL", "POR", "RON", "SLO", "SLV", "SPA", "SWE","TUR" ];
            OutputChatset(storage, latin);
        }

        function OutputGreek(storage as Dictionary) as Void
        {
            OutputChatset(storage, [ "GRE" ]);
        }

        function OutputCyrillic(storage as Dictionary) as Void
        {
            var cyrilic = [ "RUS", "BUL", "UKR" ];
            OutputChatset(storage, cyrilic);
        }

        function OutputChatset(storage as Dictionary, languages as Array) as Void
        {
            var all = [];
            for (var i = 0; i < languages.size(); i++)
            {
                if (!storage.hasKey(languages[i]))
                {
                    System.println("Language " + languages[i] + " not found!");
                    return;
                }

                var codepoints = storage[languages[i]];
                for (var j = 0; j < codepoints.size(); j++)
                {
                    var c = codepoints[j]. toNumber();
                    if (all.indexOf(c) < 0)
                    {
                        all.add(c);
                    }
                }
            }

            all = MergeSort.Sort(all);
            System.println("CodePoints: " + all.size() + " characters\n");
            for (var i = 0; i < all.size(); i++)
            {
                System.print(all[i] + " ");
            }
        }

        function getLang(code as Number) as String
        {
            switch (code)
            {
                case 8389920:
                    return "ARA";
                case 8389921:
                    return "BUL";
                case 8389352:
                    return "CES";
                case 8389372:
                    return "CHS";
                case 8389371:
                    return "CHT";
                case 8389353:
                    return "DAN";
                case 8389358:
                    return "DEU";
                case 8389354:
                    return "DUT";
                case 8389355:
                    return "ENG";
                case 8390796:
                    return "EST";
                case 8389356:
                    return "FIN";
                case 8389357:
                    return "FRE";
                case 8389359:
                    return "GRE";
                case 8389919:
                    return "HEB";
                case 8389361:
                    return "HRV";
                case 8389360:
                    return "HUN";
                case 8389578:
                    return "IND";
                case 8389362:
                    return "ITA";
                case 8389373:
                    return "JPN";
                case 8389696:
                    return "KOR";
                case 8390797:
                    return "LAV";
                case 8390798:
                    return "LIT";
                case 8389363:
                    return "NOB";
                case 8389364:
                    return "POL";
                case 8389365:
                    return "POR";
                case 8390799:
                    return "RON";
                case 8389366:
                    return "RUS";
                case 8389367:
                    return "SLO";
                case 8389368:
                    return "SLV";
                case 8389369:
                    return "SPA";
                case 8389370:
                    return "SWE";
                case 8389548:
                    return "THA";
                case 8389774:
                    return "TUR";
                case 8390800:
                    return "UKR";
                case 8390206:
                    return "VIE";
                case 8389579:
                    return "ZSM";
            }

            return code.toString();
        }

        class MergeSort 
        {
            static function Sort(array as Array) as Array
            {
                if (array == null || !(array instanceof Array))
                {
                    return null;
                }
                else if (array.size() <= 1)
                {
                    return array;
                }

                var mid = (array.size() / 2).toNumber();
                var subarray1 = self.Sort(array.slice(0, mid));
                var subarray2 = self.Sort(array.slice(mid, null));
                
                return self.Merge(subarray1, subarray2);
            }

            private static function Merge(array1 as Array, array2 as Array) as Array
            {
                var result = [];

                var val1, val2;

                while (array1.size() > 0 && array2.size() > 0)
                {
                    val1 = array1[0];
                    val2 = array2[0];
                    if(val1 != null && (val2 == null || val1 > val2))
                    {
                        result.add(array2[0]);
                        array2 = array2.slice(1, null);
                    }
                    else
                    {
                        result.add(array1[0]);
                        array1 = array1.slice(1, null);
                    }
                }

                while (array1.size() > 0)
                {
                    result.add(array1[0]);
                    array1 = array1.slice(1, null);
                }

                while (array2.size() > 0)
                {
                    result.add(array2[0]);
                    array2 = array2.slice(1, null);
                }

                return result;
            }
        }
    }
}