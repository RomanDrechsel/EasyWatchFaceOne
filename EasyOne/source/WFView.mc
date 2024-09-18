import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Widgets.Indicators as Indi;

class WFView extends WatchUi.WatchFace {
    var OnShow as Array<Object> = [];
    var OnSleep as Array<Object> = [];
    var OneTimePerTick as Array<Number or Method>? = null;
    var IsBackground = false;

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc as Dc) as Void {
        self.setLayout(Rez.Layouts.WatchFace(dc));
        self.IsBackground = false;
    }

    function onUpdate(dc as Dc) as Void {
        if (self.OneTimePerTick != null && self.OneTimePerTick.size() > 0) {
            var remove = true;
            if (self.OneTimePerTick[0] instanceof Number) {
                //wait for x ticks
                self.OneTimePerTick[0]--;
                if (self.OneTimePerTick[0] > 0) {
                    remove = false;
                }
            } else if (self.OneTimePerTick[0] instanceof Method) {
                try {
                    self.OneTimePerTick[0].invoke(null);
                } catch (ex instanceof Lang.Exception) {
                    $.Log("Could not invoke OneTimePerTick Method");
                }
            }

            if (remove == true) {
                self.OneTimePerTick.remove(self.OneTimePerTick[0]);
            }

            if (self.OneTimePerTick.size() == 0) {
                self.OneTimePerTick = null;
            }
        }
        try {
            View.onUpdate(dc);
        } catch (ex instanceof Lang.Exception) {
            $.Log("Exception in onUpdate(): " + ex.getErrorMessage());
        }
    }

    function onExitSleep() as Void {
        self.IsBackground = false;
        for (var i = 0; i < self.OnShow.size(); i++) {
            if (self.OnShow[i] != null && self.OnShow[i] has :OnShow) {
                try {
                    self.OnShow[i].OnShow();
                } catch (ex instanceof Lang.Exception) {
                    $.Log("Could not invole OnShow Method: " + ex.getErrorMessage());
                }
            }
        }
    }

    function onEnterSleep() as Void {
        self.IsBackground = true;
        for (var i = 0; i < self.OnSleep.size(); i++) {
            if (self.OnSleep[i] != null && self.OnSleep[i] has :OnSleep) {
                try {
                    self.OnSleep[i].OnSleep();
                } catch (ex instanceof Lang.Exception) {
                    $.Log("Could not invole OnSleep Method: " + ex.getErrorMessage());
                }
            }
        }
    }

    function onSettingsChanged() {
        self.OnShow = [];
        self.OnSleep = [];
        var ids = ["BG", "C", "UC", "DTL", "TL", "TC", "TR", "DTR", "BL", "BR"];
        for (var i = 0; i < ids.size(); i++) {
            var drawable = View.findDrawableById(ids[i]);
            if (drawable != null && drawable has :Init) {
                try {
                    drawable.Init();
                } catch (ex instanceof Lang.Exception) {
                    $.Log("Drawable " + ids[i] + " init failed: " + ex.getErrorMessage());
                }
            }
        }
    }
}
