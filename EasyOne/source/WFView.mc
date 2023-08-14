import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Widgets.Indicators as Indi;

class WFView extends WatchUi.WatchFace 
{
    private var _isBackground = false;
    var OnWakeUp = [];

    function initialize() 
    {
        WatchFace.initialize();
    }

    function onLayout(dc as Dc) as Void 
    {
        Helper.Gfx.Fonts.Load();
        setLayout(Rez.Layouts.WatchFace(dc));
        self._isBackground = false;
    }

    function onUpdate(dc as Dc) as Void 
    {
        View.onUpdate(dc);
        if (self._isBackground == true)
        {
            Indi.Breath.getBreath();
        }
    }

    function onExitSleep() as Void 
    {
        self._isBackground = false;
        if (self.OnWakeUp.size() > 0)
        {
            for (var i = 0; i < self.OnWakeUp.size(); i++)
            {
                self.OnWakeUp[i].OnWakeUp();
            }
        }
    }

    function onEnterSleep() as Void 
    {
        self._isBackground = true;
    }

    function onSettingsChanged()
    {
        self.OnWakeUp = [] as Array<Method>;
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
