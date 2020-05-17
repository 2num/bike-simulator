using Toybox.Application;
using Toybox.Lang;
module Properties{

	module Config{

		const GEARS_KEY = "gears";
		const POWER_KEY = "power";
		const TRACKS_KEY = "tracks";
		const LEVEL_KEY = "level";
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
	
	function gears(){
		var gears = Application.getApp().getProperty(Config.GEARS_KEY);
		if(gears !=null && gears instanceof Lang.Number) {
			return gears;
		}else{
			storeGears(8);
			return 8;
		}
	}
	function storeGears(gears){
    	Application.getApp().setProperty(Config.GEARS_KEY, gears);
	}
	
	function power(){
  		var power = Application.getApp().getProperty(Config.POWER_KEY);
		if(power !=null && power instanceof Lang.Number) {
			return power;
		}else{
			storePower(10);
			return 10;
		}
	}
	function storePower(power){
    	Application.getApp().setProperty(Config.POWER_KEY, power);
	}
	
	function level(){
  		var level = Application.getApp().getProperty(Config.LEVEL_KEY);
		if(level !=null && level instanceof Lang.Number) {
			return level;
		}else{
			storeLevel(5);
			return 5;
		}
	}
	function storeLevel(level){
    	Application.getApp().setProperty(Config.LEVEL_KEY, level);
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
		gears();
		power();
		level();
		dist_rand_track();
		maxgrade_rand_track();
	}
	

}