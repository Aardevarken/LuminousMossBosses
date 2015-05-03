package dialog;

import android.app.DialogFragment;

import java.io.Serializable;

/**
 * Created by Brian on 4/8/2015.
 */
public interface DialogListener extends Serializable {
    public void onDialogPositiveClick(DialogFragment dialog);
    public void onDialogNegativeClick(DialogFragment dialog);
    //public void onDialogNeutralClick(DialogFragment dialog);
}
