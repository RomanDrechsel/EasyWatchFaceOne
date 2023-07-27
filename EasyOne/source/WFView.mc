import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class WFView extends WatchUi.WatchFace 
{
    var OnWakeUp = [] as Array<Method>;
    var OnSleep = [] as Array<Method>;
    var OnUpdate = [] as Array<Method>;

    function initialize() 
    {
        WatchFace.initialize();
        $.getApp().OnSettings.add(self.method(:onSettingsChanged));
    }

    function onLayout(dc as Dc) as Void 
    {
        Helper.Gfx.Fonts.Load();
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    function onUpdate(dc as Dc) as Void 
    {
        View.onUpdate(dc);
        if (self.OnUpdate.size() > 0)
        {
            for (var i = 0; i < self.OnUpdate.size(); i++)
            {
                self.OnUpdate[i].invoke();
            }
        }
    }

    function onExitSleep() as Void 
    {
        if (self.OnWakeUp.size() > 0)
        {
            for (var i = 0; i < self.OnWakeUp.size(); i++)
            {
                self.OnWakeUp[i].invoke();
            }
        }
    }

    function onEnterSleep() as Void 
    {
        if (self.OnSleep.size() > 0)
        {
            for (var i = 0; i < self.OnSleep.size(); i++)
            {
                self.OnSleep[i].invoke();
            }
        }
    }

    function onSettingsChanged()
    {
        self.OnWakeUp = [] as Array<Method>;
        self.OnSleep = [] as Array<Method>;
        self.OnUpdate = [] as Array<Method>;
    }
}
