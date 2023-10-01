import Toybox.Lang;
import Toybox.Application;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.System;

(:debug)
module Debug
{
    class GetCodepoints
    {
        private var lastlang = null;

        function GetFontCodePoints() as Void
        {
            if (self.lastlang == System.getDeviceSettings().systemLanguage)
            {
                return; 
            }

            self.lastlang = System.getDeviceSettings().systemLanguage;
            var lang = getLang(self.lastlang);

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
            if (lang != "GRE" && lang != "VIE")
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

            //self.OutputLatin(storage);
            //self.OutputGreek(storage);
            //self.OutputCyrillic(storage);
            //self.OutputLogogram(storage);
            //self.OutputThai(storage);
            self.OutputChatset(storage, [lang]);
        }

        private function OutputLatin(storage as Dictionary) as Void
        {
            var latin = [ "ARA", "HRV", "CES", "DAN", "DUT", "DEU", "ENG", "EST", "FIN", "HUN", "HEB", "IND", "ITA", "LIT", "ZSM", "NOB", "POL", "POR", "RON", "SLO", "SLV", "SPA", "SWE", "TUR", "VIE" ];
            self.OutputChatset(storage, latin);
        }

        private function OutputGreek(storage as Dictionary) as Void
        {
            self.OutputChatset(storage, [ "GRE" ]);
        }

        private function OutputCyrillic(storage as Dictionary) as Void
        {
            var cyrilic = [ "RUS", "BUL", "UKR" ];
            self.OutputChatset(storage, cyrilic);
        }

        private function OutputLogogram(storage as Dictionary) as Void
        {
            var logogram = [ "CHS", "CHT", "JPN", "KOR", "THA" ];
            self.OutputChatset(storage, logogram);
        }

        private function OutputThai(storage as Dictionary) as Void
        {
            self.OutputChatset(storage, [ "THA" ]);
        }

        private function OutputChatset(storage as Dictionary, languages as Array) as Void
        {
            var all = [];
            var notfound = false;
            for (var i = 0; i < languages.size(); i++)
            {
                if (!storage.hasKey(languages[i]))
                {
                    System.println("Language " + languages[i] + " not found!");
                    notfound = true;
                    continue;
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

            if (notfound) 
            {
                return;
            }

            all = MergeSort.Sort(all);
            System.println("CodePoints: " + all.size() + " characters\n");
            for (var i = 0; i < all.size(); i++)
            {
                System.print(all[i] + " ");
            }
        }

        private function getLang(code as Number) as String
        {
            switch (code)
            {
                case 8389920:
                    return "ARA"; //Latin
                case 8389921:
                    return "BUL"; //Cyrillic
                case 8389352:
                    return "CES"; //Lation
                case 8389372:
                    return "CHS"; //Logogram
                case 8389371:
                    return "CHT"; //Logogram
                case 8389353:
                    return "DAN"; //Latin
                case 8389358:
                    return "DEU"; //Latin
                case 8389354:
                    return "DUT"; //Latin
                case 8389355:
                    return "ENG"; //Latin
                case 8390796:
                    return "EST"; //Latin
                case 8389356:
                    return "FIN"; //Latin
                case 8389357:
                    return "FRE"; //Latin
                case 8389359:
                    return "GRE"; //Greek
                case 8389919:
                    return "HEB"; //Latin
                case 8389361:
                    return "HRV"; //Latin
                case 8389360:
                    return "HUN"; //Latin
                case 8389578:
                    return "IND"; //Latin
                case 8389362:
                    return "ITA"; //Latin
                case 8389373:
                    return "JPN"; //Logogram
                case 8389696:
                    return "KOR"; //Logogram
                case 8390797:
                    return "LAV"; //Latin
                case 8390798:
                    return "LIT"; //Latin
                case 8389363:
                    return "NOB"; //Latin
                case 8389364:
                    return "POL"; //Latin
                case 8389365:
                    return "POR"; //Latin
                case 8390799:
                    return "RON"; //Latin
                case 8389366:
                    return "RUS"; //Cyrillic
                case 8389367:
                    return "SLO"; //Latin
                case 8389368:
                    return "SLV"; //Latin
                case 8389369:
                    return "SPA"; //Latin
                case 8389370:
                    return "SWE"; //Latin
                case 8389548:
                    return "THA"; //Logogram
                case 8389774:
                    return "TUR"; //Latin
                case 8390800:
                    return "UKR"; //Cyrillic
                case 8390206:
                    return "VIE"; //Latin
                case 8389579:
                    return "ZSM"; //Latin
            }

            return code.toString();
        }
    }
}