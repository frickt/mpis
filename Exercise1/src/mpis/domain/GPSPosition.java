package mpis.domain;

import java.util.Date;

public class GPSPosition {

	private double latitude;
	private double longitude;
	private double altitude;
	private Date positionDate;
	
	
	
	public GPSPosition(double latitude, double longitude, double altitude) {
		super();
		this.latitude = latitude;
		this.longitude = longitude;
		this.altitude = altitude;
		this.positionDate = new Date();
	}

	public double getAltitude() {
		return altitude;
	}

	public double getLongitude() {
		return longitude;
	}

	public double getLatitude() {
		return latitude;
	}
	
	public Date getPositionDate(){
		return positionDate;
	}
	
	@Override
	public String toString() {
		return "Position: longitude: " + longitude + ", latitude: " +latitude + ", altitude: " + altitude;
	}

}
