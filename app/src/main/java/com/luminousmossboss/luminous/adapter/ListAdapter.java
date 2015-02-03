package com.luminousmossboss.luminous.adapter;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.luminousmossboss.luminous.R;
import com.luminousmossboss.luminous.model.ListItem;

import java.util.ArrayList;

/**
 * Created by Brian on 2/2/2015.
 */
public interface ListAdapter  {

    //public ListAdapter(Context context, ArrayList<ListItem> listItems);

    public int getCount();

    public Object getItem(int position);

    public long getItemId(int position);

    public View getView(int position, View convertView, ViewGroup parent);

}
