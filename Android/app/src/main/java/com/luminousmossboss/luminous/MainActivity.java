package com.luminousmossboss.luminous;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;

import android.app.Activity;
import android.app.Fragment;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.content.Intent;
import android.content.res.Configuration;
import android.content.res.TypedArray;
import android.database.Cursor;
import android.location.Location;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.v4.app.ActionBarDrawerToggle;
import android.support.v4.widget.DrawerLayout;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.Toast;

import com.luminousmossboss.luminous.adapter.NavDrawerListAdapter;
import com.luminousmossboss.luminous.model.ListItem;
import com.luminousmossboss.luminous.model.NavDrawerItem;

import dialog.IdentifiyDialogFragment;


public class MainActivity extends Activity {
    private DrawerLayout mDrawerLayout;
    private ListView mDrawerList;
    private ActionBarDrawerToggle mDrawerToggle;

    public static final int HOME_POSITION = 0;
    public static final int OBSERVATION_POSITION = 1;
    public static final int OBSERVATION_LIST_POSITION = 2;
    public static final int SYNC_OBSERVATION_POSITION = 3;
    public static final int FIELD_GUIDE_POSITION = 4;
    public static final int ABOUT_POSITION = 5;
    public static final int SETTINGS_POSITION = 6;
    public static final int HELP_POSITION = 7;

    //For handling location
    protected GPSTracker mGPS;
    private ObservationDBHandler db;

    //For keeping track of the Photo:
    String mCurrentPhotoPath;
    // nav drawer title
    private CharSequence mDrawerTitle;

    // used to store app title
    private CharSequence mTitle;

    // slide menu items
    private String[] navMenuTitles;
    private TypedArray navMenuIcons;

    private ArrayList<ListItem> navDrawerItems;
    private NavDrawerListAdapter adapter;

    static final int REQUEST_TAKE_PHOTO = 2;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        mTitle = mDrawerTitle = getTitle();
        mGPS = new GPSTracker(this);
        db = new ObservationDBHandler(this);

        // load slide menu items
        navMenuTitles = getResources().getStringArray(R.array.nav_drawer_items);

        // nav drawer icons from resources
        navMenuIcons = getResources()
                .obtainTypedArray(R.array.nav_drawer_icons);

        mDrawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout);
        mDrawerList = (ListView) findViewById(R.id.list_slidermenu);

        navDrawerItems = new ArrayList<ListItem>();

        for (int i = 0; i < navMenuTitles.length; i++) {
            Uri iconUri = Util.resIdToUri(this, navMenuIcons.getResourceId(i, -1));
            navDrawerItems.add(new NavDrawerItem(navMenuTitles[i], iconUri));
        }
        ((NavDrawerItem) navDrawerItems.get(FIELD_GUIDE_POSITION)).setCounterVisibility(true);
        ((NavDrawerItem) navDrawerItems.get(FIELD_GUIDE_POSITION)).setCount(2);

        // Recycle the typed array
        navMenuIcons.recycle();

        // setting the nav drawer list adapter
        adapter = new NavDrawerListAdapter(getApplicationContext(),
                navDrawerItems);
        mDrawerList.setAdapter(adapter);

        // enabling action bar app icon and behaving it as toggle button
        getActionBar().setDisplayHomeAsUpEnabled(true);
        getActionBar().setHomeButtonEnabled(true);

        mDrawerToggle = new ActionBarDrawerToggle(this, mDrawerLayout,
                R.drawable.ic_drawer, //nav menu toggle icon
                R.string.app_name, // nav drawer open - description for accessibility
                R.string.app_name // nav drawer close - description for accessibility
        ) {
            public void onDrawerClosed(View view) {
                getActionBar().setTitle(mTitle);
                // calling onPrepareOptionsMenu() to show action bar icons
                invalidateOptionsMenu();
            }

            public void onDrawerOpened(View drawerView) {
                getActionBar().setTitle(mDrawerTitle);
                // calling onPrepareOptionsMenu() to hide action bar icons
                invalidateOptionsMenu();
            }
        };
        mDrawerLayout.setDrawerListener(mDrawerToggle);

        if (savedInstanceState == null) {
            // on first time display view for first nav item
            displayView(0);
        }
        mDrawerList.setOnItemClickListener(new SlideMenuClickListener());
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // toggle nav drawer on selecting action bar app icon/title
        if (mDrawerToggle.onOptionsItemSelected(item)) {
            return true;
        }
        // Handle action bar actions click
        switch (item.getItemId()) {
            case R.id.action_settings:
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    /**
     * Called when invalidateOptionsMenu() is triggered
     */
    @Override
    public boolean onPrepareOptionsMenu(Menu menu) {
        // if nav drawer is opened, hide the action items
        boolean drawerOpen = mDrawerLayout.isDrawerOpen(mDrawerList);
        menu.findItem(R.id.action_settings).setVisible(!drawerOpen);
        return super.onPrepareOptionsMenu(menu);
    }

    @Override
    public void setTitle(CharSequence title) {
        mTitle = title;
        getActionBar().setTitle(mTitle);
    }

    @Override
    public void setTitle(int position) {
        mTitle = navMenuTitles[position];
        getActionBar().setTitle(mTitle);
    }

    /**
     * When using the ActionBarDrawerToggle, you must call it during
     * onPostCreate() and onConfigurationChanged()...
     */

    @Override
    protected void onPostCreate(Bundle savedInstanceState) {
        super.onPostCreate(savedInstanceState);
        // Sync the toggle state after onRestoreInstanceState has occurred.
        mDrawerToggle.syncState();
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        // Pass any configuration change to the drawer toggls
        mDrawerToggle.onConfigurationChanged(newConfig);
    }

    /**
     * Slide menu item click listener
     * */
    private class SlideMenuClickListener implements
            ListView.OnItemClickListener {
        @Override
        public void onItemClick(AdapterView<?> parent, View view, int position,
                                long id) {
            // display view for selected nav drawer item
            displayView(position);
        }
    }

    /**
     * Diplaying fragment view for selected nav drawer list item
     * */
   public void displayView(int position) {
        // update the main content by replacing fragments
        //int icon = R.drawable.ic_launcher;
        switch (position) {
            case HOME_POSITION:
                displayView(new HomeFragment());
                //icon = R.drawable.ic_home;
                break;
            case OBSERVATION_POSITION:
                startObservation();
                break;
            case OBSERVATION_LIST_POSITION:
                displayView(new ObservationListFragment());
                //fragment = new ObservationListFragment();
                //icon = R.drawable.ic_notepage;
                break;
            case FIELD_GUIDE_POSITION:
                displayView(new FieldGuideListFragment());
                //icon = R.drawable.ic_openbook;
                break;

            default:
                break;
        }
        mDrawerList.setItemChecked(position, true);
        mDrawerList.setSelection(position);
        mDrawerLayout.closeDrawer(mDrawerList);
    }
    public void displayView(Fragment fragment) {
        if (fragment != null) {
            FragmentManager fragmentManager = getFragmentManager();
            FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
            fragmentTransaction.replace(R.id.frame_container, fragment, "TAG");

            fragmentTransaction.setTransition(FragmentTransaction.TRANSIT_FRAGMENT_FADE);
            fragmentTransaction.addToBackStack(null);
            fragmentTransaction.commit();
        } else {
            Log.e("MainActivity", "Error in creating fragment");
        }
    }

    @Override
    public void onBackPressed() {
        final BackButtonInterface fragment = (BackButtonInterface) getFragmentManager().findFragmentByTag("TAG");
        int stackSize = getFragmentManager().getBackStackEntryCount();
        if (fragment.allowedBackPressed() && stackSize > 1) {
            super.onBackPressed();
        } else if (stackSize <= 1) {
            finish();
            System.exit(0);
        }
    }

    private File createImageFile() throws IOException {


        // Create an image file name
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        String imageFileName = "JPEG_" + timeStamp + "_";
        File storageDir = Environment.getExternalStoragePublicDirectory(
                Environment.DIRECTORY_PICTURES);
        File image = File.createTempFile(
                imageFileName,  /* prefix */
                ".jpg",         /* suffix */
                storageDir      /* directory */
        );

        // Save a file: path for use with ACTION_VIEW intents
        mCurrentPhotoPath =  image.getAbsolutePath();
        return image;
    }

    public void startObservation()
    {
        if(mGPS.canGetLocation())
        {
            Intent takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
            // Ensure that there's a camera activity to handle the intent
            if (takePictureIntent.resolveActivity(getPackageManager()) != null) {
                // Create the File where the photo should go
                File photoFile = null;
                try {
                    photoFile = createImageFile();
                } catch (IOException ex) {
                    // Error occurred while creating the File

                }
                // Continue only if the File was successfully created
                if (photoFile != null) {
                    takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT,
                            Uri.fromFile(photoFile));
                    startActivityForResult(takePictureIntent, REQUEST_TAKE_PHOTO);
                }
            }

        }
        else
        {
            mGPS.showSettingsAlert();
        }
    }



    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case REQUEST_TAKE_PHOTO: {
                if (resultCode == RESULT_OK) {
                  //  boolean detectionResult = Util.detectImage(mCurrentPhotoPath,this);
                    handlePhoto(data,false);

                   /* Toast message;
                    if (detectionResult)
                    {
                        message = Toast.makeText(this, "Your image was identified as Silene!!!", Toast.LENGTH_LONG);
                    }
                    else
                    {
                        message = Toast.makeText(this, "Your image was not a silene. Are you sure it isn't a cow or a pink firetruck?", Toast.LENGTH_LONG);
                    }
                    message.show();*/
                }
                break;
            }
        } // switch
    }




    private void handlePhoto(Intent intent, Boolean is_silene)
    {

        Location loc = mGPS.getLocation();
        if( loc == null || (loc.getLatitude() == 0 && loc.getLongitude() == 0))
        {
            Toast.makeText(this, "No Location available yet. PLease take another photo when location available", Toast.LENGTH_LONG).show();
        }
        else if(mCurrentPhotoPath == null)
        {
            Toast.makeText(this, "Failed to create photo file. Please try again", Toast.LENGTH_LONG).show();
        }
        else
        {

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSSZ", Locale.US);
            String timeNow = sdf.format(new Date());
            HashMap<String, String> map = new HashMap<String, String>();
            map.put(ObservationDBHandler.KEY_GPS_ACCURACY, String.valueOf(loc.getAccuracy()));
            map.put(ObservationDBHandler.KEY_IS_SILENE, String.valueOf(is_silene?1:0));
            map.put(ObservationDBHandler.KEY_LATITUDE, String.valueOf(loc.getLatitude()));
            map.put(ObservationDBHandler.KEY_LONGITUDE, String.valueOf(loc.getLongitude()));
            map.put(ObservationDBHandler.KEY_PHOTO_PATH, mCurrentPhotoPath);
            map.put(ObservationDBHandler.KEY_SYNCED_STATUS, String.valueOf(0));
            map.put(ObservationDBHandler.KEY_TIME_TAKEN, timeNow);
            map.put(ObservationDBHandler.KEY_PROCESSED_STATUS,String.valueOf(0));

            db.addObservation(map);
            Cursor cursor = db.getObservationByFilePath(mCurrentPhotoPath);
            cursor.moveToFirst();
            int id =cursor.getInt(cursor.getColumnIndex(ObservationDBHandler.KEY_ID));
            IdentifiyDialogFragment identifiyDialogFragment = IdentifiyDialogFragment.getInstance(id);
            identifiyDialogFragment.show(getFragmentManager(),"dialog");
        }
    }
}
