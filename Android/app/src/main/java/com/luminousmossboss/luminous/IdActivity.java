package com.luminousmossboss.luminous;

import android.content.Context;
import android.os.AsyncTask;
import android.view.View;
import android.widget.Button;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.luminousmossboss.luminous.model.Observation;

/**
 * Created by andrey on 4/2/15.
 */
public class IdActivity extends AsyncTask <String, Void, Boolean>{
    private Context mContext;
    private Observation mobservation;
    private ObservationDBHandler db;
    private ProgressBar progressBar;
    private Button sendButton;
    private ObservationFragment parentFragment;


    public IdActivity(Context context, int observationId, ObservationFragment startingFragment)
    {
        this.parentFragment = startingFragment;
        if (startingFragment.getProgressBar() == null)
        this.progressBar = startingFragment.getProgressBar();
        this.sendButton = startingFragment.getSendButton();
        mContext = context;
        db = new ObservationDBHandler(mContext);
        mobservation = ObservationFactory.getObservation(observationId, context);

    }
    @Override
    protected void onPreExecute()
    {
        mobservation.setBeingProcessed(true);
        try {
            parentFragment.getSendButton().setVisibility(View.GONE);
            parentFragment.getSendButton().setEnabled(false);
            parentFragment.getProgressBar().setVisibility(View.VISIBLE);
        } catch (Exception e) {
        }
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
        mobservation.setHasBeenProcceced();
        progressBar = parentFragment.getProgressBar();
        sendButton = parentFragment.getSendButton();
        if (detectionResult)
        {
            message = Toast.makeText(mContext, R.string.id_silene_acaulis, Toast.LENGTH_LONG);
            mobservation.updateIsSilene(mContext);
           TextView title= (TextView) parentFragment.getView().findViewById(R.id.title);
           title.setText(R.string.silene_acaulis);

        }
        else
        {
            message = Toast.makeText(mContext, R.string.id_unknown, Toast.LENGTH_LONG);


        }
        progressBar.setVisibility(View.GONE);
        sendButton.setEnabled(true);
        sendButton.setVisibility(View.VISIBLE);
        sendButton.setText("Send");
        parentFragment.setButtonContextSend();
        parentFragment.detachIdActivity();
        db.close();
        message.show();



    }

    public void attachFragment(ObservationFragment fragment) {
        parentFragment = fragment;
    }
}
