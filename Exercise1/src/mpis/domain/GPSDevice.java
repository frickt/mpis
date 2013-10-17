package mpis.domain;

import java.util.Observable;
import java.util.Random;

public class GPSDevice extends Observable implements Runnable{

    boolean isRunning = true;
    private long period = 0;
    private long delay = 10000;

	public GPSDevice(){
		
	}
	
	public void start(){
		isRunning = true;
		run();
	}
	
	public void stop(){
		isRunning = false;
		
	}
	
	
	
	public GPSPosition getCurrentPosition(){
		int rangeMin = 0;
		int rangeMax = 100;
		Random r = new Random();
		double randomValue = rangeMin + (rangeMax - rangeMin) * r.nextDouble();
		return new GPSPosition(randomValue, randomValue, 1);
	}

	@Override
	public void run() {
		System.out.println("started");

			while (isRunning && (period == 0 || period > System.currentTimeMillis())) {
                setChanged();
                notifyObservers(getCurrentPosition());
                try {
					Thread.sleep(delay);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
            }
        
	}

	public long getPeriod() {
		return period;
	}

	public void setPeriod(long period) {
		this.period = period  + System.currentTimeMillis();
	}

	public long getDelay() {
		return delay;
	}

	public void setDelay(long delay) {
		
		this.delay = delay;
	}
}
