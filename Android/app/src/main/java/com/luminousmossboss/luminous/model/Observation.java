package com.luminousmossboss.luminous.model;

import android.location.Location;
import android.net.Uri;

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
