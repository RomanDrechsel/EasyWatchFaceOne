import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Widgets.Indicators as Indi;

class WFView extends WatchUi.WatchFace 
{
    var OnShow = [];
    var OnSleep = [];
    var OneTimePerTick = null;

    var IsBackground = false;
    var fontupdate = null;

    function initialize() 
    {
        WatchFace.initialize();
    }

    function onLayout(dc as Dc) as Void 
    {
        self.setLayout(Rez.Layouts.WatchFace(dc));
        self.IsBackground = false;
    }

    function onUpdate(dc as Dc) as Void 
    {
        /*if (!IsSmallDisplay && Debug has :GetCodepoints)
        {
            (new Debug.GetCodepoints()).GetFontCodePoints();
        }*/

        if (self.OneTimePerTick != null)
        {
            if (self.OneTimePerTick.size() > 0)
            {
                if (self.OneTimePerTick[0] instanceof Number)
                {
                    //wait for x ticks
                    self.OneTimePerTick[0]--;
                    if (self.OneTimePerTick[0] <= 0)
                    {
                        self.OneTimePerTick.remove(self.OneTimePerTick[0]);
                    }
                }
                else 
                {
                    self.OneTimePerTick[0].invoke(null);
                    self.OneTimePerTick.remove(self.OneTimePerTick[0]);
                }
                if (self.OneTimePerTick.size() == 0)
                {
                    self.OneTimePerTick = null;
                }
            }
        }
        
        View.onUpdate(dc);
    }

    function onExitSleep() as Void 
    {
        self.IsBackground = false;
        for (var i = 0; i < self.OnShow.size(); i++)
        {
            self.OnShow[i].OnShow();
        }
    }

    function onEnterSleep() as Void 
    {
        self.IsBackground = true;
        for (var i = 0; i < self.OnSleep.size(); i++)
        {
            self.OnSleep[i].OnSleep();
        }
    }

    function onSettingsChanged()
    {
        self.OnShow = [];
        self.OnSleep = [];
        var ids = ["BG", "C", "UC", "DTL", "TL", "TC", "TR", "DTR", "BL", "BR"];
        for (var i = 0; i < ids.size(); i++)
        {
            var drawable = View.findDrawableById(ids[i]);
            if (drawable != null)
            {
                drawable.Init();
            }
        }
    }
}