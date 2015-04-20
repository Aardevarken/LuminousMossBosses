package com.luminousmossboss.luminous;

import android.app.Activity;
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
        mobservation = new Observation(observationId, context);
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
        if (detectionResult)
        {
            message = Toast.makeText(mContext, "Your image was identified as Silene!!!", Toast.LENGTH_LONG);
            db.updateIsSilene(mobservation.getId(),true);

        }
        else
        {
            message = Toast.makeText(mContext, "Your image was not a silene. Are you sure it isn't a cow or a pink firetruck?", Toast.LENGTH_LONG);
            db.updateIsSilene(mobservation.getId(),false);

        }
        message.show();

    }
}
