package com.luminousmossboss.luminous.model;

import android.content.Context;
import android.database.Cursor;
import android.location.Location;
import android.net.Uri;

import com.luminousmossboss.luminous.ObservationDBHandler;
import com.luminousmossboss.luminous.R;

import java.io.File;
import java.io.Serializable;

/**
 * Created by Andrey on 2/1/2015.
 */

public class Observation extends ListItem implements Serializable {

    private String date;
    private boolean syncedStatus;
    private double longitude;
    private double latitude;
    private boolean hasBeenProcceced;

    private boolean isSent;



    private boolean is_silene;
    private boolean isBeingProcessed;
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
        ObservationDBHandler db =  new ObservationDBHandler(context);
        Cursor cursor = db.getObservationById(id);
        if(cursor.moveToFirst()) {



            setIcon(Uri.fromFile(new File(cursor.getString(cursor.getColumnIndex(ObservationDBHandler.KEY_PHOTO_PATH)))));
            setDate(cursor.getString(cursor.getColumnIndex(ObservationDBHandler.KEY_TIME_TAKEN)));
            accuracy =cursor.getFloat(cursor.getColumnIndex(ObservationDBHandler.KEY_GPS_ACCURACY));

            latitude = cursor.getDouble(cursor.getColumnIndex(ObservationDBHandler.KEY_LATITUDE));
            longitude = cursor.getDouble(cursor.getColumnIndex(ObservationDBHandler.KEY_LONGITUDE));


            is_silene = cursor.getInt(cursor.getColumnIndex(ObservationDBHandler.KEY_IS_SILENE)) > 0;

            if (is_silene)
                setTitle(context.getString(R.string.silene_acaulis));
            else
                setTitle(context.getString(R.string.unknown_species));
        }
        cursor.close();
        db.close();
    }

    public boolean isBeingProcessed() {
        return isBeingProcessed;
    }

    public void setBeingProcessed(boolean isBeingProcessed) {
        this.isBeingProcessed = isBeingProcessed;
    }

    public boolean isHasBeenProcceced() {
        return hasBeenProcceced;
    }

    public void setHasBeenProcceced() {
        this.hasBeenProcceced = hasBeenProcceced;
    }

    public void updateIsSilene(Context context)
    {
        ObservationDBHandler db = new ObservationDBHandler(context);
        db.updateIsSilene(id);
        setTitle(context.getString(R.string.silene_acaulis));

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

    public boolean isSilene() { return is_silene; }

    public boolean isSent() {
        return isSent;
    }

    public void setSent(boolean sent) {
        isSent = sent;
    }

}
