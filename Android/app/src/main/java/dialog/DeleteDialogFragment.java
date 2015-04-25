package dialog;

import android.app.AlertDialog;
import android.app.Dialog;
import android.app.DialogFragment;
import android.app.FragmentManager;
import android.content.DialogInterface;
import android.os.Bundle;

import com.luminousmossboss.luminous.MainActivity;
import com.luminousmossboss.luminous.ObservationDBHandler;
import com.luminousmossboss.luminous.ObservationFactory;
import com.luminousmossboss.luminous.R;

/**
 * Created by Brian on 4/6/2015.
 */
public class DeleteDialogFragment extends DialogFragment{

   private int observationId;

    public static DeleteDialogFragment getInstance(int obsId) {
        DeleteDialogFragment deleteDialogFragment = new DeleteDialogFragment();

        Bundle args = new Bundle();
        args.putInt("obsId", obsId);
        deleteDialogFragment.setArguments(args);
        return deleteDialogFragment;

    }

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());

       observationId = getArguments().getInt("obsId");

        builder.setMessage(R.string.dialog_remove_obs_msg)
                .setPositiveButton(R.string.dialog_confirm, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int id) {
                        ObservationDBHandler db = new ObservationDBHandler(getActivity());
                        db.deleteObservation(observationId);
                        ObservationFactory.removeObservation(observationId);
                        FragmentManager manager = getActivity().getFragmentManager();
                        manager.popBackStack();
                        manager.popBackStack();
                        MainActivity activity =(MainActivity) getActivity();
                        activity.displayView(MainActivity.OBSERVATION_LIST_POSITION);

                    }
                })
                .setNegativeButton(R.string.dialog_decline, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int id) {
                    }
                });
        return builder.create();
    }
}
