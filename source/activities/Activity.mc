using SoundAndVibration as SV;
using Toybox.Timer;


module Activity{

	var heartRateActive 	= false;
	var bikeSpeedActive		= false;
	var bikeCadenceActive 	= false;
	var bikePowerActive 	= false;
	
	enum {
		Started,
		Stopped
	}
	
	class Record{
		var session;
	   	var trackField;
	   	var percentageField;
	   	var altitudeField;
	   	
	   	var grade = 0;
	   	
	   	var lapNumber = 0;
	   	var stopTimer = null;
	   	var lastAltitude;
	   	
		private const TRACK_FIELD_ID = 0;
		private const PERCENTAGE_FIELD_ID = 1;
		private const ALTITUDE_FIELD_ID = 2;
		private const ACTIVITY_NANE = "SMART TRAINER BIS";
		
		function initialize(){ 
			Sensor.setEnabledSensors(
	        	[
	        		Sensor.SENSOR_HEARTRATE,
	        		Sensor.SENSOR_BIKESPEED,
	        		Sensor.SENSOR_BIKECADENCE,
	        		Sensor.SENSOR_BIKEPOWER,
	        	]);
	        Sensor.enableSensorEvents(method(:onSensor));
		}
		
		function onSensor(sensorInfo) {
			heartRateActive = sensorInfo.heartRate!=null; 
			bikeSpeedActive = sensorInfo.speed!=null;
			bikeCadenceActive = sensorInfo.cadence!=null;
			bikePowerActive = sensorInfo.power!=null;
		}
		
		function handle(){
			if (Toybox has :ActivityRecording ) {                          // check device for activity recording
		       if (session == null) {
		           	session = ActivityRecording.createSession({          // set up recording session
		                 :name		=> 	ACTIVITY_NANE,                              // set session name
		                 :sport		=> 	ActivityRecording.SPORT_CYCLING,       // set sport type
		                 :subSport	=>	ActivityRecording.SUB_SPORT_INDOOR_CYCLING // set sub sport type
		           	});	
		       		trackField = session.createField("track",TRACK_FIELD_ID,FitContributor.DATA_TYPE_STRING, 
		       				{ :mesgType=>FitContributor.MESG_TYPE_SESSION, :units=>"Track",:count=>32});
		       		percentageField = session.createField("percentage",PERCENTAGE_FIELD_ID,FitContributor.DATA_TYPE_SINT32, 
		       				{ :mesgType=>FitContributor.MESG_TYPE_RECORD, :units=>"%" });
		       		altitudeField = session.createField("altitude",ALTITUDE_FIELD_ID,FitContributor.DATA_TYPE_UINT32, 
		       				{ :mesgType=>FitContributor.MESG_TYPE_RECORD, :units=>"m" });
		          	return startingTimer();
		       }
		       else if (isRecording()) {
		       		return stoppingTimer();
		       }else if(!isRecording() ){ 
		       		return startingTimer();
		       }
		   }
		}
		
		function isRecording(){
			return session!=null && session.isRecording();
		}
		
		function isSessionStart(){
			var start = session!=null;
			return start;
		}
		
		function release(){
			ActivityValues.reset();
	    	if(Sensor has :unregisterSensorDataListener){
				Sensor.unregisterSensorDataListener();
			}
    	}
    	
    	function discard(){
	    	var result = false;
	    	if(session!=null){
	    		session.discard();
	    	}
	    	session = null;
	    	release();
	    	return result;
	    }
    
	    function save(){
			trackField.setData(DataTracks.getActiveTrack().name);
	    	var result = session.save();
	    	session = null;
	    	release();
	    	return result;
	    }
	    
	    function lap(){
	    	if(isSessionStart()){
	    		session.addLap();
	    		var lapValues = ActivityValues.lap();
	    		lapNumber++;
	    		return {
	    					:lapNumber 		=> lapNumber,
	    					:distanceLap 	=> lapValues.get(:distanceLap), 
							:speedLap 		=> lapValues.get(:speedLap)
						};
	    	}else{
	    		return null;
	    	}
	    }
    	
    	function collectData(){
    		if(percentageField!=null){
    			grade = ActivityValues.percentage(0);
				percentageField.setData( grade );
			}
			if(altitudeField!=null){
				altitudeField.setData(ActivityValues.calculateAltitude());
			}
    	}
    	
	    function gettime(){
	    	var time = 0;
	    	if(isSessionStart()){
	    		time = ActivityValues.time();
	    	}
	    	return time;
	    }
	    
		private function startingTimer(){
		    session.start();
		    SV.playStart();
		    return Started;
		}
		
		private function stoppingTimer(){
	       	session.stop();  
	       	SV.playStop(); 
	       	return Stopped;
		}
	}
	
	
}