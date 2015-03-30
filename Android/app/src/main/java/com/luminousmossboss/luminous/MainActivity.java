package com.luminousmossboss.luminous;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;

import android.app.Activity;
import android.app.Fragment;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.content.res.TypedArray;
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


public class MainActivity extends Activity {
    private DrawerLayout mDrawerLayout;
    private ListView mDrawerList;
    private ActionBarDrawerToggle mDrawerToggle;

    //For handling location
   protected GPSTracker mGPS;
   private DbHandler db;

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
        db = new DbHandler(this);

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
        ((NavDrawerItem) navDrawerItems.get(3)).setCounterVisibility(true);
        ((NavDrawerItem) navDrawerItems.get(3)).setCount(2);

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
    protected void displayView(int position) {
        // update the main content by replacing fragments
        //int icon = R.drawable.ic_launcher;
        switch (position) {
            case 0:
                displayView(new HomeFragment());
                //icon = R.drawable.ic_home;
                break;
            case 1:
                startObservation();
                break;
            case 2:
                displayView(new ObservationListFragment());
                //fragment = new ObservationListFragment();
                //icon = R.drawable.ic_notepage;
                break;
            case 3:
                displayView(new FieldGuideListFragment());
                //icon = R.drawable.ic_openbook;
                break;

            default:
                break;
        }
        mDrawerList.setItemChecked(position, true);
        mDrawerList.setSelection(position);
        setTitle(navMenuTitles[position]);
        mDrawerLayout.closeDrawer(mDrawerList);
        /*if (fragment != null) {
            FragmentManager fragmentManager = getFragmentManager();
            //fragmentManager.beginTransaction()
            //.replace(R.id.frame_container, fragment).commit();
            FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
            fragmentTransaction.replace(R.id.frame_container, fragment);

            fragmentTransaction.setTransition(FragmentTransaction.TRANSIT_FRAGMENT_FADE);
            fragmentTransaction.commit();

            // update selected item and title, then close the drawer
            mDrawerList.setItemChecked(position, true);
            mDrawerList.setSelection(position);
            setTitle(navMenuTitles[position]);
            getActionBar().setIcon(icon);
            mDrawerLayout.closeDrawer(mDrawerList);
        } else {
            // error in creating fragment
            Log.e("MainActivity", "Error in creating fragment");
        }*/
    }
    public void displayView(Fragment fragment) {
        if (fragment != null) {
            FragmentManager fragmentManager = getFragmentManager();
            FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
            fragmentTransaction.replace(R.id.frame_container, fragment);

            fragmentTransaction.setTransition(FragmentTransaction.TRANSIT_FRAGMENT_FADE);
            fragmentTransaction.commit();
        } else {
            Log.e("MainActivity", "Error in creating fragment");
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

    private boolean detectImage(String image_path) {
        File flowerXML = rawToFile(R.raw.flower);
        File vocabXML = rawToFile(R.raw.vocabulary);
        File sileneXML = rawToFile(R.raw.silene);
        // create the detector
        SileneDetector sileneDetector = new SileneDetector(flowerXML.getAbsolutePath(),
                                                           vocabXML.getAbsolutePath(),
                                                           sileneXML.getAbsolutePath());
        // run the detection
        return sileneDetector.isSilene(image_path);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case REQUEST_TAKE_PHOTO: {
                if (resultCode == RESULT_OK) {
                    handlePhoto(data);
                    boolean detectionResult = detectImage(mCurrentPhotoPath);
                    Toast message;
                    if (detectionResult)
                    {
                        message = Toast.makeText(this, "Your image was identified as Silene!!!", Toast.LENGTH_LONG);
                    }
                    else
                    {
                        message = Toast.makeText(this, "Your image was not a silene. Are you sure it isn't a cow or a pink firetruck?", Toast.LENGTH_LONG);
                    }
                    message.show();
                }
                break;
            }
        } // switch
    }

    // creates new file from a raw resource in the file_resources folder
    // Adapted from Eduardo's answer at stackoverflow.com/questions/17189214
    private File rawToFile (int resId)
    {
        InputStream is = getResources().openRawResource(resId);
        File dir = getDir("file_resources", Context.MODE_PRIVATE);
        File file = new File(dir, Integer.toString(resId));
        try
        {
            FileOutputStream os = new FileOutputStream(file);

            byte[] buff = new byte[4096];
            int bytesRead;
            while ((bytesRead = is.read(buff)) != -1)
            {
                os.write(buff, 0, bytesRead);
            }
            is.close();
            os.close();
        }
        catch (IOException e)
        {
            e.printStackTrace();
            Log.v("MainActivity", "Failed to load silene classifier. Exception thrown: " + e);
        }
        return file;
    }

    private void handlePhoto(Intent intent)
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
            Toast.makeText(this, "We have your image: " + mCurrentPhotoPath, Toast.LENGTH_LONG).show();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSSZ", Locale.US);
            String timeNow = sdf.format(new Date());
            HashMap<String, String> map = new HashMap<String, String>();
            map.put(DbHandler.KEY_GPS_ACCURACY, String.valueOf(loc.getAccuracy()));
//            map.put(DbHandler.KEY_IS_SILENE, String.valueOf(wasPicSilene));
            map.put(DbHandler.KEY_LATITUDE, String.valueOf(loc.getLatitude()));
            map.put(DbHandler.KEY_LONGITUDE, String.valueOf(loc.getLongitude()));
            map.put(DbHandler.KEY_PHOTO_PATH, mCurrentPhotoPath);
            map.put(DbHandler.KEY_SYNCED_STATUS, String.valueOf(0));
            map.put(DbHandler.KEY_TIME_TAKEN, timeNow);

            db.addObservation(map);
        }
    }
}
