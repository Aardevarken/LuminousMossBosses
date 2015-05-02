package com.luminousmossboss.luminous;

import android.app.DialogFragment;
import android.app.Fragment;
import android.database.Cursor;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.luminousmossboss.luminous.BackButtonInterface;
import com.luminousmossboss.luminous.IdActivity;
import com.luminousmossboss.luminous.MainActivity;
import com.luminousmossboss.luminous.ObservationDBHandler;
import com.luminousmossboss.luminous.R;
import com.luminousmossboss.luminous.SendPostActivity;
import com.luminousmossboss.luminous.adapter.DataListAdapter;
import com.luminousmossboss.luminous.model.DataItem;
import com.luminousmossboss.luminous.model.ListItem;
import com.luminousmossboss.luminous.model.Observation;
import com.squareup.picasso.Picasso;

import java.util.ArrayList;

import dialog.DeleteDialogFragment;
import dialog.DialogListener;

public class AboutFragment extends Fragment implements BackButtonInterface {
    public AboutFragment()  {
    }


    @Override
    public Boolean allowedBackPressed() {
        return true;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        setHasOptionsMenu(true);

        View rootView = inflater.inflate(R.layout.fragment_about, container, false);

        ArrayList<ListItem> listItems = new ArrayList<ListItem>();

        ImageView imageView = (ImageView) rootView.findViewById(R.id.imageView);
        TextView title = (TextView) rootView.findViewById(R.id.title);
        ListView dataSet = (ListView) rootView.findViewById(R.id.listView);

        Bundle bundle = getArguments();
        //Picasso.with(getActivity()).load(observation.getIcon()).fit().centerInside().into(imageView);

        String[] about_text_items = getResources().getStringArray(R.array.about_text_items);
        String[] about_title_items = getResources().getStringArray(R.array.about_title_items);

        title.setText("About");

        int max = Math.max(about_text_items.length,about_title_items.length);
        for (int i = 0; i < max; i++) {
            listItems.add(new DataItem(about_title_items[i], about_text_items[i]));
        }

        DataListAdapter adapter = new DataListAdapter(container.getContext(), listItems);
        dataSet.setAdapter(adapter);
        return rootView;
    }

}
