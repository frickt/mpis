package mpis.domain;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.Observable;
import java.util.Observer;

import mpis.database.StorageManager;


public class MovingObject implements Observer{

	String id;
	GPSDevice gpsDevice = null;
	Collection<GPSPosition> gpsPositions;
	Thread gpsDeviceThread = null;

	public MovingObject(String id) {
		super();
		this.id = id;
		gpsPositions = new ArrayList<>();
	}
	
	public String getID(){
		return id;
	}
	
	public void setPosition(GPSPosition gpsPosition){
		gpsPositions.add(gpsPosition);
		System.out.println(gpsPosition.toString());
	}
	
	public void setGpsDevice(GPSDevice gpsDevice){
		this.gpsDevice = gpsDevice;
		gpsDevice.addObserver(this);
		
	}
	
	public void start(long delay, long period){
		if(gpsDevice != null){
			gpsDevice.setDelay(delay);
			gpsDevice.setPeriod(period);
			gpsDeviceThread = new Thread(gpsDevice);
			gpsDeviceThread.start();
			
		}
	}
	
	public void stop(){
		gpsDevice.stop();
		gpsDeviceThread.interrupt();
		
	}
	
	public GPSPosition getPosition(Date date){
		return null;
	}
	
	public Date getDate(GPSPosition gpsPosition){
		return null;
	}

	@Override
	public void update(Observable o, Object arg) {
		setPosition((GPSPosition)arg);
	}

	public void waitForDevice() throws InterruptedException {
		gpsDeviceThread.join();
	}
	
	

}
