package com.luminousmossboss.luminous.adapter;

import java.util.ArrayList;

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
import com.luminousmossboss.luminous.model.NavDrawerItem;

public class NavDrawerListAdapter extends FragListAdapter {

    public NavDrawerListAdapter(Context context, ArrayList<ListItem> navDrawerItems){
        super(context,navDrawerItems);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        if (convertView == null) {
            LayoutInflater mInflater = (LayoutInflater)
                    context.getSystemService(Activity.LAYOUT_INFLATER_SERVICE);
            convertView = mInflater.inflate(R.layout.nav_drawer_items, null);
        }

        ImageView imgIcon = (ImageView) convertView.findViewById(R.id.icon);
        TextView txtTitle = (TextView) convertView.findViewById(R.id.title);
        TextView txtCount = (TextView) convertView.findViewById(R.id.counter);


        imgIcon.setImageResource(listItems.get(position).getIcon());
        txtTitle.setText(listItems.get(position).getTitle());

        // displaying count
        // check whether it set visible or not
        NavDrawerItem navDrawerItem = (NavDrawerItem) listItems.get(position);

        if(navDrawerItem.getCounterVisibility()){
            txtCount.setText(navDrawerItem.getCount());
        }else{
            // hide the counter view
            txtCount.setVisibility(View.GONE);
        }

        return convertView;
    }

}