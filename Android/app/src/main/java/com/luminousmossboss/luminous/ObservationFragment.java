package com.luminousmossboss.luminous;

import android.app.Activity;
import android.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.luminousmossboss.luminous.model.Observation;
import com.squareup.picasso.Picasso;

public class ObservationFragment extends Fragment implements OnClickListener, BackButtonInterface {

    private final static String OBSERVATION_KEY = "observation_key";


    private Button show_button;
    private Observation observation;

    public ObservationFragment()  { }

    public static ObservationFragment newInstance(Observation observation)
    {
        ObservationFragment fragment = new ObservationFragment();
        Bundle bundle = new Bundle();
        bundle.putSerializable(OBSERVATION_KEY, observation);
        fragment.setArguments(bundle);
        return fragment;
    }

    @Override
    public Boolean allowedBackPressed() {
        return true;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_editobservation, container, false);


        ImageView imageView = (ImageView) rootView.findViewById(R.id.imageView);
        //Picasso.with(context).load(listItems.get(position).getIcon()).resize(96,96).centerCrop().onlyScaleDown().into(imgIcon);
        TextView filename = (TextView) rootView.findViewById(R.id.filename);
        TextView date = (TextView) rootView.findViewById(R.id.date);
        TextView latitude_text = (TextView) rootView.findViewById(R.id.latitude);
        TextView longitude_text = (TextView) rootView.findViewById(R.id.longitude);
        TextView title = (TextView) rootView.findViewById(R.id.title);

        final Activity activity = getActivity();
        Bundle bundle = getArguments();
        this.observation = (Observation) bundle.getSerializable(OBSERVATION_KEY);
        imageView.setImageURI(observation.getIcon());
        Picasso.with(getActivity()).load(observation.getIcon()).resize(512,512).centerCrop().onlyScaleDown().into(imageView);


        title.setText(observation.getTitle());
        filename.setText(observation.getIcon().getLastPathSegment());
        date.setText(observation.getDate());

        double longitude = observation.getLongitude();
        double latitude = observation.getLatitude();
        String longiEnd = (longitude >= 0.0)? "E" : "W";
        String latiEnd = (latitude >= 0.0)? "N" : "S";
        latitude_text.setText(Math.abs(latitude) + "\"" + latiEnd);
        longitude_text.setText(Math.abs(longitude) + "\"" + longiEnd);

        // Handle Button Events
        Button sendButton = (Button) rootView.findViewById(R.id.button_send);
        sendButton.setOnClickListener(this);
        Button removeButton = (Button) rootView.findViewById(R.id.button_remove);
        removeButton.setOnClickListener(this);
        imageView.setOnClickListener(this);

        return rootView;
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case R.id.button_send:
                new SendPostActivity(getActivity()).execute(observation);
                break;
            case R.id.button_remove:
                DbHandler db = new DbHandler(getActivity());
                db.deleteObservation(observation.getIcon().getPath());
                MainActivity activity =(MainActivity) getActivity();
                activity.displayView(MainActivity.OBSERVATION_LIST_POSITION);
                break;
            case R.id.imageView:
                IdActivity idActivity = new IdActivity(getActivity());
                idActivity.execute(observation.getIcon().getPath());
                break;
        }
    }
}
