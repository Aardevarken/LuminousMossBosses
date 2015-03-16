package com.luminousmossboss.luminous;

/**
 * Created by andrey on 3/9/15.
 */
import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONTokener;

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

            BufferedReader reader = new BufferedReader(new InputStreamReader(response.getEntity().getContent(), "UTF-8"));
            String json = reader.readLine();
            JSONTokener tokener = new JSONTokener(json);
            JSONArray finalResult = new JSONArray(tokener);

            return finalResult.toString();
        } catch (Exception e) {return e.getMessage();


        }




    }
    @Override
    protected void onPostExecute(String result){

    }
}