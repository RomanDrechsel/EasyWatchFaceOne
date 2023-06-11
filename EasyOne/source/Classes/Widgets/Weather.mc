using Toybox.Graphics as Gfx;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Weather;
using Helper.Gfx as HGfx;

module Widgets 
{
    class Weather extends WidgetBase
    {  
        private var _currentTemp = null as String;
        private var _currentWeatherIcon = null as BitmapResource;
        private var _maxTemp = null as String;
        private var _minTemp = null as String;
        private var _sunrise = null;
        private var _sunset = null;

        private var _font = null as FontResource;

        private var _calcPos = false;
        private var _iconPosX = 0;
        private var _iconPosY = 0;
        private var _tempPosX = 0;
        private var _tempPosY = 0;
        private var _maxPosX = 0;
        private var _maxPosY = 0;
        private var _minPosX = 0;
        private var _minPosY = 0;
        private var _horLineX = 0;
        private var _horLineY = 0;
        private var _horLineWidth = 35;
        private var _vertLineHeight = 10;

        function initialize(params as Dictionary) 
        {
            WidgetBase.initialize(params);

            self._font = HGfx.Fonts.Small;

            $.getView().OnWakeUp.add(self.method(:OnWakeUp));
            self.OnWakeUp();
        }

        function draw(dc as Gfx.Dc) as Void 
        {
            if (self._currentWeatherIcon != null && self._currentTemp != null)
            {
                if (self._calcPos == false)
                {
                    self.CalcPos(dc);
                }

                dc.setColor(self._theme.MainTextColor, Gfx.COLOR_TRANSPARENT);

                dc.drawBitmap(self._iconPosX, self._iconPosY, self._currentWeatherIcon);
                dc.drawText(self._tempPosX, self._tempPosY, self._font, self._currentTemp + "°", Gfx.TEXT_JUSTIFY_CENTER);

                dc.setPenWidth(1);
                dc.drawLine(self.locX, self.locY + 10, self.locX, self.locY + self._vertLineHeight);

                dc.drawText(self._maxPosX, self._maxPosY, self._font, self._maxTemp + "°", Gfx.TEXT_JUSTIFY_CENTER);
                dc.setPenWidth(2);
                dc.drawLine(self._horLineX, self._horLineY, self._horLineX + self._horLineWidth, self._horLineY);
                dc.drawText(self._minPosX, self._minPosY, self._font, self._minTemp + "°", Gfx.TEXT_JUSTIFY_CENTER);
            }
        }

        function OnWakeUp()
        {
            //get current weather
            var current = Weather.getCurrentConditions();
            if (current != null)
            {
                self._calcPos = false;

                var settings = Toybox.System.getDeviceSettings();

                var maxtemp = current.highTemperature;
                var mintemp = current.lowTemperature;
                var ctemp = current.temperature;

                var location = current.observationLocationPosition;
                if (location == null)
                {
                    var info = Toybox.Position.getInfo();
                    if (info != null)
                    {
                        location = info.position;
                    }
                }
                if (location != null)
                {
                    var now = Toybox.Time.now();
                    self._sunrise = Weather.getSunrise(location, now);
                    self._sunset = Weather.getSunset(location, now);
                }
                else
                {
                    self._sunrise = null;
                    self._sunset = null;
                }

                if (settings.temperatureUnits == Toybox.System.UNIT_STATUTE)
                {
                    //calc to fahrenheit
                    if (ctemp != null)
                    {
                        ctemp = (ctemp.toFloat() * (9.0/5.0)) + 32.0;
                        ctemp = ctemp.toNumber();
                    }
                    if (mintemp != null)
                    {
                        mintemp = (mintemp.toFloat() * (9.0/5.0)) + 32.0;
                        mintemp = mintemp.toNumber();
                    }
                    if (maxtemp != null)
                    {
                        maxtemp = (maxtemp.toFloat() * (9.0/5.0)) + 32.0;
                        maxtemp = maxtemp.toNumber();
                    }
                }

                self._currentTemp = ctemp;
                self._maxTemp = maxtemp;
                self._minTemp = mintemp;

                var condition = current.condition;
                if (condition != null)
                {
                    switch (condition)
                    {
                        case Toybox.Weather.CONDITION_CLEAR:
                        case Toybox.Weather.CONDITION_MOSTLY_CLEAR:
                        case Toybox.Weather.CONDITION_FAIR:
                            if (self.isNight())
                            {
                                self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherClear_Night) as BitmapResource;
                            }
                            else
                            {
                                self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherClear) as BitmapResource;
                            }
                            break;
                        case Toybox.Weather.CONDITION_PARTLY_CLOUDY:
                        case Toybox.Weather.CONDITION_PARTLY_CLEAR:
                        case Toybox.Weather.CONDITION_THIN_CLOUDS:
                            if (self.isNight())
                            {
                                self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherThinClouds_Night) as BitmapResource;
                            }
                            else
                            {
                                self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherThinClouds) as BitmapResource;
                            }
                            break;
                        case Toybox.Weather.CONDITION_MOSTLY_CLOUDY:
                            if (self.isNight())
                            {
                                self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherMostlyCloudy_Night) as BitmapResource;
                            }
                            else
                            {
                                self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherMostlyCloudy) as BitmapResource;
                            }
                            break;
                        case Toybox.Weather.CONDITION_CLOUDY:
                        case Toybox.Weather.CONDITION_MOSTLY_CLOUDY:
                            self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherCloudy) as BitmapResource;
                            break;
                        case Toybox.Weather.CONDITION_LIGHT_RAIN:
                        case Toybox.Weather.CONDITION_LIGHT_SHOWERS:
                        case Toybox.Weather.CONDITION_SHOWERS:
                        case Toybox.Weather.CONDITION_CHANCE_OF_SHOWERS:
                            if (self.isNight())
                            {
                                self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherLightRain_Night) as BitmapResource;
                            }
                            else
                            {
                                self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherLightRain) as BitmapResource;
                            }
                            break;
                        case Toybox.Weather.CONDITION_RAIN:
                        case Toybox.Weather.CONDITION_SCATTERED_SHOWERS:
                        case Toybox.Weather.CONDITION_DRIZZLE:
                        case Toybox.Weather.CONDITION_CHANCE_OF_RAIN_SNOW:
                        case Toybox.Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN:
                            self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherRain) as BitmapResource;
                            break;
                        case Toybox.Weather.CONDITION_SNOW:
                        case Toybox.Weather.CONDITION_HAIL:
                        case Toybox.Weather.CONDITION_LIGHT_SNOW:
                        case Toybox.Weather.CONDITION_CHANCE_OF_SNOW:
                        case Toybox.Weather.CONDITION_CLOUDY_CHANCE_OF_SNOW:
                            self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherSnow) as BitmapResource;
                            break;
                        case Toybox.Weather.CONDITION_WINDY:
                        case Toybox.Weather.CONDITION_SQUALL:
                            self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherWindy) as BitmapResource;
                            break;
                        case Toybox.Weather.CONDITION_THUNDERSTORMS:
                        case Toybox.Weather.CONDITION_SCATTERED_THUNDERSTORMS:
                        case Toybox.Weather.CONDITION_CHANCE_OF_THUNDERSTORMS:
                            self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherThunder) as BitmapResource;
                            break;
                        case Toybox.Weather.CONDITION_WINTRY_MIX:
                        case Toybox.Weather.CONDITION_LIGHT_RAIN_SNOW:
                        case Toybox.Weather.CONDITION_HEAVY_RAIN_SNOW:
                        case Toybox.Weather.CONDITION_RAIN_SNOW:
                        case Toybox.Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW:
                        case Toybox.Weather.CONDITION_SLEET:
                            self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherRainSnow) as BitmapResource;
                            break;
                        case Toybox.Weather.CONDITION_FOG:
                        case Toybox.Weather.CONDITION_HAZY:
                        case Toybox.Weather.CONDITION_MIST:
                        case Toybox.Weather.CONDITION_DUST:
                            self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherFog) as BitmapResource;
                            break;
                        case Toybox.Weather.CONDITION_HEAVY_RAIN:
                        case Toybox.Weather.CONDITION_HEAVY_SHOWERS:
                            self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherHeavyRain) as BitmapResource;
                            break;
                        case Toybox.Weather.CONDITION_HEAVY_SNOW:
                        case Toybox.Weather.CONDITION_ICE:
                        case Toybox.Weather.CONDITION_HAZE:
                        case Toybox.Weather.CONDITION_FREEZING_RAIN:
                        case Toybox.Weather.CONDITION_ICE_SNOW:
                            self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherHeavySnow) as BitmapResource;
                            break;
                        case Toybox.Weather.CONDITION_TORNADO:
                        case Toybox.Weather.CONDITION_SMOKE:
                        case Toybox.Weather.CONDITION_SAND:
                        case Toybox.Weather.CONDITION_SANDSTORM:
                        case Toybox.Weather.CONDITION_VOLCANIC_ASH:
                        case Toybox.Weather.CONDITION_HURRICANE:
                        case Toybox.Weather.CONDITION_TROPICAL_STORM:
                        case Toybox.Weather.CONDITION_FLURRIES:
                            self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherExtreme) as BitmapResource;
                            break;
                        case Toybox.Weather.CONDITION_UNKNOWN_PRECIPITATION:
                        case Toybox.Weather.CONDITION_UNKNOWN:
                        default:
                            self._currentWeatherIcon = null as BitmapResource;
                            break;
                    }
                }
            }
            else
            {
                self._currentTemp = null;
                self._maxTemp = null;
                self._minTemp = null;
                self._currentWeatherIcon = null;
                self._sunrise = null;
                self._sunset = null;
            }
        }

        private function isNight() as Boolean
        {
            if (self._sunrise != null && self._sunset != null)
            {
                var now = Toybox.Time.now();
                var sr_comp = self._sunrise.compare(now);
                var ss_comp = self._sunset.compare(now);
                if (self._sunrise.compare(now) > 0 || self._sunset.compare(now) < 0)
                {
                    return true;
                }
            }

            return false;
        }

        private function CalcPos(dc as Gfx.Dc)
        {
            if (self._currentWeatherIcon != null)
            {
                var iconwidth = self._currentWeatherIcon.getWidth();
                var iconheight = self._currentWeatherIcon.getHeight();
                var textheight = dc.getFontHeight(self._font);
                var horOffset = 5;

                self._iconPosX = self.locX - iconwidth - horOffset;
                self._iconPosY = self.locY;

                self._tempPosX = self._iconPosX + (iconwidth / 2) + (dc.getTextWidthInPixels("°", self._font) / 2);
                self._tempPosY = self._iconPosY + iconheight;

                self._maxPosX = self.locX + (iconwidth / 2) + horOffset;
                self._maxPosY = self.locY + 15;

                self._minPosX = self._maxPosX;
                self._minPosY = self._maxPosY + textheight + 6;

                self._horLineX = self.locX + horOffset + 5;
                self._horLineY = self.locY + 18 + textheight;

                self._vertLineHeight = (iconheight + textheight) - 8;
                self._horLineWidth = 35;
                var txt1 = dc.getTextWidthInPixels(self._maxTemp + "°", self._font);
                var txt2 = dc.getTextWidthInPixels(self._minTemp + "°", self._font);

                if (self._horLineWidth < txt1)
                {
                    self._horLineWidth = txt1;
                }

                if (self._horLineWidth < txt2)
                {
                    self._horLineWidth = txt2;
                }
            }
            self._calcPos = true;
        }
    }
}