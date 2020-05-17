using Toybox.Ant;

class FECMessages extends Ant.GenericChannel {

    const MAX_LOW_PRIORITY_SEARCH_30S = 12; // In 2.5s increments, 30s max.
    const MAX_HIGH_PRIORITY_SEARCH_5S = 2; // In 2.5s increments, 5s max.
	const PAGE_TRACK_RESISTANCE = 51; // (0x33) Page number
	const TRACK_SURFACE = 0.004; // Asphalt
	
	hidden var chanAssign;
	
    hidden var _deviceNumber;
    hidden var _open;
    hidden var _connected;

    hidden var _grade = null;
    hidden var _gradeMessage = null;
    hidden var _desiredGrade = null;
	
    function initialize() {

        self._deviceNumber = null;
        self._open = false;
        self._connected = false;
    }

    function connectToDevice( deviceNumber ) {

        if (self._open) {
        
            self.release();
            self._open = false;
            self._grade = null;
            self._desiredGrade = null;
        }

        var chanAssign = new Ant.ChannelAssignment( Ant.CHANNEL_TYPE_RX_NOT_TX,
                                                    Ant.NETWORK_PLUS );
        GenericChannel.initialize( method(:onMessage), chanAssign );

        self._deviceNumber = deviceNumber;

        var deviceConfig = new Ant.DeviceConfig( {
            :deviceNumber => deviceNumber,
            :deviceType => ANTConstants.DEVICE_TYPE,
            :transmissionType => ANTConstants.TRANSMISSION_TYPE,
            :messagePeriod => ANTConstants.PERIOD_4HZ,
            :radioFrequency => ANTConstants.FREQ,
            :searchTimeoutLowPriority => self.MAX_LOW_PRIORITY_SEARCH_30S,
            :searchTimeoutHighPriority => self.MAX_HIGH_PRIORITY_SEARCH_5S
            //:searchThreshold => 0 //Pair to all transmitting sensors
        } );

        GenericChannel.setDeviceConfig( deviceConfig );
        GenericChannel.open();

        self._open = true;
        self._connected = false;

        //System.println( "FEC: Connecting to device: " + deviceNumber.toString() + ", Type: " + ANTConstants.DEVICE_TYPE.toString() );
    }

    function getGrade() {

        return self._grade;
    }

    function isOpen() {

        return self._open;
    }

    function isConnected() {

        return self._connected;
    }

    function disconnect() {

        if ( null != self._desiredGrade ) {
            self._desiredGrade = null;
            //System.println( "FEC: Giving up on setting the grade." );
        }

        self.release();
        self._open = false;
        self._connected = false;
        self._grade = null;

    }
	
    function setGrade( grade ) {
		
        if ( !self._connected || ( null != self._desiredGrade )) {
            //System.println( "FEC: grade command not sent: notconnected, nulldesiredgrade = " + (!self._connected).toString() + "&" + ( null != self._desiredGrade ).toString() );
            return false;
        }
		
		// Conversion grade
		var gradescaled;
		gradescaled = ((grade + 200) * 100).toNumber();
		
        var data = new[8];

        data[0] = PAGE_TRACK_RESISTANCE;
        data[1] = 0xFF;
        data[2] = 0xFF;
        data[3] = 0xFF;
        data[4] = 0xFF;
		data[5] = (gradescaled & 0xFF); //% LSB
		data[6] = (gradescaled >> 8) & 0xFF; //% MSB
		data[7] = ((TRACK_SURFACE * 20000).toNumber() & 0xFF); //track: Wooden(0.001),Smooth(0.002),Asphalt(0.004)default,Rough(0.008)

        self._gradeMessage = new Ant.Message();
        self._gradeMessage.setPayload(data);
 
        self._desiredGrade = grade;

        GenericChannel.sendAcknowledge( self._gradeMessage );
        //System.println( "FEC: grade command sent. Value = " + grade.toString() + ", scaled = " + gradescaled.toString() );

        return true;
    }

    function onMessage( message ) {

        //System.println( "Entering FEC.onMessage..." );

        if( Ant.MSG_ID_BROADCAST_DATA == message.messageId ) {

        	var payload = message.getPayload();

            if ( !self._connected ) {

                self._connected = true;
                //System.println( "FEC: connected." );
            }

        } else if( Ant.MSG_ID_CHANNEL_RESPONSE_EVENT == message.messageId ) {

        	var payload = message.getPayload();

        	if( Ant.MSG_ID_RF_EVENT == (payload[0] & 0xFF) ) {

            	if( Ant.MSG_CODE_EVENT_RX_FAIL_GO_TO_SEARCH == ( payload[1] & 0xFF ) ) {

                    // The device went away.
                    if ( null != self._desiredGrade ) {
                        self._desiredGrade = null;
                    }

	                //System.println( "Lost connection to device. Reconnecting." );
                    connectToDevice( self._deviceNumber );
            	}  else if( Ant.MSG_CODE_EVENT_CHANNEL_CLOSED == ( payload[1] & 0xFF ) ) {

                    if( self._open ) {

                        if ( null != self._desiredGrade ) {
                            self._desiredGrade = null;
                        }

                        //System.println( "Ant.MSG_CODE_EVENT_CHANNEL_CLOSED -- opening again." );
                        connectToDevice ( self._deviceNumber );
                    } else {

                		//System.println( "Ant.MSG_CODE_EVENT_CHANNEL_CLOSED" );
                    }
            	} else if( Ant.MSG_CODE_EVENT_TRANSFER_TX_COMPLETED == ( payload[1] & 0xFF ) ) {

                    //System.println( "FEC: ACK'd message completed." );
                    if ( null != self._desiredGrade ) {

                        self._grade = self._desiredGrade;
                        self._desiredGrade = null;
                    }
                } else if( Ant.MSG_CODE_EVENT_TRANSFER_TX_FAILED == ( payload[1] & 0xFF ) ) {

                    //System.println( "FEC: ACK'd message failed." );
                    if ( null != self._desiredGrade ) {
                        GenericChannel.sendAcknowledge( self._gradeMessage );
                        //System.println( "FEC: Retrying ACK'd grade command." );
                    }
                }
        	}
        }
        //System.println( "Exiting FEC.onMessage..." );
    }
}
