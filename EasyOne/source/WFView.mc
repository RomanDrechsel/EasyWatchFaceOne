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

    var IsBackground = false;
    private var _reloadFontInTicks = -1;

    function initialize() 
    {
        WatchFace.initialize();
    }

    function onLayout(dc as Dc) as Void 
    {
        Helper.Gfx.Fonts.Load();
        setLayout(Rez.Layouts.WatchFace(dc));
        self.IsBackground = false;
    }

    function onUpdate(dc as Dc) as Void 
    {
        if (Helper.Gfx has :GetFontCodePoints)
        {
            Helper.Gfx.GetFontCodePoints();
        }
        
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
