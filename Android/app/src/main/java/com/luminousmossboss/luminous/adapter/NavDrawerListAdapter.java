package com.luminousmossboss.luminous.adapter;

import java.util.ArrayList;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
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
            convertView = mInflater.inflate(R.layout.item_nav_drawer, null);
        }

        convertView = basicView(position, convertView);
        NavDrawerItem item = (NavDrawerItem) listItems.get(position);

        TextView txtCount = (TextView) convertView.findViewById(R.id.counter);
        // displaying count
        // check whether it set visible or not
        if(item.getCounterVisibility()){
            txtCount.setText(item.getCount());
        }else{
            // hide the counter view
            txtCount.setVisibility(View.GONE);
        }
        return convertView;
    }

}