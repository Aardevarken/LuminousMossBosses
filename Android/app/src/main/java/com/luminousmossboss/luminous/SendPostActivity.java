package com.luminousmossboss.luminous;

/**
 * Created by andrey on 3/9/15.
 */
import java.io.File;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;

import android.content.Context;
import android.os.AsyncTask;
import android.provider.Settings;
import android.widget.TextView;

import com.luminousmossboss.luminous.model.Observation;

public class SendPostActivity extends AsyncTask<Object,Void,String>{

    private TextView responseField;
    private Context context;

    private final String POST_URL = "http://luminousid.com/_post_observation";
    private final String SUCCESS = "Success";


    public SendPostActivity(Context context) {
        this.context = context;



    }

    protected void onPreExecute(){

    }
    @Override
    protected String doInBackground(Object... arg0) {

        Observation observation= (Observation) arg0[0];
        HttpClient httpclient = new DefaultHttpClient();
        HttpPost httppost = new HttpPost("http://luminousid.com:5003/_post_observation");
        File image = new File(observation.getIcon().getPath());


        try {
            MultipartEntity entity = new MultipartEntity();

            entity.addPart("Picture", new StringBody("photo"));
            entity.addPart("picture", new FileBody(image));
            entity.addPart("Time", new StringBody(observation.getFullData().substring(10)));
            entity.addPart("Date", new StringBody(observation.getDate()));
            entity.addPart("Latitude", new StringBody(String.valueOf(observation.getLatitude())));
            entity.addPart("Longitude", new StringBody(String.valueOf(observation.getLongitude())));
            entity.addPart("DeviceId", new StringBody(Settings.Secure.getString(context.getContentResolver(),
                    Settings.Secure.ANDROID_ID)));
            entity.addPart("DeviceType", new StringBody("Android"));
            httppost.setEntity(entity);
            HttpResponse response = httpclient.execute(httppost);
        } catch (Exception e) {return e.getMessage();

        }
        return SUCCESS;




    }
    @Override
    protected void onPostExecute(String result){

    }
}