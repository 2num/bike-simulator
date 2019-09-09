using Toybox.Lang;
using Toybox.Activity;
using Toybox.System;

module ActivityValues {

	var activityTime = new ActivityTime(0,0,0);
	var activityDistance = 0;
	var activitySpeed = 0;
	
	class ActivityTime {
	
		var hours;
		var minutes;
		var seconds;
		
		function initialize(hours_, minutes_, seconds_){
			hours = hours_;
			minutes = minutes_;
			seconds = seconds_;
		}
		
	}
	
	function formatTime(){
		return activityTime.hours.format("%02d")+":"+
		activityTime.minutes.format("%02d")+
		":"+activityTime.seconds.format("%02d");
	}
	
	function formatDistance(){
		return  Lang.format( "$1$ Kms",
    		[
        		activityDistance.format("%02.2f")
    		]
		);
	}
	
	function formatSpeed(){
		return Lang.format( "$1$ Kms/h",
    		[
        		activitySpeed.format("%02d")
    		]
		);
	}
	
	function toHMS(secs) {
		var hr = secs/3600;
		var min = (secs-(hr*3600))/60;
		var sec = secs%60;
		return new ActivityTime(hr,min,sec);
	}
	
	function calculateTime(){
    	var milis = Activity.getActivityInfo().timerTime;
    	System.println("Timer:"+milis);
		activityTime = ActivityValues.toHMS(milis/1000);
    }
    
    function calculateDistance(){
    	var distance = Activity.getActivityInfo().elapsedDistance;
    	if(distance == null || distance<0){ 
    		distance = 0;
    	}
    	System.println("Distance:"+distance);
    	activityDistance = distance/1000;
    }
    
    function calculateSpeed(){
    	var speed = Activity.getActivityInfo().currentSpeed;
    	if(speed == null || speed < 0) {
    		speed = 0;
    	}
    	System.println("Speed:"+speed);
    	activitySpeed = (3600*speed)/1000;
    }
    
    function calculateValues(){
        calculateTime();
		calculateDistance();
	    calculateSpeed();
    }
    
    function cleanValues(){
	    activityTime = new ActivityTime(0,0,0);
		activityDistance = 0;
		activitySpeed = 0;
    
    }
}





