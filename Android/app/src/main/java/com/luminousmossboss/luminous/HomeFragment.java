package com.luminousmossboss.luminous;

import android.app.Activity;
import android.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageButton;
import android.view.View.OnClickListener;

public class HomeFragment extends Fragment implements OnClickListener, BackButtonInterface {

    private ImageButton btn_fieldGuide;
    private ImageButton btn_addObservation;
    private ImageButton btn_myObservations;
    public HomeFragment(){}

    @Override
    public Boolean allowedBackPressed() {
        return true;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_home, container, false);

        final Activity activity = getActivity();

        // Handle Button Events
        btn_fieldGuide = (ImageButton) rootView.findViewById(R.id.Field_Guide_button);
        btn_fieldGuide.setOnClickListener(this);
        btn_addObservation = (ImageButton) rootView.findViewById(R.id.add_observation_button);
        btn_addObservation.setOnClickListener(this);
        btn_myObservations = (ImageButton) rootView.findViewById(R.id.my_observation_button);
        btn_myObservations.setOnClickListener(this);
        return rootView;
    }

    @Override
    public void onClick(View v) {
        final Activity activity = getActivity();
        switch (v.getId())
        {
            case R.id.Field_Guide_button:
                if(activity instanceof MainActivity)
                    ((MainActivity) activity).displayView(new FieldGuideFragment());
                    break;
            case R.id.add_observation_button:
                if(activity instanceof MainActivity) {
                    ((MainActivity) activity).startObservation();
                }
            case R.id.my_observation_button:
                if(activity instanceof MainActivity) {
                    ((MainActivity) activity).displayView(new ObservationListFragment());
                }
                break;
        }
    }
}