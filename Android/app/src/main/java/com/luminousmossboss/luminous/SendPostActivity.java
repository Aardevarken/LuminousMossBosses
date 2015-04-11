package com.luminousmossboss.luminous;

/**
 * Created by andrey on 3/9/15.
 */
import android.content.Context;
import android.os.AsyncTask;
import android.provider.Settings;
import android.widget.Toast;

import com.luminousmossboss.luminous.model.Observation;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.impl.client.DefaultHttpClient;

import java.io.File;

public class SendPostActivity extends AsyncTask<Object,Void,Integer>{

    private int observationId;
    private Context context;

    private final String POST_URL = "http://luminousid.com/_post_observation";
    private final int STATUS_OK = 200;


    public SendPostActivity(Context context, int id) {
        this.context = context;
        observationId = id;


    }

    protected void onPreExecute(){

    }
    @Override
    protected Integer doInBackground(Object... arg0) {

        Observation observation= (Observation) arg0[0];
        HttpClient httpclient = new DefaultHttpClient();
        HttpPost httppost = new HttpPost("http://luminousid.com/_post_observation");
        File image = new File(observation.getIcon().getPath());


        try {
            MultipartEntity entity = new MultipartEntity();
            entity.addPart("picture", new FileBody(image));
            entity.addPart("Time", new StringBody(observation.getFullDate().substring(10)));
            entity.addPart("Date", new StringBody(observation.getDate()));
            entity.addPart("Latitude", new StringBody(String.valueOf(observation.getLatitude())));
            entity.addPart("Longitude", new StringBody(String.valueOf(observation.getLongitude())));
            entity.addPart("DeviceId", new StringBody(Settings.Secure.getString(context.getContentResolver(),
                    Settings.Secure.ANDROID_ID)));
            entity.addPart("DeviceType", new StringBody("AndroidPhone"));
            httppost.setEntity(entity);
            HttpResponse response = httpclient.execute(httppost);

            int statusCode =response.getStatusLine().getStatusCode();
            return statusCode;
        } catch (Exception e) {return e.hashCode();}


        }





    @Override
    protected void onPostExecute(Integer result){
        if (result == STATUS_OK){
            Toast.makeText(context,"Your observation was sent! Thanks for contributing to science",Toast.LENGTH_LONG).show();

            DbHandler db = new DbHandler(context);
            db.updateSyncedStatus(observationId);

        }
        else {
            Toast.makeText(context,"There was an issue connecting, please try again with better service",Toast.LENGTH_LONG).show();

        }

    }
}