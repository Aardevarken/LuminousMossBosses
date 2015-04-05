package com.luminousmossboss.luminous;

import android.content.Context;
import android.os.AsyncTask;
import android.widget.Toast;

/**
 * Created by andrey on 4/2/15.
 */
public class IdActivity extends AsyncTask <String, Void, Boolean>{
    Context mContext;
    public IdActivity(Context context)
    {
        mContext = context;
    }

    @Override
    protected Boolean doInBackground(String... params) {
        boolean detectionResult = Util.detectImage(params[0], mContext);
        return detectionResult;
    }
    @Override
    protected void onPostExecute(Boolean detectionResult)
    {
        Toast message;
        if (detectionResult)
        {
            message = Toast.makeText(mContext, "Your image was identified as Silene!!!", Toast.LENGTH_LONG);
        }
        else
        {
            message = Toast.makeText(mContext, "Your image was not a silene. Are you sure it isn't a cow or a pink firetruck?", Toast.LENGTH_LONG);
        }
        message.show();
    }
}
