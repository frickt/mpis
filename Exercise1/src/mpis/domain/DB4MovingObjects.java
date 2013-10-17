package mpis.domain;

import java.util.Collection;

import mpis.database.StorageManager;

public class DB4MovingObjects {

	StorageManager manager = new StorageManager();

	public DB4MovingObjects() {
		super();
		manager.openDB();
	}

	public void close() {
		manager.closeDB();
	}

	public void commit() {
		manager.commit();
	}

	public void rollback() {
		manager.rollback();
	}
	
	public void destroy(){
		manager.deleteDB();
	}

	public MovingObject createObject(String id){
		MovingObject movingObject = new MovingObject(id);
		manager.store(movingObject);
		return movingObject;
	}
	
	public MovingObject getObject(String id){
		MovingObject prototype = new MovingObject(id);
		return manager.retrieve(prototype);
	}
	
	public Collection<MovingObject> getObjects(){
		return manager.retrieveAll();
	}
	
	public void deleteObject(MovingObject movingObject){
		manager.delete(movingObject);
	}
}
