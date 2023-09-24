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
        private var _currentWeatherIcon = null;
        private var _maxTemp = null as String;
        private var _minTemp = null as String;

        function initialize(params as Dictionary) 
        {
            WidgetBase.initialize(params);
            $.getView().OnWakeUp.add(self);
            self.OnWakeUp();
        }

        function draw(dc as Gfx.Dc) as Void 
        {
            if (self._currentWeatherIcon != null && self._currentTemp != null)
            {
                var iconSize = self._currentWeatherIcon.getWidth();
                var textheight = dc.getFontHeight(HGfx.Fonts.Small);
                var horOffset = 5;

                var locX = self.locX;
                if (self.Justification == WIDGET_JUSTIFICATION_RIGHT)
                {
                    locX = self.locX - iconSize + 10;
                }
                else if (self.Justification == WIDGET_JUSTIFICATION_LEFT)
                {
                    locX = self.locX + iconSize + 10;
                }

                var iconPosX = locX - iconSize - horOffset;
                var iconPosY = self.locY;

                var tempPosX = iconPosX + (iconSize / 2) + (dc.getTextWidthInPixels("°", HGfx.Fonts.Small) / 2);
                var tempPosY = iconPosY + iconSize;                

                dc.setColor(Themes.Colors.Text, Gfx.COLOR_TRANSPARENT);

                //Icon
                dc.drawBitmap(iconPosX, iconPosY, self._currentWeatherIcon);
                dc.drawText(tempPosX, tempPosY, HGfx.Fonts.Small, self._currentTemp + "°", Gfx.TEXT_JUSTIFY_CENTER);

                //vertical line
                var vertLineHeight = iconSize + textheight - 5;
                if (IsSmallDisplay)
                {
                    vertLineHeight -= 3;
                }
                dc.setPenWidth(1);
                dc.drawLine(self.locX, self.locY + 10, self.locX, self.locY + vertLineHeight);

                //maximum temperature
                var maxPosX = self.locX + (iconSize / 2) + horOffset;
                var maxPosY = self.locY + 15;
                if (IsSmallDisplay)
                {
                    maxPosY -= 5;
                }
                dc.drawText(maxPosX, maxPosY, HGfx.Fonts.Small, self._maxTemp + "°", Gfx.TEXT_JUSTIFY_CENTER);
                dc.setPenWidth(2);

                //horizontal line
                var horLineX = self.locX + horOffset + 5;
                var horLineY = self.locY + textheight + 18;

                var txt1 = dc.getTextWidthInPixels(self._maxTemp + "°", HGfx.Fonts.Small);
                var txt2 = dc.getTextWidthInPixels(self._minTemp + "°", HGfx.Fonts.Small);
                var horLineWidth = txt1;
                if (horLineWidth < txt2)
                {
                    horLineWidth = txt2;
                }
                if (IsSmallDisplay)
                {
                    horLineY-= 6;
                }
                dc.drawLine(horLineX, horLineY, horLineX + horLineWidth, horLineY);

                //minimum temperature
                var minPosX = maxPosX;
                var minPosY = maxPosY + textheight + 6;
                if (IsSmallDisplay)
                {
                    minPosY -= 2;
                }
                dc.drawText(minPosX, minPosY, HGfx.Fonts.Small, self._minTemp + "°", Gfx.TEXT_JUSTIFY_CENTER);
            }
        }

        function OnWakeUp()
        {
            //get current weather
            var current = Weather.getCurrentConditions();
            if (current != null)
            {
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
                
                var isNight = false;

                if (location != null)
                {
                    var now = Toybox.Time.now();
                    var sunrise = Weather.getSunrise(location, now);
                    var sunset = Weather.getSunset(location, now);

                    if (sunrise != null && sunset != null)
                    {
                        if (sunrise.greaterThan(now) || sunset.lessThan(now))
                        {
                            isNight = true;
                        }
                    }
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

                self._currentWeatherIcon = null;
                var condition = current.condition;
                if (condition != null)
                {
                    switch (condition)
                    {
                        case Toybox.Weather.CONDITION_CLEAR:
                        case Toybox.Weather.CONDITION_MOSTLY_CLEAR:
                        case Toybox.Weather.CONDITION_FAIR:
                            if (isNight)
                            {
                                self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherClear_Night);
                            }
                            else
                            {
                                self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherClear);
                            }
                            break;
                        case Toybox.Weather.CONDITION_PARTLY_CLOUDY:
                        case Toybox.Weather.CONDITION_PARTLY_CLEAR:
                        case Toybox.Weather.CONDITION_THIN_CLOUDS:
                            if (isNight)
                            {
                                self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherThinClouds_Night);
                            }
                            else
                            {
                                self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherThinClouds);
                            }
                            break;
                        case Toybox.Weather.CONDITION_MOSTLY_CLOUDY:
                            if (isNight)
                            {
                                self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherMostlyCloudy_Night);
                            }
                            else
                            {
                                self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherMostlyCloudy);
                            }
                            break;
                        case Toybox.Weather.CONDITION_CLOUDY:
                        case Toybox.Weather.CONDITION_MOSTLY_CLOUDY:
                            self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherCloudy);
                            break;
                        case Toybox.Weather.CONDITION_LIGHT_RAIN:
                        case Toybox.Weather.CONDITION_LIGHT_SHOWERS:
                        case Toybox.Weather.CONDITION_SHOWERS:
                        case Toybox.Weather.CONDITION_CHANCE_OF_SHOWERS:
                            if (isNight)
                            {
                                self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherLightRain_Night);
                            }
                            else
                            {
                                self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherLightRain);
                            }
                            break;
                        case Toybox.Weather.CONDITION_RAIN:
                        case Toybox.Weather.CONDITION_SCATTERED_SHOWERS:
                        case Toybox.Weather.CONDITION_DRIZZLE:
                        case Toybox.Weather.CONDITION_CHANCE_OF_RAIN_SNOW:
                        case Toybox.Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN:
                            self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherRain);
                            break;
                        case Toybox.Weather.CONDITION_SNOW:
                        case Toybox.Weather.CONDITION_HAIL:
                        case Toybox.Weather.CONDITION_LIGHT_SNOW:
                        case Toybox.Weather.CONDITION_CHANCE_OF_SNOW:
                        case Toybox.Weather.CONDITION_CLOUDY_CHANCE_OF_SNOW:
                            self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherSnow);
                            break;
                        case Toybox.Weather.CONDITION_WINDY:
                        case Toybox.Weather.CONDITION_SQUALL:
                            self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherWindy);
                            break;
                        case Toybox.Weather.CONDITION_THUNDERSTORMS:
                        case Toybox.Weather.CONDITION_SCATTERED_THUNDERSTORMS:
                        case Toybox.Weather.CONDITION_CHANCE_OF_THUNDERSTORMS:
                            self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherThunder);
                            break;
                        case Toybox.Weather.CONDITION_WINTRY_MIX:
                        case Toybox.Weather.CONDITION_LIGHT_RAIN_SNOW:
                        case Toybox.Weather.CONDITION_HEAVY_RAIN_SNOW:
                        case Toybox.Weather.CONDITION_RAIN_SNOW:
                        case Toybox.Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW:
                        case Toybox.Weather.CONDITION_SLEET:
                            self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherRainSnow);
                            break;
                        case Toybox.Weather.CONDITION_FOG:
                        case Toybox.Weather.CONDITION_HAZY:
                        case Toybox.Weather.CONDITION_MIST:
                        case Toybox.Weather.CONDITION_DUST:
                            self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherFog);
                            break;
                        case Toybox.Weather.CONDITION_HEAVY_RAIN:
                        case Toybox.Weather.CONDITION_HEAVY_SHOWERS:
                            self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherHeavyRain);
                            break;
                        case Toybox.Weather.CONDITION_HEAVY_SNOW:
                        case Toybox.Weather.CONDITION_ICE:
                        case Toybox.Weather.CONDITION_HAZE:
                        case Toybox.Weather.CONDITION_FREEZING_RAIN:
                        case Toybox.Weather.CONDITION_ICE_SNOW:
                            self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherHeavySnow);
                            break;
                        case Toybox.Weather.CONDITION_TORNADO:
                        case Toybox.Weather.CONDITION_SMOKE:
                        case Toybox.Weather.CONDITION_SAND:
                        case Toybox.Weather.CONDITION_SANDSTORM:
                        case Toybox.Weather.CONDITION_VOLCANIC_ASH:
                        case Toybox.Weather.CONDITION_HURRICANE:
                        case Toybox.Weather.CONDITION_TROPICAL_STORM:
                        case Toybox.Weather.CONDITION_FLURRIES:
                            self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherExtreme);
                            break;
                        case Toybox.Weather.CONDITION_UNKNOWN_PRECIPITATION:
                        case Toybox.Weather.CONDITION_UNKNOWN:
                    }
                }
            }
            else
            {
                self._currentTemp = null;
                self._maxTemp = null;
                self._minTemp = null;
                self._currentWeatherIcon = null;
            }
        }
    }
}