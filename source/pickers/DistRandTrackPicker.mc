using Toybox.Graphics;
using Toybox.WatchUi;

class DistRandTrackPicker extends DigitPicker {


    function initialize() {
        DigitPicker.initialize(WatchUi.loadResource(Rez.Strings.dist_rand_track),0,100,1,Properties.dist_rand_track());
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }
}

class DistRandTrackPickerDelegate extends WatchUi.PickerDelegate {

    function initialize() {
        PickerDelegate.initialize();
    }

    function onCancel() {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }
    
    function onAccept(values) {
    	Properties.storeDist_rand_track(values[0]);
    	WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }
}