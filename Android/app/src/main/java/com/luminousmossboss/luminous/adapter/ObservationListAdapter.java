package com.luminousmossboss.luminous.adapter;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.luminousmossboss.luminous.R;
import com.luminousmossboss.luminous.model.ListItem;
import com.luminousmossboss.luminous.model.Observation;
import com.luminousmossboss.luminous.model.Separator;

import java.util.ArrayList;

/**
 *
 * Created by Brian on 2/2/2015.
 */

public class ObservationListAdapter extends FragListAdapter  {

    //private Context context;
    //private ArrayList<ListItem> listItems;

    public ObservationListAdapter(Context context, ArrayList<ListItem> listItems) {
        //this.context = context;
        //this.listItems = listItems;
        super(context, listItems);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        ListItem listitem = listItems.get(position);

        //if (convertView == null) {
            LayoutInflater mInflater = (LayoutInflater)
                    context.getSystemService(Activity.LAYOUT_INFLATER_SERVICE);
            if(listitem instanceof Observation)
                convertView = mInflater.inflate(R.layout.item_myobservations, null);
            if(listitem instanceof Separator)
                convertView = mInflater.inflate(R.layout.item_seperator, null);
        //}

        if(listitem instanceof Observation) {
            convertView = basicView(position,convertView);
            //Observation item = (Observation) listItems.get(position);

            TextView date = (TextView) convertView.findViewById(R.id.date);
            date.setText(((Observation) listitem).getDate());
        }
        else if (listitem instanceof Separator) {
            convertView = basicSeparator(position, convertView);
        }

        return convertView;
    }

    public View getSepartor(int position, View convertView, ViewGroup parent, String label_text) {
       if (convertView == null) {
           LayoutInflater mInflater = (LayoutInflater)
                   context.getSystemService(Activity.LAYOUT_INFLATER_SERVICE);
           convertView = mInflater.inflate(R.layout.item_seperator, null);
       }

        convertView = basicView(position, convertView);
        TextView label = (TextView) convertView.findViewById(R.id.title);
        label.setText(label_text);

        return convertView;
    }

}
