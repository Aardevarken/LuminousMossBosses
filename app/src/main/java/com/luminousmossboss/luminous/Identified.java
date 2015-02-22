package com.luminousmossboss.luminous;

/**
 * Created by aardevarken on 2/22/15.
 */
public class Identified {
    private boolean OpenCV;
    private int x;
    private int y;
    private int r;
    private double glx;
    private double gly;
    private double glr;

    private int convertToCVx(double glx, int width, double asp_src)
    {
        return (int)(glx+asp_src) * (int)((double)width/2/asp_src);
    }

    private int convertToCVy(double gly, int height)
    {
        return (int)(gly-1)*(height/2);
    }

    private int convertToCVr(double glr, int width, int height, double asp_src)
    {
        return 1;
    }
}
