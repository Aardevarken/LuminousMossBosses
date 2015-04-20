package dialog;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.DialogFragment;
import android.app.Fragment;
import android.content.DialogInterface;
import android.os.Bundle;

import com.luminousmossboss.luminous.IdActivity;
import com.luminousmossboss.luminous.MainActivity;
import com.luminousmossboss.luminous.ObservationFragment;
import com.luminousmossboss.luminous.R;
import com.luminousmossboss.luminous.model.Observation;

/**
 * Created by Brian on 4/6/2015.
 */
public class IdentifiyDialogFragment extends DialogFragment{
    private int observationId;
    public static IdentifiyDialogFragment getInstance(int obsId) {
        IdentifiyDialogFragment fragment = new IdentifiyDialogFragment();

        Bundle args = new Bundle();
        args.putInt("obsId", obsId);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        observationId = getArguments().getInt("obsId");
        builder.setMessage(R.string.dialog_identify_obs_msg)
                .setPositiveButton(R.string.dialog_confirm, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog,int id) {
                        Observation observation = new Observation(observationId, getActivity());
                        IdActivity idActivity = new IdActivity(getActivity());
                        idActivity.execute(observation.getIcon().getPath());

                        CharSequence fragTitle = observation.getTitle();
                        Fragment fragment = null;
                        Activity activity = getActivity();
                        fragment = ObservationFragment.newInstance(observation);
                        ((MainActivity) activity).setTitle(fragTitle);
                        ((MainActivity) activity).displayView(fragment);

                        //Save

                    }
                })
                .setNeutralButton(R.string.dialog_neutral, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        Observation observation = new Observation(observationId, getActivity());
                        CharSequence fragTitle = observation.getTitle();
                        Fragment fragment = null;
                        Activity activity = getActivity();
                        fragment = ObservationFragment.newInstance(observation);
                        ((MainActivity) activity).setTitle(fragTitle);
                        ((MainActivity) activity).displayView(fragment);
                    }
                })
                .setNegativeButton(R.string.dialog_decline, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int id) {
                        // Don't Save
                    }
                });
        return builder.create();
    }
}
