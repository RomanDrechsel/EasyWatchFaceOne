import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;

class WFApp extends Application.AppBase 
{
    var WatchfaceView = null as WFView;
    var OnSettings = [] as Array<Method>;

    function initialize() 
    {
        AppBase.initialize();
        var settings = System.getDeviceSettings() as DeviceSettings;
        IsSmallDisplay = settings.screenWidth < 320;
    }

    function onStart(state as Dictionary?) as Void 
    {
        Themes.Colors.ResetColors();
    }

    function getInitialView() as Array<Views or InputDelegates>? {
        self.WatchfaceView = new WFView();
        return [ self.WatchfaceView ] as Array<Views or InputDelegates>;
    }

    function onSettingsChanged() as Void {
        Themes.ThemesLoader.ResetTheme();
        Themes.Colors.ResetColors();
        
        if (self.OnSettings.size() > 0)
        {
            for (var i = 0; i < self.OnSettings.size(); i++)
            {
                self.OnSettings[i].invoke();
            }
        }

        WatchUi.requestUpdate();
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

function getTheme() as Themes.ThemeSettingsBase
{
    return Themes.ThemesLoader.getTheme();
}

var IsSmallDisplay = true;