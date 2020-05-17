using Toybox.Graphics;
using Toybox.WatchUi;

class MaxgradeRandTrackPicker extends DigitPicker {


    function initialize() {
        DigitPicker.initialize(WatchUi.loadResource(Rez.Strings.maxgrade_rand_track),0,10,1,Properties.maxgrade_rand_track());
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }
}

class MaxgradeRandTrackPickerDelegate extends WatchUi.PickerDelegate {

    function initialize() {
        PickerDelegate.initialize();
    }

    function onCancel() {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }
    
    function onAccept(values) {
    	Properties.storeMaxgrade_rand_track(values[0]);
    	WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }
}