package dialog;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.DialogFragment;
import android.app.Fragment;
import android.app.FragmentManager;
import android.content.DialogInterface;
import android.os.Bundle;

import com.luminousmossboss.luminous.DbHandler;
import com.luminousmossboss.luminous.MainActivity;
import com.luminousmossboss.luminous.ObservationFragment;
import com.luminousmossboss.luminous.R;
import com.luminousmossboss.luminous.model.Observation;

/**
 * Created by Brian on 4/6/2015.
 */
public class DeleteDialogFragment extends DialogFragment{

    private DialogListener mListener;

    public static DeleteDialogFragment getInstance(DialogListener dialogListener) {
        DeleteDialogFragment deleteDialogFragment = new DeleteDialogFragment();

        Bundle args = new Bundle();
        args.putSerializable("dialogListener", dialogListener);
        return deleteDialogFragment;

    }

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());

        mListener = (DialogListener) getArguments().getSerializable("dialogListener");

        builder.setMessage(R.string.dialog_remove_obs_msg)
                .setPositiveButton(R.string.dialog_confirm, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int id) {
                        mListener.onDialogPositiveClick(DeleteDialogFragment.this);
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
