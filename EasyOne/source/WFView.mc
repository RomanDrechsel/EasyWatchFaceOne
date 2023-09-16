import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Widgets.Indicators as Indi;

class WFView extends WatchUi.WatchFace 
{
    var OnWakeUp = [];

    private var _isBackground = false;
    private var _reloadFontInTicks = -1;

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
        if (self._reloadFontInTicks > 0)
        {
            self._reloadFontInTicks--;

            if (self._reloadFontInTicks == 1)
            {
                Helper.Gfx.Fonts.LoadTimeFont();
            }
            else if (self._reloadFontInTicks == 0)
            {
                Helper.Gfx.Fonts.LoadDateFont();
            }
        }
        
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

        if (IsSmallDisplay)
        {
            //loading font all in one exeeded memory limit!
            self._reloadFontInTicks = 3;
            Helper.Gfx.Fonts.ResetTimeFonts();
        }
        else
        {
            Helper.Gfx.Fonts.Load();
        }
    }
}
