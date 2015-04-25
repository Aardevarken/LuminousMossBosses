package com.luminousmossboss.luminous;

import android.app.Fragment;
import android.app.FragmentManager;
import android.content.Context;
import android.os.AsyncTask;
import android.widget.Toast;

import com.luminousmossboss.luminous.model.Observation;

/**
 * Created by andrey on 4/2/15.
 */
public class IdActivity extends AsyncTask <String, Void, Boolean>{
    private Context mContext;
    private Observation mobservation;
    private ObservationDBHandler db;


    public IdActivity(Context context, int observationId)
    {
        mContext = context;
        db = new ObservationDBHandler(mContext);
        mobservation = ObservationFactory.getObservation(observationId, context);

    }
    @Override
    protected void onPreExecute()
    {
        mobservation.setBeingProcessed(true);
    }

    @Override
    protected Boolean doInBackground(String... params) {
        boolean detectionResult = Util.detectImage(params[0], mContext);
        return detectionResult;
    }
    @Override
    protected void onPostExecute(Boolean detectionResult)
    {
        db.updateProcessed(mobservation.getId(), true);
        Toast message;
        mobservation.setBeingProcessed(false);
        if (detectionResult)
        {
            message = Toast.makeText(mContext, "This is Silene acaulis!!!", Toast.LENGTH_LONG);
            mobservation.updateIsSilene(mContext);

        }
        else
        {
            message = Toast.makeText(mContext, "Your image was not a Silene acaulis ", Toast.LENGTH_LONG);


        }
        db.close();
        message.show();



    }
}
