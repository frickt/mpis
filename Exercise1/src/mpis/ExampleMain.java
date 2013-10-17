/*
 * @(#)ExampleMain.java   1.0   Oct 1, 2013
 *
 * Copyright 2000-2013 ETH Zurich. All Rights Reserved.
 *
 * This software is the proprietary information of ETH Zurich.
 * Use is subject to license terms.
 *
 * @(#) $Id$
 */
package mpis;

import mpis.database.StorageManager;
import mpis.domain.DB4MovingObjects;
import mpis.domain.GPSDevice;
import mpis.domain.MovingObject;

public class ExampleMain {

	public static void main(final String[] args) {

		/*
		 * Create a StorageManager instance here and use it to store and update
		 * some moving objects. Then perform some queries to validate your
		 * implementation of the time and space interpolation methods.
		 */

		DB4MovingObjects db = new DB4MovingObjects();

		MovingObject movingObject = db.createObject("Ufo");

		GPSDevice device = new GPSDevice();
		movingObject.setGpsDevice(device);
		movingObject.start(500, 1000);

		try {
			movingObject.waitForDevice();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		db.commit();
		
		MovingObject retrievedObject = db.getObject("Ufo");		
		retrievedObject.start(200, 1000);
		
		db.commit();
		
		db.destroy();
	}

}
