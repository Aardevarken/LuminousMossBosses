package com.luminousmossboss.luminous.model;

import android.content.Context;
import android.database.Cursor;
import android.location.Location;
import android.net.Uri;

import com.luminousmossboss.luminous.DbHandler;

import java.io.File;
import java.io.Serializable;
import java.lang.reflect.Array;

/**
 * Created by Andrey on 2/1/2015.
 */

public class Observation extends ListItem implements Serializable {

    private String date;
    private boolean syncedStatus;
    private double longitude;
    private double latitude;
    private boolean hasBeenProcceced;
    private boolean is_silene;
    private int id;
    private float accuracy;



    public Observation() {}

    public Observation(String title, Uri icon) {
        super(title, icon);
    }

    public Observation(String title, Uri icon, String date , double latitude, double longitude) {
        super(title, icon);
        this.date = date;
        this.latitude = latitude;
        this.longitude = longitude;

    }
    public Observation(int id, Context context)
    {
        this.id = id;
        DbHandler db =  new DbHandler(context);
        Cursor cursor = db.getObservationById(id);
        if(cursor.moveToFirst()) {
             setIcon(Uri.fromFile(new File(cursor.getString(cursor.getColumnIndex(DbHandler.KEY_PHOTO_PATH)))));
            setDate(cursor.getString(cursor.getColumnIndex(DbHandler.KEY_TIME_TAKEN)));
            accuracy =cursor.getFloat(cursor.getColumnIndex(DbHandler.KEY_GPS_ACCURACY));
            latitude = cursor.getDouble(cursor.getColumnIndex(DbHandler.KEY_LATITUDE));
            longitude = cursor.getDouble(cursor.getColumnIndex(DbHandler.KEY_LONGITUDE));

            is_silene = cursor.getInt(cursor.getColumnIndex(DbHandler.KEY_IS_SILENE)) > 0;

            if (is_silene)
                setTitle("Silene Aculis");
            else
                setTitle("Unknown");
        }
    }
    public void updateIsSilene(boolean status, Context context)
    {
        DbHandler db = new DbHandler(context);
        db.updateIsSilene(id, status);
        if(status)
        {
            setTitle("Silene Aculis");
        }
        else setTitle("Unknown");
    }
    public float getAccuracy() {
        return accuracy;
    }

    public int getId() {
        return id;
    }
    public String getDate() { return date.substring(0,10);}

    public String getFullDate() { return this.date;}

    public void setDate(String date){
        this.date = date;
    }

    //west east
    public double getLongitude() {
        return longitude;
    }

    public String getLongitudeFormated() {
        String str = Location.convert(longitude, Location.FORMAT_MINUTES);
        String end = (longitude >= 0.0)? "E" : "W";
        return str + end;
    }
    public String getLatitudeFormated() {
        String str = Location.convert(latitude, Location.FORMAT_MINUTES);
        String end = (latitude >= 0.0)? "N" : "S";
        return str + end;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

}
