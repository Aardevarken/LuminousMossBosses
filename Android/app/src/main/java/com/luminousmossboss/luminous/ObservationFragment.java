package com.luminousmossboss.luminous;

import android.app.Activity;
import android.app.Fragment;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.os.Environment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;

import com.luminousmossboss.luminous.model.ObservationListItem;
import com.squareup.picasso.Picasso;

import java.io.File;

public class ObservationFragment extends Fragment implements OnClickListener {

    private final static String OBSERVATION_KEY = "observation_key";

    private ImageView mImageView;
    private Button show_button;
    private ObservationListItem observation;

    public ObservationFragment()  { }

    public static ObservationFragment newInstance(ObservationListItem observation)
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

        View rootView = inflater.inflate(R.layout.edit_observation, container, false);


        this.mImageView = (ImageView) rootView.findViewById(R.id.imageView);
        final Activity activity = getActivity();
        Bundle bundle = getArguments();
        this.observation = (ObservationListItem) bundle.getSerializable(OBSERVATION_KEY);
        Picasso.with(getActivity()).load(observation.getIcon()).into(mImageView);


        // Handle Button Events

        return rootView;
    }


    @Override
    public void onClick(View v) {

    }
}
