import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Time;

class WFApp extends Application.AppBase {
    var WatchfaceView as WFView? = null;

    function initialize() {
        AppBase.initialize();
        var settings = System.getDeviceSettings();
        $.IsSmallDisplay = settings.screenWidth < 320;
        $.Log("Initialize app: " + settings.screenWidth + "x" + settings.screenHeight);
    }

    function onStart(state as Dictionary?) as Void {
        Themes.ThemesLoader.loadTheme();
        Themes.Colors.ResetColors();
        Helper.Gfx.Fonts.Load(false);
    }

    function getInitialView() as [WatchUi.Views] or [WatchUi.Views, WatchUi.InputDelegates] {
        self.WatchfaceView = new WFView();
        return [self.WatchfaceView];
    }

    function onSettingsChanged() as Void {
        $.Log("Settings changed, reloading view");
        Themes.ThemesLoader.loadTheme();
        Themes.Colors.ResetColors();
        Helper.Gfx.Fonts.Load(IsSmallDisplay);
        self.WatchfaceView.onSettingsChanged();
    }
}

function getView() as WFView? {
    return (Application.getApp() as WFApp).WatchfaceView;
}

function Log(obj as String) as Void {
    var info = Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    var str = info.year + "-" + info.month.format("%02d") + "-" + info.day.format("%02d") + "T" + info.hour.format("%02d") + ":" + info.min.format("%02d") + ":" + info.sec.format("%02d");
    Toybox.System.println(str + ": " + obj);
}

var IsSmallDisplay = true;
