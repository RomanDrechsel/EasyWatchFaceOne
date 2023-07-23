import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;

class WFApp extends Application.AppBase 
{
    var WatchfaceView = null as WFView;
    var OnSettings = [] as Array<Method>;

    var ScreenWidth = 240;
    var ScreenHeight = 240;

    function initialize() 
    {
        AppBase.initialize();

        var settings = System.getDeviceSettings() as DeviceSettings;
        self.ScreenWidth = settings.screenWidth;
        self.ScreenHeight = settings.screenHeight;
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void 
    {
        Themes.Colors.ResetColors();
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        self.WatchfaceView = new WFView();
        return [ self.WatchfaceView ] as Array<Views or InputDelegates>;
    }

    // New app settings have been received so trigger a UI update
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

function IsSmallDisplay() as Boolean
{
    return getApp().ScreenWidth <= 240;
}

function getScreenWidth() as Number
{
    return getApp().ScreenWidth;
}

function getScreenHeight() as Number
{
    return getApp().ScreenHeight;
}