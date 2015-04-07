package dialog;

import android.app.AlertDialog;
import android.app.Dialog;
import android.app.DialogFragment;
import android.content.DialogInterface;
import android.os.Bundle;

import com.luminousmossboss.luminous.R;

/**
 * Created by Brian on 4/6/2015.
 */
public class SendDialogFragment extends DialogFragment{
    private boolean confirmation;

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        builder.setMessage(R.string.dialog_send_obs_msg)
                .setPositiveButton(R.string.dialog_confirm, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int id) {
                        confirmation = true;
                    }
                })
                .setNegativeButton(R.string.dialog_decline, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int id) {
                        confirmation = false;
                    }
        });
        return builder.create();
    }

    public boolean getConfirmation() {
        return confirmation;
    }
}
