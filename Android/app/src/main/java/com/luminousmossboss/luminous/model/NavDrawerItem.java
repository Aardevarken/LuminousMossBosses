package com.luminousmossboss.luminous.model;

public class NavDrawerItem extends ListItem{

    private String count = "0";
    // boolean to set visiblity of the counter
    private boolean isCounterVisible = false;

    public NavDrawerItem(){}

    public NavDrawerItem(String title, int icon){
        super(title, icon);
    }

    public NavDrawerItem(String title, int icon, boolean isCounterVisible, int count) {
        super(title, icon);
        this.isCounterVisible = isCounterVisible;
        this.count = Integer.toString(count);
    }

    public String getCount(){
        return this.count;
    }

    public boolean getCounterVisibility(){
        return this.isCounterVisible;
    }

    public void setCount(int count){
        this.count = Integer.toString(count);
    }

    public void setCounterVisibility(boolean isCounterVisible){
        this.isCounterVisible = isCounterVisible;
    }
}