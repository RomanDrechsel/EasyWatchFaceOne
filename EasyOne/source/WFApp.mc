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
        $.Log("WFApp:OnStart()");
        Themes.ThemesLoader.loadTheme();
        Themes.Colors.ResetColors();
        Helper.Gfx.Fonts.Load(false);
    }

    function getInitialView() as Array<Views or InputDelegates>? {
        self.WatchfaceView = new WFView();
        return [self.WatchfaceView] as Array<Views or InputDelegates>;
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
    var app = Application.getApp() as WFApp;
    if (app != null) {
        return app.WatchfaceView;
    } else {
        return null;
    }
}

function Log(obj as String) {
    var info = Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    var str = info.year + "-" + info.month.format("%02d") + "-" + info.day.format("%02d") + "T" + info.hour.format("%02d") + ":" + info.min.format("%02d") + ":" + info.sec.format("%02d");
    Toybox.System.println(str + ": " + obj);
}

var IsSmallDisplay = true;
