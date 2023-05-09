import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

class YAWFApp extends Application.AppBase 
{
    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        Application.Properties.setValue("appVersion", "2023.5.9rc3");
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        return [ new YAWFView() ] as Array<Views or InputDelegates>;
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() as Void {
        WatchUi.requestUpdate();
    }
}

function getApp() as YAWFApp 
{
    return Application.getApp() as YAWFApp;
}

function getTheme() as Themes.ThemeSettingsBase
{
    return Themes.ThemesLoader.getTheme();
}

function debug(text) 
{
    Toybox.System.println(text);
}