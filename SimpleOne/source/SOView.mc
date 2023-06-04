import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class SOView extends WatchUi.WatchFace 
{
    var OnWakeUp = [] as Array<Method>;
    var OnSleep = [] as Array<Method>;
    var OnUpdate = [] as Array<Method>;

    function initialize() 
    {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void 
    {
        Helper.Gfx.Fonts.Load();
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void 
    {
        
    }

    // Update the view
    function onUpdate(dc as Dc) as Void 
    {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        if (self.OnUpdate.size() > 0)
        {
            for (var i = 0; i < self.OnUpdate.size(); i++)
            {
                self.OnUpdate[i].invoke();
            }
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void 
    {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
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

    // Terminate any active timers and prepare for slow updates.
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
}
