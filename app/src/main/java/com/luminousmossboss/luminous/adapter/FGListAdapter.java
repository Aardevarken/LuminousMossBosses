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

/**
 * Created by Brian on 2/2/2015.
 */
public class FGListAdapter extends BaseAdapter implements ListAdapter {

    private Context context;
    private ArrayList<ListItem> listItems;

    public FGListAdapter(Context context, ArrayList<ListItem> listItems) {
        this.context = context;
        this.listItems = listItems;
    }

    @Override
    public int getCount() { return listItems.size(); }

    @Override
    public Object getItem(int position) { return listItems.get(position); }

    @Override
    public long getItemId(int position) { return position; }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        if (convertView == null) {
            LayoutInflater mInflater = (LayoutInflater)
                    context.getSystemService(Activity.LAYOUT_INFLATER_SERVICE);
            convertView = mInflater.inflate(R.layout.item_fieldguide, null);
        }

        ImageView imgIcon = (ImageView) convertView.findViewById(R.id.icon);
        TextView txtTitle = (TextView) convertView.findViewById(R.id.title);

        imgIcon.setImageResource(listItems.get(position).getIcon());
        txtTitle.setText(listItems.get(position).getTitle());

        return convertView;
    }

}
