import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

class SOApp extends Application.AppBase 
{
    var WatchfaceView = null as SOView;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {

    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        self.WatchfaceView = new SOView();
        return [ self.WatchfaceView ] as Array<Views or InputDelegates>;
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() as Void {
        WatchUi.requestUpdate();
    }
}

function getApp() as SOApp 
{
    return Application.getApp() as SOApp;
}

function getView() as SOView
{
    return getApp().WatchfaceView;
}

function getTheme() as Themes.ThemeSettingsBase
{
    return Themes.ThemesLoader.getTheme();
}

function debug(text) 
{
    Toybox.System.println(text);
}