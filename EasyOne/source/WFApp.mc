import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

class WFApp extends Application.AppBase 
{
    var WatchfaceView = null as WFView;

    var OnSettings = [] as Array<Method>;

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
        self.WatchfaceView = new WFView();
        return [ self.WatchfaceView ] as Array<Views or InputDelegates>;
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() as Void {
        Themes.ThemesLoader.ResetTheme();
        
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

function debug(text) 
{
    Toybox.System.println(text);
}