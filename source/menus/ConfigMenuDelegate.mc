using Toybox.WatchUi;
using Toybox.System;

class ConfigMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
		if (item == :dist_rand_track) {
            WatchUi.pushView(new DistRandTrackPicker(), new DistRandTrackPickerDelegate(), WatchUi.SLIDE_IMMEDIATE);
        }else if (item == :maxgrade_rand_track) {
            WatchUi.pushView(new MaxgradeRandTrackPicker(), new MaxgradeRandTrackPickerDelegate(), WatchUi.SLIDE_IMMEDIATE);
        }
    }
}
