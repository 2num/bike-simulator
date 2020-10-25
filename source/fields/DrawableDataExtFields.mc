using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.System;

class DrawableDataExtFields extends WatchUi.Drawable {

		var title1;
		var title2;
		var title3;
		var title4;
		var title5;
		var title6;
		
		var field1;
		var field2;
		var field3;
		var field4;
		var field5;
		var field6;
		
		var marginTitle;
		var marginNumber;
		
		var titleFont;
		var numberFont;
		
	function initialize(options) {
		Drawable.initialize(options);
        title1 = loadValue(options,:title1,WatchUi.loadResource(Rez.Strings.speed));
        title2 = loadValue(options,:title2,WatchUi.loadResource(Rez.Strings.heartRate));
        title3 = loadValue(options,:title3,WatchUi.loadResource(Rez.Strings.cadence));
        title4 = loadValue(options,:title4,WatchUi.loadResource(Rez.Strings.powerLabel));
        title5 = loadValue(options,:title5,WatchUi.loadResource(Rez.Strings.percentage));
        title6 = loadValue(options,:title6,WatchUi.loadResource(Rez.Strings.nextGrade));
        
        field1 = loadValue(options,:field1,:calculateSpeed);
        field2 = loadValue(options,:field2,:calculateHeartRate);
        field3 = loadValue(options,:field3,:calculateCadence);
        field4 = loadValue(options,:field4,:calculatePower);
        field5 = loadValue(options,:field5,:calculatePercentage);
        field6 = loadValue(options,:field6,:calculateNextGrade);
        
        marginTitle = loadValue(options,:fieldTitleMargin, 0);
        marginNumber = loadValue(options,:fieldNumberMargin, 0);
        
        titleFont = loadValue(options,:titleFont, Graphics.FONT_SYSTEM_TINY);
        numberFont = loadValue(options,:numberFont, Graphics.FONT_NUMBER_MEDIUM);
	}
	
	private function loadValue(options,key,defaultValue){
		var value = options.get(key);
	    return value != null ? value : defaultValue;
	}
	
	function draw(dc) {
		var height = dc.getHeight()/3;
		var width = dc.getWidth()/3;
		
		dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
		dc.clear();

		drawGrid(dc,width,height);
		drawProgressBar(dc,getFill(),width,height,Graphics.COLOR_RED);
		drawProgressBar(dc,getWholeFill(),width,2*height,Graphics.COLOR_BLUE);
		
		drawField(dc,title1,field1,width/2+width/10   ,0 ,width-width/10 , height, true);// left top
		drawField(dc,title6,field6,1.5*width-width/15 ,0 ,width+width/15 , height, true);// right top
		drawField(dc,title2,field2,0	       ,height	 ,width*1.1 , height, false);// left win
		drawField(dc,title5,field5,width*1.1   ,height	 ,width*0.8 , height, false);// middle win
		drawField(dc,title3,field3,2*width*0.95,height	 ,width*1.1 , height, false);// right win
		drawField(dc,title4,field4,0	       ,2*height ,3 * width , height, false);// center bottom

	}
	
	private function drawGrid(dc,width,height){
		dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
		dc.setPenWidth(2);
		dc.drawLine(width*1.5    , 0	    , width*1.5	   , height);//V0
		dc.drawLine(0		     , height	, 3 * width    , height);//H1
		dc.drawLine(0		     , 2*height	, 3 * width	   , 2*height);//H2
		dc.drawLine(width*1.1    , height	, width*1.1	   , 2*height);//V1
		dc.drawLine(2*width*0.95 , height   , 2*width*0.95 , 2*height);//V2
		dc.setPenWidth(1);
	}
	
	private function drawField(dc,name,value,x,y,width,height,swap) {
		var v = new Lang.Method(ActivityValues, value); 
		dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
		var offsetTitle = marginTitle;
		var offsetNum = height - dc.getFontHeight(numberFont) - marginNumber;
		if (swap){
			offsetTitle = height - dc.getFontHeight(titleFont) - marginTitle;
			offsetNum = marginNumber;
		}
		dc.drawText(x + width/2, y + offsetTitle, titleFont, name, Graphics.TEXT_JUSTIFY_CENTER);
		dc.drawText(x + width/2, y + offsetNum, numberFont, v.invoke(), Graphics.TEXT_JUSTIFY_CENTER);
	}
	
	private function drawProgressBar(dc,fill,width,height,color) {
		dc.setColor(color, Graphics.COLOR_BLACK);
		dc.setPenWidth(6);
		dc.drawLine(0, height, 3 * width * fill, height);
		dc.setPenWidth(1);
	}
	
	function getFill(){
		var distance = ActivityValues.distance();
		var fill = distance - distance.toNumber();
		return fill;
	}
	
	function getWholeFill(){
		var distance = ActivityValues.distance();
		var totalDistance = DataTracks.getActiveTrack().profile.size();
		var fill = 0;
		if ( totalDistance != 0 ) {
			fill = distance/totalDistance;
		}
		return fill;
	}
}