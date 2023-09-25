import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;

class WFApp extends Application.AppBase 
{
    var WatchfaceView = null as WFView;

    function initialize() 
    {
        AppBase.initialize();
        var settings = System.getDeviceSettings() as DeviceSettings;
        IsSmallDisplay = settings.screenWidth < 320;
    }

    function onStart(state as Dictionary?) as Void 
    {
        Themes.ThemesLoader.loadTheme();
        Themes.Colors.ResetColors();
        Math.srand(Time.now().value());
    }

    function getInitialView() as Array<Views or InputDelegates>? 
    {
        self.WatchfaceView = new WFView();
        return [ self.WatchfaceView ] as Array<Views or InputDelegates>;
    }

    function onSettingsChanged() as Void 
    {
        Themes.ThemesLoader.loadTheme();
        Themes.Colors.ResetColors();
        //Font is reloaded in WFView
      
        self.WatchfaceView.onSettingsChanged();
    }
}

function getApp() as WFApp 
{
    return Application.getApp() as WFApp;
}

function getView() as WFView
{
    return getApp().WatchfaceView;
}

var IsSmallDisplay = true;