using Toybox.Graphics as Gfx;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Weather;
using Helper.Gfx as HGfx;

module Widgets {
    class Weather extends WidgetBase {
        private var _currentTemp as String? = null;
        private var _currentWeatherIcon as Gfx.BitmapType? = null;
        private var _maxTemp as String? = null;
        private var _minTemp as String? = null;

        function initialize(params as Dictionary) {
            WidgetBase.initialize(params);
            var view = $.getView();
            if (view != null) {
                view.OnShow.add(self);
                view.OnSleep.add(self);
            }
            self.OnShow();
        }

        function draw(dc as Gfx.Dc) as Void {
            var iconPosX = null;
            var iconPosY = null;
            var tempPosX = null;
            var tempPosY = null;
            var vertLineHeight = null;
            var maxPosX = null;
            var maxPosY = null;
            var minPosY = null;
            var textHeight = dc.getFontHeight(HGfx.Fonts.Small);
            var horPadding = 3;
            var tempAlign = Gfx.TEXT_JUSTIFY_CENTER;

            var centerX = self.locX;
            if (self.Justification == WIDGET_JUSTIFICATION_RIGHT) {
                centerX = self.locX + 10;
            } else if (self.Justification == WIDGET_JUSTIFICATION_LEFT) {
                centerX = self.locX + (IsSmallDisplay ? 5 : 15);
            }

            dc.setColor(Themes.Colors.Text, Gfx.COLOR_TRANSPARENT);

            if (self._currentWeatherIcon != null && self._currentTemp != null && HGfx.Fonts.Small != null) {
                var iconSize = self._currentWeatherIcon.getWidth();
                vertLineHeight = iconSize + textHeight - (IsSmallDisplay ? 8 : 5);

                if (self.Justification == WIDGET_JUSTIFICATION_RIGHT) {
                    centerX -= iconSize;
                } else if (self.Justification == WIDGET_JUSTIFICATION_LEFT) {
                    centerX += iconSize;
                }

                iconPosX = centerX - iconSize - horPadding;
                iconPosY = self.locY;

                if (self._minTemp != null && self._maxTemp != null) {
                    tempPosX = iconPosX + (iconSize / 2).toNumber();
                    tempPosY = iconPosY + iconSize;
                    maxPosX = centerX + (iconSize / 2).toNumber() + horPadding;
                    maxPosY = self.locY + (IsSmallDisplay ? 6 : 10);
                    minPosY = maxPosY + textHeight + (IsSmallDisplay ? 4 : 6);
                } else {
                    iconPosY += IsSmallDisplay ? 6 : 10;
                    tempPosX = centerX + horPadding * 2;
                    tempAlign = Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER;
                    tempPosY = iconPosY + (iconSize / 2).toNumber() + 2;
                }
            }

            //Icon
            if (self._currentWeatherIcon != null && iconPosX != null && iconPosY != null) {
                dc.drawBitmap(iconPosX, iconPosY, self._currentWeatherIcon);
            }

            //current temperature
            if (self._currentTemp != null && tempPosX != null && tempPosY != null) {
                dc.drawText(tempPosX, tempPosY, HGfx.Fonts.Small, self._currentTemp, tempAlign);
            }

            //vertical line
            if (vertLineHeight != null) {
                dc.setPenWidth(1);
                dc.drawLine(centerX, self.locY + 10, centerX, self.locY + vertLineHeight);
            }

            //minimum and maximum temperature
            if (self._maxTemp != null && self._minTemp != null && maxPosX != null && maxPosY != null && minPosY != null) {
                //maximum
                dc.drawText(maxPosX, maxPosY, HGfx.Fonts.Small, self._maxTemp, Gfx.TEXT_JUSTIFY_CENTER);

                //horizontal line
                dc.setPenWidth(2);
                var txt1 = dc.getTextWidthInPixels(self._maxTemp, HGfx.Fonts.Small);
                var txt2 = dc.getTextWidthInPixels(self._minTemp, HGfx.Fonts.Small);
                var horLineWidth = txt1;
                if (horLineWidth < txt2) {
                    horLineWidth = txt2;
                }

                var horLineX = maxPosX - (horLineWidth / 2).toNumber() - (IsSmallDisplay ? 1 : 3);
                var horLineY = maxPosY + textHeight + (IsSmallDisplay ? 2 : 5);
                dc.drawLine(horLineX, horLineY, horLineX + horLineWidth, horLineY);

                //minimum
                dc.drawText(maxPosX, minPosY, HGfx.Fonts.Small, self._minTemp, Gfx.TEXT_JUSTIFY_CENTER);
            }
        }

        function OnShow() as Void {
            //get current weather
            var current = Weather.getCurrentConditions();
            if (current != null) {
                var settings = Toybox.System.getDeviceSettings();
                var maxtemp = current.highTemperature != null ? current.highTemperature : null;
                var mintemp = current.lowTemperature != null ? current.lowTemperature : null;
                var ctemp = current.temperature != null ? current.temperature : null;

                var location = current.observationLocationPosition;
                if (location == null) {
                    location = Toybox.Position.getInfo().position;
                }

                var isNight = false;

                if (location != null) {
                    var now = Toybox.Time.now();
                    var sunrise = Weather.getSunrise(location, now);
                    var sunset = Weather.getSunset(location, now);

                    if (sunrise != null && sunset != null) {
                        if (sunrise.greaterThan(now) || sunset.lessThan(now)) {
                            isNight = true;
                        }
                    }
                }

                if (settings.temperatureUnits == Toybox.System.UNIT_STATUTE) {
                    //calc to fahrenheit
                    if (ctemp != null) {
                        ctemp = ctemp.toFloat() * (9.0 / 5.0) + 32.0;
                    }
                    if (mintemp != null) {
                        mintemp = mintemp.toFloat() * (9.0 / 5.0) + 32.0;
                    }
                    if (maxtemp != null) {
                        maxtemp = maxtemp.toFloat() * (9.0 / 5.0) + 32.0;
                    }
                }

                if (ctemp instanceof Number) {
                    self._currentTemp = ctemp.toString() + "°";
                } else if (ctemp instanceof Float || ctemp instanceof Double) {
                    self._currentTemp = ctemp.format("%.0d") + "°";
                }
                else {
                    self._currentTemp = null;
                }

                if (maxtemp instanceof Number) {
                    self._maxTemp = maxtemp.toString() + "°";
                } else if (maxtemp instanceof Float || maxtemp instanceof Double) {
                    self._maxTemp = maxtemp.format("%.0d") + "°";
                }
                else {
                    self._maxTemp = null;
                }

                if (mintemp instanceof Number) {
                    self._minTemp = mintemp.toString() + "°";
                }
                else if (mintemp instanceof Float || mintemp instanceof Double) {
                    self._minTemp = mintemp.format("%.0d") + "°";
                }
                else {
                    self._minTemp = null;
                }

                self._currentWeatherIcon = null;
                var condition = current.condition;
                if (condition != null) {
                    switch (condition) {
                        case Toybox.Weather.CONDITION_CLEAR:
                        case Toybox.Weather.CONDITION_MOSTLY_CLEAR:
                        case Toybox.Weather.CONDITION_FAIR:
                            if (isNight) {
                                self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherClear_Night);
                            } else {
                                self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherClear);
                            }
                            $.Log("WeatherClear");
                            break;
                        case Toybox.Weather.CONDITION_PARTLY_CLOUDY:
                        case Toybox.Weather.CONDITION_PARTLY_CLEAR:
                        case Toybox.Weather.CONDITION_THIN_CLOUDS:
                            if (isNight) {
                                self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherThinClouds_Night);
                            } else {
                                self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherThinClouds);
                            }
                            $.Log("WeatherThinClouds");
                            break;
                        case Toybox.Weather.CONDITION_MOSTLY_CLOUDY:
                            if (isNight) {
                                self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherMostlyCloudy_Night);
                            } else {
                                self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherMostlyCloudy);
                            }
                            $.Log("WeatherMostlyCloudy");
                            break;
                        case Toybox.Weather.CONDITION_CLOUDY:
                        case Toybox.Weather.CONDITION_MOSTLY_CLOUDY:
                            self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherCloudy);
                            $.Log("WeatherCloudy");
                            break;
                        case Toybox.Weather.CONDITION_LIGHT_RAIN:
                        case Toybox.Weather.CONDITION_LIGHT_SHOWERS:
                        case Toybox.Weather.CONDITION_SHOWERS:
                        case Toybox.Weather.CONDITION_CHANCE_OF_SHOWERS:
                            if (isNight) {
                                self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherLightRain_Night);
                            } else {
                                self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherLightRain);
                            }
                            $.Log("WeatherLightRain");
                            break;
                        case Toybox.Weather.CONDITION_RAIN:
                        case Toybox.Weather.CONDITION_SCATTERED_SHOWERS:
                        case Toybox.Weather.CONDITION_DRIZZLE:
                        case Toybox.Weather.CONDITION_CHANCE_OF_RAIN_SNOW:
                        case Toybox.Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN:
                            self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherRain);
                            $.Log("WeatherRain");
                            break;
                        case Toybox.Weather.CONDITION_SNOW:
                        case Toybox.Weather.CONDITION_HAIL:
                        case Toybox.Weather.CONDITION_LIGHT_SNOW:
                        case Toybox.Weather.CONDITION_CHANCE_OF_SNOW:
                        case Toybox.Weather.CONDITION_CLOUDY_CHANCE_OF_SNOW:
                            self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherSnow);
                            $.Log("WeatherSnow");
                            break;
                        case Toybox.Weather.CONDITION_WINDY:
                        case Toybox.Weather.CONDITION_SQUALL:
                            self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherWindy);
                            $.Log("WeatherWindy");
                            break;
                        case Toybox.Weather.CONDITION_THUNDERSTORMS:
                        case Toybox.Weather.CONDITION_SCATTERED_THUNDERSTORMS:
                        case Toybox.Weather.CONDITION_CHANCE_OF_THUNDERSTORMS:
                            self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherThunder);
                            $.Log("WeatherThunder");
                            break;
                        case Toybox.Weather.CONDITION_WINTRY_MIX:
                        case Toybox.Weather.CONDITION_LIGHT_RAIN_SNOW:
                        case Toybox.Weather.CONDITION_HEAVY_RAIN_SNOW:
                        case Toybox.Weather.CONDITION_RAIN_SNOW:
                        case Toybox.Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW:
                        case Toybox.Weather.CONDITION_SLEET:
                            self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherRainSnow);
                            $.Log("WeatherRainSnow");
                            break;
                        case Toybox.Weather.CONDITION_FOG:
                        case Toybox.Weather.CONDITION_HAZY:
                        case Toybox.Weather.CONDITION_MIST:
                        case Toybox.Weather.CONDITION_DUST:
                            self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherFog);
                            $.Log("WeatherFog");
                            break;
                        case Toybox.Weather.CONDITION_HEAVY_RAIN:
                        case Toybox.Weather.CONDITION_HEAVY_SHOWERS:
                            self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherHeavyRain);
                            $.Log("WeatherHeavyRain");
                            break;
                        case Toybox.Weather.CONDITION_HEAVY_SNOW:
                        case Toybox.Weather.CONDITION_ICE:
                        case Toybox.Weather.CONDITION_HAZE:
                        case Toybox.Weather.CONDITION_FREEZING_RAIN:
                        case Toybox.Weather.CONDITION_ICE_SNOW:
                            self._currentWeatherIcon = Application.loadResource(Rez.Drawables.WeatherHeavySnow);
                            $.Log("WeatherHeavySnow");
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
                            $.Log("WeatherExtreme");
                            break;
                        case Toybox.Weather.CONDITION_UNKNOWN_PRECIPITATION:
                        case Toybox.Weather.CONDITION_UNKNOWN:
                        default:
                            $.Log("Weather Unknown");
                            break;
                    }
                }
            } else {
                self._currentTemp = null;
                self._maxTemp = null;
                self._minTemp = null;
                self._currentWeatherIcon = null;
            }
        }

        public function OnSleep() as Void {
            self._currentTemp = null;
            self._maxTemp = null;
            self._minTemp = null;
            self._currentWeatherIcon = null;
        }
    }
}
