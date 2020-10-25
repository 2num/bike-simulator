using Toybox.Application;
using Toybox.Lang;
module Properties{

	module Config{
		const TRACKS_KEY = "tracks";
		const DIST_RAND_TRACK_KEY = "dist_rand_track";
		const MAXGRADE_RAND_TRACK_KEY = "maxgrade_rand_track";
	}

	function activeTrack(){
		var value = Application.getApp().getProperty(Config.TRACKS_KEY);
		if(value !=null && value instanceof Lang.Number) {
			return value;
		}else{
			storeActiveTrack(0);
			return 0;
		}
	}
	function storeActiveTrack(activeTrack){
    	Application.getApp().setProperty(Config.TRACKS_KEY, activeTrack);
	}
	
	function dist_rand_track(){
  		var dist_rand_track = Application.getApp().getProperty(Config.DIST_RAND_TRACK_KEY);
		if(dist_rand_track !=null && dist_rand_track instanceof Lang.Number) {
			return dist_rand_track;
		}else{
			storeDist_rand_track(50);
			return 50;
		}
	}
	function storeDist_rand_track(dist_rand_track){
    	Application.getApp().setProperty(Config.DIST_RAND_TRACK_KEY, dist_rand_track);
	}

	function maxgrade_rand_track(){
  		var maxgrade_rand_track = Application.getApp().getProperty(Config.MAXGRADE_RAND_TRACK_KEY);
		if(maxgrade_rand_track !=null && maxgrade_rand_track instanceof Lang.Number) {
			return maxgrade_rand_track;
		}else{
			storeMaxgrade_rand_track(7);
			return 7;
		}
	}
	function storeMaxgrade_rand_track(maxgrade_rand_track){
    	Application.getApp().setProperty(Config.MAXGRADE_RAND_TRACK_KEY, maxgrade_rand_track);
	}
		
	function init(){
		activeTrack();
		dist_rand_track();
		maxgrade_rand_track();
	}
	

}