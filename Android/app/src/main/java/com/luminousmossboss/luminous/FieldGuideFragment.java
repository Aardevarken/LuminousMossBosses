package com.luminousmossboss.luminous;

import android.app.Activity;
import android.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;

public class FieldGuideFragment extends Fragment {

    public FieldGuideFragment(){}

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_fieldguide, container, false);

        final Activity activity = getActivity();

        return rootView;
    }
}