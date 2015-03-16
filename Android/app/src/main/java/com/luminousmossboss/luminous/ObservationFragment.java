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

public class ObservationFragment extends Fragment implements OnClickListener {

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
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.view_observation, container, false);


        ImageView imageView = (ImageView) rootView.findViewById(R.id.imageView);
        TextView details = (TextView) rootView.findViewById(R.id.details);

        final Activity activity = getActivity();
        Bundle bundle = getArguments();
        this.observation = (Observation) bundle.getSerializable(OBSERVATION_KEY);
        imageView.setImageURI(observation.getIcon());
        Picasso.with(getActivity()).load(observation.getIcon()).into(imageView);

        details.setText("Date take: " + observation.getDate() + " \n Time:" + observation.getFullDate().substring(10) +"\n");

        // Handle Button Events
        Button sendButton = (Button) rootView.findViewById(R.id.button_send);
        sendButton.setOnClickListener(this);

        return rootView;
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case R.id.button_send:
                new SendPostActivity(getActivity()).execute(observation);


        }


    }
}
