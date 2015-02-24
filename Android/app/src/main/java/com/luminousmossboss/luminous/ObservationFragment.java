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

import java.io.File;

public class ObservationFragment extends Fragment implements OnClickListener {

    private ImageView mImageView;
    Button show_button;
    DbHandler db;
    public ObservationFragment(){}
    Cursor cursor = null;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.edit_observation, container, false);

        mImageView = (ImageView) rootView.findViewById(R.id.imageView);
        show_button = (Button) rootView.findViewById(R.id.button_show);
        show_button.setOnClickListener(this);
        final Activity activity = getActivity();
        db = new DbHandler(activity);
        cursor = db.getAllObservation();
        cursor.moveToFirst();

        // Handle Button Events

        return rootView;
    }

    @Override
    public void onClick(View v) {
        final Activity activity = getActivity();
        switch (v.getId())
        {
            case R.id.button_show:
                String path =  getImagePath();
                if( path != null)
                {
                    setPic(path);
                }
                break;

        }
    }
    private String getImagePath(){
      String result =null;


      if(cursor.moveToNext())
      {
          result = cursor.getString(cursor.getColumnIndex(DbHandler.KEY_PHOTO_PATH));

      }


      return result;

    }
    private void setPic(String mCurrentPhotoPath) {
        // Get the dimensions of the View
        int targetW = mImageView.getWidth();
        int targetH = mImageView.getHeight();

        // Get the dimensions of the bitmap
        BitmapFactory.Options bmOptions = new BitmapFactory.Options();
        bmOptions.inJustDecodeBounds = true;
        BitmapFactory.decodeFile(mCurrentPhotoPath, bmOptions);
        int photoW = bmOptions.outWidth;
        int photoH = bmOptions.outHeight;

        // Determine how much to scale down the image
        int scaleFactor = Math.min(photoW/targetW, photoH/targetH);

        // Decode the image file into a Bitmap sized to fill the View
        bmOptions.inJustDecodeBounds = false;
        bmOptions.inSampleSize = scaleFactor;
        bmOptions.inPurgeable = true;

        Bitmap bitmap = BitmapFactory.decodeFile(mCurrentPhotoPath, bmOptions);
        mImageView.setImageBitmap(bitmap);
    }
}