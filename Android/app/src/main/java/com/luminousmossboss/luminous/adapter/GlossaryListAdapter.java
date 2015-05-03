package com.luminousmossboss.luminous.adapter;

import android.app.Activity;
import android.content.Context;
import android.content.res.Resources;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.luminousmossboss.luminous.R;
import com.luminousmossboss.luminous.model.GlossaryItem;
import com.luminousmossboss.luminous.model.ListItem;
import com.luminousmossboss.luminous.model.Observation;
import com.luminousmossboss.luminous.model.Separator;
import com.squareup.picasso.Picasso;

import java.util.ArrayList;

/**
 *
 * Created by Brian on 2/2/2015.
 */

public class GlossaryListAdapter extends FragListAdapter {

    //private Context context;
    //private ArrayList<ListItem> listItems;

    public GlossaryListAdapter(Context context, ArrayList<ListItem> listItems) {
        //this.context = context;
        //this.listItems = listItems;
        super(context, listItems);
    }

    @Override
    protected View basicView(int position, View convertView){
        ImageView imgIcon = (ImageView) convertView.findViewById(R.id.icon);
        TextView txtTitle = (TextView) convertView.findViewById(R.id.title);
        if (imgIcon != null)
            Picasso.with(context).load(listItems.get(position).getIcon()).fit().into(imgIcon);
        //imgIcon.setImageURI(listItems.get(position).getIcon());
        //Util.setPic(listItems.get(position).getIcon(),imgIcon);
        txtTitle.setText(listItems.get(position).getTitle());

        return convertView;
    }


    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        ListItem listitem = listItems.get(position);

        //if (convertView == null) {
        LayoutInflater mInflater = (LayoutInflater)
                context.getSystemService(Activity.LAYOUT_INFLATER_SERVICE);
        if(listitem instanceof GlossaryItem)
            if (listitem.getIcon() == null) {
                convertView = mInflater.inflate(R.layout.item_glossary_no_pic, null);
            }
            else
                convertView = mInflater.inflate(R.layout.item_glossary, null);
        if(listitem instanceof Separator)
            convertView = mInflater.inflate(R.layout.item_seperator, null);
        //}

        if(listitem instanceof GlossaryItem) {
            convertView = basicView(position,convertView);
        }
        else if (listitem instanceof Separator) {
            convertView = basicSeparator(position, convertView);
        }

        return convertView;
    }

}